package eu.operando.androidsdk.scdmodel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public enum InputType {
    loc ("Location"),
    mic ("Microphone"),
    cam ("Camera"),
    gyro ("Gyroscope"),
    acc ("Accelerometer"),
    prox ("Proximity"),
    touchID ("TouchID"),
    bar ("Barometer"),
    force ("Force touch"),
    pedo ("Pedometer"),
    magneto ("Magnetometer"),
    contacts ("Contacts"),
    bat ("Battery"),
    motion ("Device motion"),
    info ("Device info");

    private String sensor;

    InputType(String sensor) {
        this.sensor = sensor;
    }

    public String getSensor() {
        return sensor;
    }
}
