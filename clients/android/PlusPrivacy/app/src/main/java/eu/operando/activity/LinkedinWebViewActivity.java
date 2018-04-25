package eu.operando.activity;

import android.webkit.WebViewClient;
import eu.operando.customView.MyWebViewClient;

/**
 * Created by Matei_Alexandru on 19.01.2018.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class LinkedinWebViewActivity extends SocialNetworkPrivacySettingsWebViewActivity {

    public String getURL_MOBILE() {
        return "https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww%2Elinkedin%2Ecom%2Fpsettings%2Fprivacy&fromSignIn=true&trk=uno-reg-join-mobile-sign-in";
    }

    public String getURL() {
        return "https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww%2Elinkedin%2Ecom%2Fpsettings%2Fprivacy&fromSignIn=true&trk=uno-reg-join-mobile-sign-in";
    }

    @Override
    public WebViewClient getWebViewClient() {
        return new MyWebViewClient(this);
    }

    @Override
    public WebAppInterface getWebAppInterface() {
        return new WebAppInterface(this, privacySettingsString);
    }

    @Override
    public String getJsFile() {
        return "linkedin.js";
    }

    @Override
    public String getIsLoggedJsFile() {
        return "linkedin_is_logged.js";
    }

}
