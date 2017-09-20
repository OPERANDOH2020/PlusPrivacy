package eu.operando.models.privacysettings;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Matei_Alexandru on 06.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class Preference {

    @SerializedName("setting_key")
    private String settingKey;
    @SerializedName("setting_value")
    private String settingValue;

    public Preference(String settingKey, String settingValue) {
        this.settingKey = settingKey;
        this.settingValue = settingValue;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }
}