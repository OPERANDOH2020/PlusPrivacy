package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.content.Intent;
import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;

/**
 * Created by Matei_Alexandru on 07.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class CameraIntentInterceptor extends AbstractInterceptor<Intent, Intent> {

    @Override
    public void beforeCall(Object[] args) {
        Log.e("CameraIntentInterceptor", "beforeCall ");
    }

    @Override
    public Intent afterCall(Intent result) {
        Log.e("CameraIntentInterceptor", "afterCall ");
        return result;
    }
}
