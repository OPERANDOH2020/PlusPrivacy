package aspectj.archinamon.alex.hookframework.xpoint.android.events;

import android.location.Location;
import android.location.LocationManager;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.event.AbstractEvent;


public class LocationEvent extends AbstractEvent<Location> {


    public LocationEvent(String tip) {
        super(tip);
    }

    @Override
    public Location stop() {
        Location location = new Location(LocationManager.NETWORK_PROVIDER);
        location.setLatitude(2.25);
        location.setLongitude(2.35);
        return location;
    }
}
