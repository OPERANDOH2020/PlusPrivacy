package eu.operando.androidsdk.scdmodel;

/**
 * Created by Matei_Alexandru on 12.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public enum AccessFrequencyType {

    F1("Only one sample of data is collected at certain times."),
    F2("The data is collected continuously in time intervals, triggered by certain events " +
            "(e.g when the you presss Record/Stop or enter in a geofencing area)"),
    F3("The data is collected continuously throughout the lifetime of the app."),
    F4("The data is collected random");

    private String frequency;

    AccessFrequencyType(String frequency) {
        this.frequency = frequency;
    }

    public String getFrequency() {
        return frequency;
    }
}
