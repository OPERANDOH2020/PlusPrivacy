package eu.operando.models.privacysettings;

import com.google.gson.JsonElement;

import java.util.List;

/**
 * Created by Matei_Alexandru on 04.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class AvailableSettingsWrite {

    private String name;
    private List<Param> params;
    private String tag;
    private JsonElement data;

    public AvailableSettingsWrite(String name, List<Param> params, String tag) {
        this.name = name;
        this.params = params;
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

    public List<Param> getParams() {
        return params;
    }

    public void setParams(List<Param> params) {
        this.params = params;
    }

    public class Param {
        private String placeholder;
        private JsonElement value;

        public Param(String placeholder, JsonElement value) {
            this.placeholder = placeholder;
            this.value = value;
        }

        public String getPlaceholder() {
            return placeholder;
        }

        public void setPlaceholder(String placeholder) {
            this.placeholder = placeholder;
        }

        public JsonElement getValue() {
            return value;
        }

        public void setValue(JsonElement value) {
            this.value = value;
        }
    }

    public JsonElement getData() {
        return data;
    }

    public void setData(JsonElement data) {
        this.data = data;
    }

}
