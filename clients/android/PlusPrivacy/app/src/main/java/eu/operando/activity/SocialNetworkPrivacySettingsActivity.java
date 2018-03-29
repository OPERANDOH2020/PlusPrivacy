package eu.operando.activity;

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
}
