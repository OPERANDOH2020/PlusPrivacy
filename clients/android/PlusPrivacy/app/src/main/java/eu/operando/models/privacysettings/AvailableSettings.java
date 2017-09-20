package eu.operando.models.privacysettings;

/**
 * Created by Matei_Alexandru on 04.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class AvailableSettings {

    private String name;
    private String index;
    private String tag;

    public AvailableSettings(String name, String index, String tag) {
        this.name = name;
        this.index = index;
        this.tag = tag;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
    }
}