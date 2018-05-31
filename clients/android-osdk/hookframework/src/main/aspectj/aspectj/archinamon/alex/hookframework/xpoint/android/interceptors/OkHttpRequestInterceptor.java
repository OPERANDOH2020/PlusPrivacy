package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.content.Context;
import android.util.Log;

import com.squareup.okhttp.Call;
import com.squareup.okhttp.Request;

import java.io.IOException;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;
import eu.operando.androidsdk.semanticfirewall.SemanticFirewall;
import okio.Buffer;


/**
 * Created by Matei_Alexandru on 16.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class OkHttpRequestInterceptor  extends AbstractInterceptor<Call, Call> {

    private Context context;
    public OkHttpRequestInterceptor(Context baseContext) {
        super();
        this.context = baseContext;
    }

    @Override
    public void beforeCall(Object[] args) {
        Log.e("OkHttpRequestIntercept", "beforeCall ");

        String body = bodyToString((Request) args[0]);
        Log.e("OkHttpRequestIntercept", "beforeCall " + body);

        checkSemanticFirewall(body, ((Request) args[0]).url().toString());
    }

    @Override
    public Call afterCall(Call result, Object... args) {

        return result;
    }

    private void checkSemanticFirewall(String body, String url) {

        Log.e("SemanticFirewall", String.valueOf(new SemanticFirewall(context).isSecure(body, url)));
    }

    private static String bodyToString(final Request request){

        try {
            final Request copy = request.newBuilder().build();
            final Buffer buffer = new Buffer();
            copy.body().writeTo(buffer);
            return buffer.readUtf8();
        } catch (final IOException e) {
            return "did not work";
        }
    }
}
