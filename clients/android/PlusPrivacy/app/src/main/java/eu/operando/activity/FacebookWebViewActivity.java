package eu.operando.activity;

import android.app.ProgressDialog;
import android.webkit.WebViewClient;
import eu.operando.customView.MyWebViewClient;

/**
 * Created by Matei_Alexandru on 07.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FacebookWebViewActivity extends SocialNetworkWebViewActivity {

    public String getURL_MOBILE() {
        return "http://m.facebook.com";
    }

    public String getURL() {
        return "http://facebook.com";
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
        return "facebook.js";
    }

}
