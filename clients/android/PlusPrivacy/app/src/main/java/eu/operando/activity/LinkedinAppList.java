package eu.operando.activity;

import eu.operando.R;

/**
 * Created by Alex on 02.04.2018.
 */

public class LinkedinAppList extends SocialNetworkAppsListActivity {
    @Override
    protected String getURL() {
        return "https://www.linkedin.com/psettings/permitted-services";
    }

    @Override
    public String getJsFile() {
        return "remove_linkedin_app.js";
    }

    @Override
    public int getSNMainColor() {
        return R.color.social_network_settings_linkedin;
    }

    @Override
    public int getSNSecondaryColor() {
        return R.color.linkedin_connected_apps;
    }
}
