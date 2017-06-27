package eu.operando.models;

import android.content.pm.FeatureInfo;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by Edy on 6/15/2016.
 */
public class InstalledApp {
    private String appName;
    private String packageName;
    private ArrayList<String> permissions;
    private int pollutionScore;
    private ArrayList<FeatureInfo> features;

    public InstalledApp(String appName, String packageName, String[] permissions, FeatureInfo[] features) {
        this.appName = appName;
        this.packageName = packageName;
        if (permissions != null) {
            this.permissions = new ArrayList<>(Arrays.asList(permissions));
        }
        if (features != null) {
            this.features = new ArrayList<>();
            this.features.addAll(Arrays.asList(features));
        }
    }

    public String getAppName() {
        return appName;
    }

    public String getPackageName() {
        return packageName;
    }

    public ArrayList<String> getPermissions() {
        return permissions;
    }

    public void setPollutionScore(int pollutionScore) {
        this.pollutionScore = pollutionScore;
    }

    public int getPollutionScore() {
        return pollutionScore;
    }

    public ArrayList<FeatureInfo> getFeatures() {
        return features;
    }
}
