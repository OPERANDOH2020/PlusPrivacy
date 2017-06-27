package eu.operando.model;

import java.io.Serializable;

/**
 * Created by Edy on 6/24/2016.
 */
public class SensorModel implements Serializable{
    private String name;
    private int iconResID;
    private String type;

    public SensorModel(String name, int iconResID, String type) {
        this.name = name;
        this.type = type;
        this.iconResID = iconResID;
    }

    public String getType() {
        return type;
    }

    public int getIconResID() {
        return iconResID;
    }

    public String getName() {
        return name;
    }
}
