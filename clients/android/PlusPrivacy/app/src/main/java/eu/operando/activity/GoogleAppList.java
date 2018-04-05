package eu.operando.activity;

import eu.operando.R;

/**
 * Created by Alex on 03.04.2018.
 */

public class GoogleAppList extends SocialNetworkAppsListActivity {
    @Override
    protected String getURL() {
        return "https://myaccount.google.com/permissions";
    }

    @Override
    public String getJsFile() {
        return "remove_google_app.js";
    }

    @Override
    public int getSNMainColor() {
        return R.color.social_network_settings_google;
    }

    @Override
    public int getSNSecondaryColor() {
        return R.color.google_connected_apps;
    }
}