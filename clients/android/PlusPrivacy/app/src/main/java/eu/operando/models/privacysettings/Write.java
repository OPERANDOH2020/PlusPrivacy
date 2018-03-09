package eu.operando.models.privacysettings;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by Matei_Alexandru on 04.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class Write implements Serializable{

    private String name;
    private List<AvailableSettingsWrite> availableSettings;
    private String page;

    @SerializedName("url_template")
    private String urlTemplate;
    private String recommended;
    private JsonElement data;
    private String url;

    @SerializedName("method_type")
    private String methodType;

    public Write(String name, List<AvailableSettingsWrite> availableSettings, String page, String urlTemplate, String recommended, JsonElement data, String url, String method_type) {
        this.name = name;
        this.availableSettings = availableSettings;
        this.page = page;
        this.urlTemplate = urlTemplate;
        this.recommended = recommended;
        this.data = data;
        this.url = url;
        this.methodType = method_type;
    }

    public String getMethodType() {
        return methodType;
    }

    public void setMethodType(String methodType) {
        this.methodType = methodType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<AvailableSettingsWrite> getAvailableSettings() {
        return availableSettings;
    }

    public void setAvailableSettings(List<AvailableSettingsWrite> availableSettings) {
        this.availableSettings = availableSettings;
    }

    public String getPage() {
        return page;
    }

    public void setPage(String page) {
        this.page = page;
    }

    public String getUrlTemplate() {
        return urlTemplate;
    }

    public void setUrlTemplate(String urlTemplate) {
        this.urlTemplate = urlTemplate;
    }

    public String getRecommended() {
        return recommended;
    }

    public void setRecommended(String recommended) {
        this.recommended = recommended;
    }

    public JsonElement getData() {
        return data;
    }

    public void setData(JsonElement data) {
        this.data = data;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public JsonObject mergeData(JsonElement data){
        if (this.data == null) {
            this.data = new JsonObject();
        }
        JsonObject dataObject = this.data.getAsJsonObject();
        for(Map.Entry entry : data.getAsJsonObject().entrySet())
        {
            dataObject.add(entry.getKey().toString(), (JsonElement) entry.getValue());
        }
        return dataObject;
    }
}
