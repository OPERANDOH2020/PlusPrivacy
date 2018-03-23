package aspectj.archinamon.alex.hookframework.xpoint.android.interceptors;

import android.location.Location;
import android.location.LocationManager;
import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;


public class LocationInterceptor extends AbstractInterceptor<Location, Location> {

    @Override
    public void beforeCall(Object[] args) {
        Log.e("LocationInterceptor", "beforeCall");
        setShouldProceed(false);
    }

    @Override
    public Location afterCall(Location result) {
        result = new Location(LocationManager.NETWORK_PROVIDER);
        result.setLatitude(30.6);
        result.setLongitude(23.6);
        Log.e("LocationInterceptor", "afterCall " + result.getLongitude() + " " + result.getLatitude());
        return result;
    }
}