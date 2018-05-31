package eu.operando.activity;

import eu.operando.R;

/**
 * Created by Alex on 02.04.2018.
 */

public class TwitterAppList extends SocialNetworkAppsListActivity {
    @Override
    public int getSNMainColor() {
        return R.color.social_network_settings_twitter;
    }

    @Override
    public int getSNSecondaryColor() {
        return R.color.twitter_connected_apps;
    }

    @Override
    protected String getURL() {
        return "https://twitter.com/settings/applications?lang=en";
    }

    @Override
    public String getJsFile() {
        return "remove_twitter_app.js";
    }

    @Override
    public void initUI() {

        super.initUI();
        setUserAgent();

    }
}
