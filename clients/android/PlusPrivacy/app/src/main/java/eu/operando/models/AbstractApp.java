package eu.operando.models;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Alex on 3/26/2018.
 */

public class AbstractApp {

    @SerializedName("name")
    private String appName;
    private String packageName;
    private List<String> permissions;
    private int pollutionScore;

    public AbstractApp(String appName, String packageName, List<String> permissions, int pollutionScore) {
        this.appName = appName;
        this.packageName = packageName;
        if (permissions != null){
            this.permissions = permissions;
        }
        this.pollutionScore = pollutionScore;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public List<String> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<String> permissions) {
        this.permissions = permissions;
    }

    public int getPollutionScore() {
        return pollutionScore;
    }

    public void setPollutionScore(int pollutionScore) {
        this.pollutionScore = pollutionScore;
    }
}
