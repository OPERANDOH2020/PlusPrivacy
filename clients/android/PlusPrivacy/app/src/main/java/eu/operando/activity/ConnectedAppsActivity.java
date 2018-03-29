package eu.operando.activity;

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
        return FacebookApps.class;
    }

    @Override
    public Class twitterClass() {
        return FacebookApps.class;
    }

    @Override
    public Class googleClass() {
        return FacebookApps.class;
    }
}