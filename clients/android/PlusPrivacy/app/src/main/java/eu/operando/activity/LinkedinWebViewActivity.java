package eu.operando.activity;

import android.app.ProgressDialog;
import android.webkit.WebViewClient;
import eu.operando.customView.MyWebViewClient;

/**
 * Created by Matei_Alexandru on 19.01.2018.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class LinkedinWebViewActivity extends SocialNetworkWebViewActivity {

    public String getURL_MOBILE() {
        return "http://linkedin.com/psettings/privacy";
    }

    public String getURL() {
        return "http://linkedin.com/psettings/privacy";
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
