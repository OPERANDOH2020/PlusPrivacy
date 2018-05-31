package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.hardware.SensorEvent;
import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;


/**
 * Created by Matei_Alexandru on 04.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SensorInterceptor extends AbstractInterceptor<Void, SensorEvent> {
    @Override
    public void beforeCall(Object[] args) {
        Log.w("hookSensors", "beforeCall");
    }

    @Override
    public Void afterCall(SensorEvent result, Object... args) {
        Log.w("hookSensors", "afterCall");
        return null;
    }
}
