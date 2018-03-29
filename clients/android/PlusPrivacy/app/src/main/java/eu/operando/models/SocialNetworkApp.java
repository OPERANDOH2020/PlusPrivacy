package eu.operando.models;

import java.util.List;

/**
 * Created by Alex on 3/26/2018.
 */

public class SocialNetworkApp extends AbstractApp{

    private String appId;
    private String visibility;
    private String iconUrl;

    public SocialNetworkApp(String appName, String packageName, List<String> permissions, int pollutionScore, String appId, String visibility, String iconUrl) {
        super(appName, packageName, permissions, pollutionScore);
        this.appId = appId;
        this.visibility = visibility;
        this.iconUrl = iconUrl;
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getVisibility() {
        return visibility;
    }

    public void setVisibility(String visibility) {
        this.visibility = visibility;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }
}
