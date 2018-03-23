package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;

/**
 * Created by Matei_Alexandru on 04.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class BatteryInterceptor extends AbstractInterceptor<Integer, Integer> {
    @Override
    public void beforeCall(Object[] args) {
        Log.w("hookBattery", "beforeCall");
    }

    @Override
    public Integer afterCall(Integer result) {
        Log.w("hookBattery", "afterCall");
        return result;
    }

}
