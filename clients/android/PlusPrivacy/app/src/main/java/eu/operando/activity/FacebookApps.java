package eu.operando.activity;

import android.util.Log;
import android.webkit.CookieManager;

/**
 * Created by Alex on 02.04.2018.
 */

public class FacebookApps extends SocialNetworkAppsActivity {

    @Override
    public String getURL_MOBILE() {
        return "https://m.facebook.com/settings/apps/tabbed/";
    }

    @Override
    protected String getURL() {
        return "https://m.facebook.com/settings/apps/tabbed/";
    }

    @Override
    public String getJsFile() {
        return "facebook_apps.js";
    }

    @Override
    public String getIsLoggedJsFile() {
        return "facebook_is_logged.js";
    }

    @Override
    protected Class getAppListClass() {
        return FacebookAppList.class;
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
