package eu.operando.models;

import android.content.pm.FeatureInfo;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by Edy on 6/15/2016.
 */
public class InstalledApp extends AbstractApp{

    private ArrayList<FeatureInfo> features;

    public InstalledApp(String appName, String packageName, String[] permissions, FeatureInfo[] features) {
        super(appName, packageName, permissions != null ? new ArrayList<>(Arrays.asList(permissions)):null, 0);
        if (features != null) {
            this.features = new ArrayList<>();
            this.features.addAll(Arrays.asList(features));
        }
    }

    public ArrayList<FeatureInfo> getFeatures() {
        return features;
    }

}
