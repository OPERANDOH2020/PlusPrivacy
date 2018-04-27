package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;


/**
 * Created by Matei_Alexandru on 07.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class MediaRecorderInterceptor extends AbstractInterceptor<Void, Void> {
    @Override
    public void beforeCall(Object[] args) {
        Log.e("MediaRecorderIntercept", "beforeCall");
    }

    @Override
    public Void afterCall(Void result, Object... args) {
        Log.e("MediaRecorderIntercept", "afterCall ");
        return null;
    }
}
