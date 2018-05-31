package eu.operando.activity;

import eu.operando.R;

/**
 * Created by Alex on 3/26/2018.
 */

public class ConnectedAppsActivity extends SocialNetworkBaseActivity {


    @Override
    public Class facebookClass() {
        return FacebookApps.class;
    }

    @Override
    public Class linkedinClass() {
        return LinkedinApps.class;
    }

    @Override
    public Class twitterClass() {
        return TwitterApps.class;
    }

    @Override
    public Class googleClass() {
        return GoogleApps.class;
    }

    @Override
    public int getStringTitleId() {
        return R.string.connected_apps;
    }

    @Override
    public int getStringDescriptionId() {
        return R.string.connected_apps_header;
    }
}