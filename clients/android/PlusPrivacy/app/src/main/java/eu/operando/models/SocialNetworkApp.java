package eu.operando.models;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Alex on 3/26/2018.
 */

public class SocialNetworkApp extends AbstractApp{

    private String appId;
    private String visibility;
    private String iconUrl;
    @SerializedName("permissionGroups")
    private List<PermissionGroups> permissionGroups;

    public SocialNetworkApp(String appName, String packageName, List<String> permissions, int pollutionScore, String appId, String visibility, String iconUrl) {
        super(appName, packageName, permissions, pollutionScore);
        this.appId = appId;
        this.visibility = visibility;
        this.iconUrl = iconUrl;
    }

    public List<PermissionGroups> getPermissionGroups() {
        return permissionGroups;
    }

    public void setPermissionGroups(List<PermissionGroups> permissionGroups) {
        this.permissionGroups = permissionGroups;
    }

    public SocialNetworkApp(String appName, String packageName, List<String> permissions, int pollutionScore, String appId, String visibility, String iconUrl, List<PermissionGroups> permissionGroups) {
        super(appName, packageName, permissions, pollutionScore);
        this.appId = appId;
        this.visibility = visibility;
        this.iconUrl = iconUrl;
        this.permissionGroups = permissionGroups;
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

    public class PermissionGroups {

        private String iconUrl;
        private String name;
        private List<String> permissions;

        public PermissionGroups(String iconUrl, String name, List<String> permissions) {
            this.iconUrl = iconUrl;
            this.name = name;
            this.permissions = permissions;
        }

        public String getIconUrl() {
            return iconUrl;
        }

        public void setIconUrl(String iconUrl) {
            this.iconUrl = iconUrl;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public List<String> getPermissions() {
            return permissions;
        }

        public void setPermissions(List<String> permissions) {
            this.permissions = permissions;
        }
    }
}
