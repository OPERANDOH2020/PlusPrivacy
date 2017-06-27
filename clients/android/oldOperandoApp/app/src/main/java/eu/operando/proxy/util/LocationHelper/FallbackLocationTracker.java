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

import android.content.Context;
import android.location.Location;
import android.location.LocationManager;

import java.util.ArrayList;
import java.util.List;

public class FallbackLocationTracker implements LocationTracker, LocationTracker.LocationUpdateListener {


    private boolean isRunning;

    private ProviderLocationTracker gps;
    private ProviderLocationTracker net;

    private LocationUpdateListener listener;

    Location lastLoc;
    long lastTime;

    public FallbackLocationTracker(Context context) {
        gps = new ProviderLocationTracker(context, ProviderLocationTracker.ProviderType.GPS);
        net = new ProviderLocationTracker(context, ProviderLocationTracker.ProviderType.NETWORK);
    }

    public void start() {
        if (isRunning) {
            //Already running, do nothing
            return;
        }

        //Start both
        gps.start(this);
        net.start(this);
        isRunning = true;
    }

    public void start(LocationUpdateListener update) {
        start();
        listener = update;
    }


    public void stop() {
        if (isRunning) {
            gps.stop();
            net.stop();
            isRunning = false;
            listener = null;
        }
    }

    public boolean hasLocation() {
        //If either has a location, use it
        return gps.hasLocation() || net.hasLocation();
    }

    public boolean hasPossiblyStaleLocation() {
        //If either has a location, use it
        return gps.hasPossiblyStaleLocation() || net.hasPossiblyStaleLocation();
    }

    public Location getLocation() {
        Location ret = gps.getLocation();
        if (ret == null) {
            ret = net.getLocation();
        }
        return ret;
    }

    public List<Location> getLocations() {
        List<Location> ret = new ArrayList<>();
        ret.add(gps.getLocation());
        ret.add(net.getLocation());
        return ret;
    }

    public Location getPossiblyStaleLocation() {
        Location ret = gps.getPossiblyStaleLocation();
        if (ret == null) {
            ret = net.getPossiblyStaleLocation();
        }
        return ret;
    }

    public List<Location> getPossiblyStaleLocations() {
        List<Location> ret = new ArrayList<>();
        ret.add(gps.getPossiblyStaleLocation());
        ret.add(net.getPossiblyStaleLocation());
        return ret;
    }

    public void onUpdate(Location oldLoc, long oldTime, Location newLoc, long newTime) {
        boolean update = false;

        //We should update only if there is no last location, the provider is the same, or the provider is more accurate, or the old location is stale
        if (lastLoc == null) {
            update = true;
        } else if (lastLoc != null && lastLoc.getProvider().equals(newLoc.getProvider())) {
            update = true;
        } else if (newLoc.getProvider().equals(LocationManager.GPS_PROVIDER)) {
            update = true;
        } else if (newTime - lastTime > 5 * 60 * 1000) {
            update = true;
        }

        if (update) {
            if (listener != null) {
                listener.onUpdate(lastLoc, lastTime, newLoc, newTime);
            }
            lastLoc = newLoc;
            lastTime = newTime;
        }
    }
}
