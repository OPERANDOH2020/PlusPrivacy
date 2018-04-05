package eu.operando.activity;

import eu.operando.R;

/**
 * Created by Alex on 3/30/2018.
 */

public class FacebookAppList extends SocialNetworkAppsListActivity {

    @Override
    protected String getURL() {
        return "https://www.facebook.com/settings?tab=applications";
    }

    @Override
    public String getJsFile() {
        return "remove_facebook_app.js";
    }

    @Override
    public int getSNMainColor() {
        return R.color.social_network_settings_facebook;
    }

    @Override
    public int getSNSecondaryColor() {
        return R.color.facebook_connected_apps;
    }

}
