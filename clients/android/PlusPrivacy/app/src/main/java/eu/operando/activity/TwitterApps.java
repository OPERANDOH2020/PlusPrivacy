package eu.operando.activity;

import android.webkit.CookieManager;

/**
 * Created by Alex on 3/30/2018.
 */

public class TwitterApps extends SocialNetworkAppsActivity {

    @Override
    public String getURL_MOBILE() {
        return "https://twitter.com/settings/applications";
    }

    @Override
    protected String getURL() {
        return "https://twitter.com/settings/applications";
    }

    @Override
    public String getJsFile() {
        return "twitter_apps.js";
    }

    @Override
    public String getIsLoggedJsFile() {
        return "twitter_is_logged.js";
    }

    @Override
    protected Class getAppListClass() {
        return TwitterAppList.class;
    }

    @Override
    public void onPageCommitVisible() {

    }

    @Override
    public void onPageFinished() {

        onPageListener();
    }

    public void startInjecting() {

        if (!shouldInject) {

            setUserAgent();
            myWebView.loadUrl(getURL_MOBILE());

            if (android.os.Build.VERSION.SDK_INT >= 21) {
                CookieManager.getInstance().setAcceptThirdPartyCookies(myWebView, true);
            } else {
                CookieManager.getInstance().setAcceptCookie(true);
            }
            initProgressDialog();
            shouldInject = true;

        }
    }

}