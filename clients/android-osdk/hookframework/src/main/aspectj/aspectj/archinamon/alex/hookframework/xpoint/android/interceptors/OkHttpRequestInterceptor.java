package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.util.Log;

import com.squareup.okhttp.RequestBody;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;


/**
 * Created by Matei_Alexandru on 16.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class OkHttpRequestInterceptor  extends AbstractInterceptor<RequestBody, RequestBody> {
    @Override
    public void beforeCall(Object[] args) {
        Log.e("OkHttpRequestIntercept", "beforeCall ");
    }

    @Override
    public RequestBody afterCall(RequestBody result) {
        Log.e("OkHttpRequestIntercept", "afterCall ");
        return result;
    }

}
