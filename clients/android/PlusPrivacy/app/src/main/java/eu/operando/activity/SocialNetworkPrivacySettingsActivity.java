package eu.operando.activity;

import eu.operando.R;

/**
 * Created by Alex on 12/12/2017.
 */

public class SocialNetworkPrivacySettingsActivity extends SocialNetworkBaseActivity {


    @Override
    public Class facebookClass() {
        return FacebookSettingsActivity.class;
    }

    @Override
    public Class linkedinClass() {
        return LinkedinSettingsActivity.class;
    }

    @Override
    public Class twitterClass() {
        return TwitterSettingsActivity.class;
    }

    @Override
    public Class googleClass() {
        return GoogleSettingsActivity.class;
    }

    @Override
    public int getStringTitleId() {
        return R.string.social_network_settings;
    }

    @Override
    public int getStringDescriptionId() {
        return R.string.social_networks_header;
    }
}
