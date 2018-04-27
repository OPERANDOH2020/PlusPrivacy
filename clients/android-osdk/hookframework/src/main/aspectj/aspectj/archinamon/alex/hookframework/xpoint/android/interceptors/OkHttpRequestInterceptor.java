package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.util.Log;

import com.squareup.okhttp.Call;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;

import java.io.IOException;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.semanticfirewall.SemanticFirewall;
import okio.Buffer;


/**
 * Created by Matei_Alexandru on 16.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class OkHttpRequestInterceptor  extends AbstractInterceptor<Call, Call> {
    @Override
    public void beforeCall(Object[] args) {
        Log.e("OkHttpRequestIntercept", "beforeCall ");
    }

    @Override
    public Call afterCall(Call result, Object... args) {
        String body = bodyToString((Request) args[0]);
        Log.e("OkHttpRequestIntercept", "afterCall " + body);

        checkSemanticFirewall(body);

        return result;
    }

    private void checkSemanticFirewall(String body) {

        new SemanticFirewall().check(body);

        Log.e("SemanticFirewall", String.valueOf(new SemanticFirewall().check(body)));
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
