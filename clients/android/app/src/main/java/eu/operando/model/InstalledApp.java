package eu.operando.model;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by Edy on 6/15/2016.
 */
public class InstalledApp {
    private String appName;
    private String packageName;
    private ArrayList<String> permissions;

    public InstalledApp(String appName, String packageName, String[] permissions) {
        this.appName = appName;
        this.packageName = packageName;
        if (permissions != null) {
            this.permissions = new ArrayList<>(Arrays.asList(permissions));
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
}
