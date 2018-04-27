package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.location.Location;
import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;


/**
 * Created by Matei_Alexandru on 03.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class OnLocationChangedInterceptor extends AbstractInterceptor<Void, Location> {
    @Override
    public void beforeCall(Object[] args) {
        Log.e("MyLocationInterceptor", "beforeCall");
    }

    @Override
    public Void afterCall(Location result, Object... args) {
        Log.e("MyLocationInterceptor", "afterCall " + result.getLongitude() + " " + result.getLatitude());
//        return null;
        return null;
    }
}
