/*
 * Copyright (c) 2016 {UPRC}.
 *
 * OperandoApp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OperandoApp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OperandoApp.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contributors:
 *       Nikos Lykousas {UPRC}, Constantinos Patsakis {UPRC}
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

package eu.operando.proxy.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;

import org.apache.commons.lang3.StringUtils;
import org.littleshoot.proxy.ActivityTrackerAdapter;
import org.littleshoot.proxy.FlowContext;
import org.littleshoot.proxy.HttpFilters;
import org.littleshoot.proxy.HttpFiltersAdapter;
import org.littleshoot.proxy.HttpFiltersSource;
import org.littleshoot.proxy.HttpFiltersSourceAdapter;
import org.littleshoot.proxy.HttpProxyServer;
import org.littleshoot.proxy.impl.DefaultHttpProxyServer;
import org.littleshoot.proxy.impl.ProxyUtils;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLDecoder;
import java.nio.charset.Charset;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import eu.operando.proxy.MainContext;
import eu.operando.proxy.database.DatabaseHelper;
import eu.operando.proxy.database.model.ResponseFilter;
import eu.operando.proxy.util.MainUtil;
import eu.operando.proxy.util.ProcExplorer;
import eu.operando.proxy.util.RequestFilterUtil;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpMessage;
import io.netty.handler.codec.http.HttpObject;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.HttpResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpVersion;
import mitm.CertificateSniffingMitmManager;

/**
 * Created by nikos on 8/4/2016.
 */

public class ProxyService extends Service {

    private static final String CustomHeaderField = "OperandoMetaInfo";

    private HttpProxyServer proxy;

    private static final int port = 8080;

    private MainContext mainContext = MainContext.INSTANCE;
    private ProcExplorer procExplorer;
    private DatabaseHelper db;

    private RequestFilterUtil requestFilterUtil;

    private String applicationInfoStr;


    @Override
    public void onCreate() {
        MainUtil.initializeMainContext(getApplicationContext());
        procExplorer = new ProcExplorer(mainContext.getContext());
        requestFilterUtil = new RequestFilterUtil(mainContext.getContext());
        db = mainContext.getDatabaseHelper();
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (proxy == null) {
            Log.e("OPERANDO", "-- PROXY ON START COMMAND--");

            HttpFiltersSource filtersSource = getFiltersSource();

            try {
                proxy = DefaultHttpProxyServer.bootstrap()
                        .withPort(port)
                        .withManInTheMiddle(new CertificateSniffingMitmManager(mainContext.getAuthority()))
                        .withAllowLocalOnly(false)
                        .withFiltersSource(filtersSource)
                        .withName("OperandoProxy")
                        .plusActivityTracker(new ActivityTrackerAdapter() {

                            /*
                            Get the package responsible for each request
                             */
                            @Override
                            public void requestReceivedFromClient(FlowContext flowContext,
                                                                  HttpRequest httpRequest) {
                                if (!MainUtil.isProxyPaused(mainContext)) {
                                    httpRequest.headers().add(CustomHeaderField, procExplorer.handleCommand(flowContext.getClientAddress()));
                                }
                            }
                        })
                        .start();
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        return START_STICKY;
    }


    private HttpFiltersSource getFiltersSource() {

        return new HttpFiltersSourceAdapter() {

//                @Override
//                public int getMaximumRequestBufferSizeInBytes() {
//                    // TODO Auto-generated method stub
//                    return 10 * 1024 * 1024;
//
//                }
//
//                @Override
//                public int getMaximumResponseBufferSizeInBytes() {
//                    // TODO Auto-generated method stub
//                    return 10 * 1024 * 1024;
//                }


            @Override
            public HttpFilters filterRequest(HttpRequest originalRequest) {


                return new HttpFiltersAdapter(originalRequest) {

                    @Override
                    public HttpObject serverToProxyResponse(
                            HttpObject httpObject) {

                        if (MainUtil.isProxyPaused(mainContext)) return httpObject;

                        if (httpObject instanceof HttpMessage) {
                            HttpMessage response = (HttpMessage) httpObject;
                            response.headers().set(HttpHeaderNames.CACHE_CONTROL, "no-cache, no-store, must-revalidate");
                            response.headers().set(HttpHeaderNames.PRAGMA, "no-cache");
                            response.headers().set(HttpHeaderNames.EXPIRES, "0");
                        }
                        try {
                            Method content = httpObject.getClass().getMethod("content");
                            if (content != null) {
                                ByteBuf buf = (ByteBuf) content.invoke(httpObject);
                                boolean flag = false;
                                List<ResponseFilter> responseFilters = db.getAllResponseFilters();
                                if (responseFilters.size() > 0) {

                                    String contentStr = buf.toString(Charset.forName("UTF-8")); //Charset.forName(Charset.forName("UTF-8")
                                    for (ResponseFilter responseFilter : responseFilters) {

                                        String toReplace = responseFilter.getContent();

                                        if (StringUtils.containsIgnoreCase(contentStr, toReplace)) {
                                            contentStr = contentStr.replaceAll("(?i)" + toReplace, StringUtils.leftPad("", toReplace.length(), '#'));
                                            flag = true;
                                        }

                                    }
                                    if (flag) {
                                        buf.clear().writeBytes(contentStr.getBytes(Charset.forName("UTF-8")));
                                    }
                                }

                            }
                        } catch (IndexOutOfBoundsException ex) {
                            ex.printStackTrace();
                            Log.e("Exception", ex.getMessage());
                        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException ex) {
                            //ignore
                        }
                        return httpObject;
                    }


                    @Override
                    public HttpResponse clientToProxyRequest(HttpObject httpObject) {

                        if (MainUtil.isProxyPaused(mainContext)) return null;

                        String requestURI;
                        Set<RequestFilterUtil.FilterType> exfiltrated = new HashSet<>();
                        String[] locationInfo = requestFilterUtil.getLocationInfo();
                        String[] contactsInfo = requestFilterUtil.getContactsInfo();
                        String[] phoneInfo = requestFilterUtil.getPhoneInfo();


                        if (httpObject instanceof HttpMessage) {
                            HttpMessage request = (HttpMessage) httpObject;
                            if (request.headers().contains(CustomHeaderField)) {
                                applicationInfoStr = request.headers().get(CustomHeaderField);
                                request.headers().remove(CustomHeaderField);
                            }

                            if (request.headers().contains(HttpHeaderNames.ACCEPT_ENCODING)) {
                                request.headers().remove(HttpHeaderNames.ACCEPT_ENCODING);
                            }

                                /*
                                Sanitize Hosts
                                */
                            if (!ProxyUtils.isCONNECT(request) && request.headers().contains(HttpHeaderNames.HOST)) {
                                String hostName = request.headers().get(HttpHeaderNames.HOST).toLowerCase();
                                if (db.isDomainBlocked(hostName))
                                    return getBlockedHostResponse(hostName);
                            }

                        }


                        if (httpObject instanceof HttpRequest) {

                            HttpRequest request = (HttpRequest) httpObject;
                            requestURI = request.uri();

                            try {
                                requestURI = URLDecoder.decode(requestURI, "UTF-8");
                            } catch (UnsupportedEncodingException e) {
                                e.printStackTrace();
                            }

                                /*
                                Request URI checks
                                 */
                            if (StringUtils.containsAny(requestURI, locationInfo)) {
                                exfiltrated.add(RequestFilterUtil.FilterType.LOCATION);
                            }

                            if (StringUtils.containsAny(requestURI, contactsInfo)) {
                                exfiltrated.add(RequestFilterUtil.FilterType.CONTACTS);
                            }

                            if (StringUtils.containsAny(requestURI, phoneInfo)) {
                                exfiltrated.add(RequestFilterUtil.FilterType.PHONEINFO);
                            }

                            if (!exfiltrated.isEmpty()) {
                                mainContext.getNotificationUtil().displayExfiltratedNotification(applicationInfoStr, exfiltrated);
                                return getForbiddenRequestResponse(applicationInfoStr, exfiltrated);
                            }

                        }


                        try {
                            Method content = httpObject.getClass().getMethod("content");
                            if (content != null) {
                                ByteBuf buf = (ByteBuf) content.invoke(httpObject);

                                String contentStr = buf.toString(Charset.forName("UTF-8"));


                                if (StringUtils.containsAny(contentStr, locationInfo)) {
                                    exfiltrated.add(RequestFilterUtil.FilterType.LOCATION);
                                }

                                if (StringUtils.containsAny(contentStr, contactsInfo)) {
                                    exfiltrated.add(RequestFilterUtil.FilterType.CONTACTS);
                                }

                                if (StringUtils.containsAny(contentStr, phoneInfo)) {
                                    exfiltrated.add(RequestFilterUtil.FilterType.PHONEINFO);
                                }

                                if (!exfiltrated.isEmpty()) {
                                    mainContext.getNotificationUtil().displayExfiltratedNotification(applicationInfoStr, exfiltrated);
                                    return getForbiddenRequestResponse(applicationInfoStr, exfiltrated);
                                }

                            }
                        } catch (IndexOutOfBoundsException ex) {
                            ex.printStackTrace();
                            Log.e("Exception", ex.getMessage());
                        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException ex) {
                            //ignore
                        }

                        return null;
                    }

                };
            }
        };
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        proxy.stop();
        proxy = null;
        Log.e("OPERANDO", "-- PROXY KILLED--");
    }


    private HttpResponse getBlockedHostResponse(String hostName) {
        String body = "<!DOCTYPE HTML \"-//IETF//DTD HTML 2.0//EN\">\n"
                + "<html><head>\n"
                + "<title>" + "Bad Gateway" + "</title>\n"
                + "</head><body>\n"
                + "<h1>Host '" + hostName + "' is blocked by OperandoApp.</h1>"
                + "</body></html>\n";
        byte[] bytes = body.getBytes(Charset.forName("UTF-8"));
        ByteBuf content = Unpooled.copiedBuffer(bytes);
        HttpResponse response = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.BAD_GATEWAY, content);
        response.headers().set(HttpHeaderNames.CONTENT_LENGTH, bytes.length);
        response.headers().set("Content-Type", "text/html; charset=UTF-8");
        response.headers().set("Date", ProxyUtils.formatDate(new Date()));
        response.headers().set(HttpHeaderNames.CONNECTION, "close");
        return response;
    }

    private HttpResponse getForbiddenRequestResponse(String applicationInfo, Set<RequestFilterUtil.FilterType> exfiltrated) {
        String body = "<!DOCTYPE HTML \"-//IETF//DTD HTML 2.0//EN\">\n"
                + "<html><head>\n"
                + "<title>" + "Forbidden" + "</title>\n"
                + "</head><body>\n"
                + "<h1>Request sent by: '" + applicationInfo + "',<br/> contains sensitive data: " + RequestFilterUtil.messageForMatchedFilters(exfiltrated) + "</h1>"
                + "</body></html>\n";
        byte[] bytes = body.getBytes(Charset.forName("UTF-8"));
        ByteBuf content = Unpooled.copiedBuffer(bytes);
        HttpResponse response = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.FORBIDDEN, content);
        response.headers().set(HttpHeaderNames.CONTENT_LENGTH, bytes.length);
        response.headers().set("Content-Type", "text/html; charset=UTF-8");
        response.headers().set("Date", ProxyUtils.formatDate(new Date()));
        response.headers().set(HttpHeaderNames.CONNECTION, "close");
        return response;
    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

}
