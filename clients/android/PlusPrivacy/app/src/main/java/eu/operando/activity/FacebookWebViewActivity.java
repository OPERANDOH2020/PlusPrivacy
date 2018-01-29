package eu.operando.activity;

import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by Matei_Alexandru on 07.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FacebookWebViewActivity extends SocialNetworkWebViewActivity {

    public class MyWebViewClient extends WebViewClient {

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
//            injectScriptForPrivacySettings();
            if (shouldInject) {
                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    injectScriptFile("jquery214min.js");
                }

                injectScriptFile("facebook.js");
                initProgressDialog();
            }
        }
    }

    private final String URL_MOBILE = "http://m.facebook.com";
    private final String URL = "http://facebook.com";

    public String getURL_MOBILE() {
        return URL_MOBILE;
    }

    public String getURL() {
        return URL;
    }

    @Override
    public WebViewClient getWebViewClient() {
        return new MyWebViewClient();
    }
}
