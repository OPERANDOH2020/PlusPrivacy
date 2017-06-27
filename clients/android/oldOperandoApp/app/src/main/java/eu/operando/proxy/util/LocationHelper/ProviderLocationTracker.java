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

package eu.operando.proxy.util.LocationHelper;

/**
 * Created by Cveki on 29.3.2015..
 */

import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

public class ProviderLocationTracker implements LocationListener, LocationTracker {

    // The minimum distance to change Updates in meters
    private static final long MIN_UPDATE_DISTANCE = 10;

    // The minimum time between updates in milliseconds
    private static final long MIN_UPDATE_TIME = 1000 * 60;

    private LocationManager lm;

    public enum ProviderType {
        NETWORK,
        GPS
    }

    private String provider;

    private Location lastLocation;
    private long lastTime;

    private boolean isRunning;

    private LocationUpdateListener listener;

    public ProviderLocationTracker(Context context, ProviderType type) {
        lm = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        if (type == ProviderType.NETWORK) {
            provider = LocationManager.NETWORK_PROVIDER;
        } else {
            provider = LocationManager.GPS_PROVIDER;
        }
    }

    public void start() {
        if (isRunning) {
            //Already running, do nothing
            return;
        }

        //The provider is on, so start getting updates.  Update current location
        try {
            isRunning = true;
            lm.requestLocationUpdates(provider, MIN_UPDATE_TIME, MIN_UPDATE_DISTANCE, this);
            lastLocation = null;
            lastTime = 0;
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return;
    }

    public void start(LocationUpdateListener update) {
        start();
        listener = update;

    }


    public void stop() {
        if (isRunning) {
            lm.removeUpdates(this);
            isRunning = false;
            listener = null;
        }
    }

    public boolean hasLocation() {
        if (lastLocation == null) {
            return false;
        }
        return System.currentTimeMillis() - lastTime <= 5 * MIN_UPDATE_TIME;
    }

    public boolean hasPossiblyStaleLocation() {
        if (lastLocation != null) {
            return true;
        }
        return lm.getLastKnownLocation(provider) != null;
    }

    public Location getLocation() {
        if (lastLocation == null) {
            return null;
        }
        if (System.currentTimeMillis() - lastTime > 5 * MIN_UPDATE_TIME) {
            return null; //stale
        }
        return lastLocation;
    }

    public Location getPossiblyStaleLocation() {
        if (lastLocation != null) {
            return lastLocation;
        }
        return lm.getLastKnownLocation(provider);
    }

    public void onLocationChanged(Location newLoc) {
        long now = System.currentTimeMillis();
        if (listener != null) {
            listener.onUpdate(lastLocation, lastTime, newLoc, now);
        }
        lastLocation = newLoc;
        lastTime = now;
    }

    public void onProviderDisabled(String arg0) {

    }

    public void onProviderEnabled(String arg0) {

    }

    public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
    }
}