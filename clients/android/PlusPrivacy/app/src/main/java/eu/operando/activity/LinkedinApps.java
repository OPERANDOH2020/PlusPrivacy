package eu.operando.activity;

import android.webkit.CookieManager;

/**
 * Created by Alex on 02.04.2018.
 */

public class LinkedinApps extends SocialNetworkAppsActivity {

    @Override
    public String getURL_MOBILE() {
//        return "https://www.linkedin.com/psettings/permitted-services";
        return "https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww%2Elinkedin%2Ecom%2Fpsettings%2Fpermitted-services&fromSignIn=true&trk=uno-reg-join-mobile-sign-in";

    }

    @Override
    protected String getURL() {
        return "https://www.linkedin.com/psettings/permitted-services";
    }

    @Override
    public String getJsFile() {
        return "linkedin_apps.js";
    }

    @Override
    public String getIsLoggedJsFile() {
        return "linkedin_is_logged.js";
    }

    @Override
    protected Class getAppListClass() {
        return LinkedinAppList.class;
    }

    @Override
    protected void initUI() {
        super.initUI();
//        setUserAgent();
    }

    public void startInjecting() {

        if (!shouldInject) {

//            setUserAgent();
            myWebView.loadUrl(getURL());

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