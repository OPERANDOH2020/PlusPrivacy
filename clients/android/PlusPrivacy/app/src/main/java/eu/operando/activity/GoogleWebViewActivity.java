package eu.operando.activity;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import eu.operando.R;
import eu.operando.customView.MyWebViewClient;

/**
 * Created by Alex on 2/16/2018.
 */

public class GoogleWebViewActivity extends SocialNetworkWebViewActivity {

    private int totalQuestions;
    private boolean shouldInjectUsualSettings = false;
    private final String URL_MOBILE = "https://myaccount.google.com/activitycontrols";
    private final String URL = "https://myaccount.google.com/activitycontrols";
    private final String PREFERENCES_URL = "https://www.google.com/preferences";


    public String getURL_MOBILE() {
        return URL_MOBILE;
    }

    public String getURL() {
        return URL;
    }

    @Override
    public WebViewClient getWebViewClient() {
        return new GoogleWebViewClient(this);
    }

    @Override
    public SocialNetworkWebViewActivity.WebAppInterface getWebAppInterface() {
        return new GoogleWebAppInterface(this, privacySettingsString);
    }

    @Override
    public String getJsFile() {
        return "google_preferences_settings.js";
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        totalQuestions = privacySettingsJSONArray.length();
    }

    public class GoogleWebViewClient extends MyWebViewClient {

        public GoogleWebViewClient(SocialNetworkInterface socialNetworkInterface) {
            super(socialNetworkInterface);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            socialNetworkInterface.onPageListener();
            googlePageListener(url);
        }

        @Override
        public void onPageCommitVisible(WebView view, String url) {
            super.onPageCommitVisible(view, url);
            socialNetworkInterface.onPageListener();
            googlePageListener(url);
        }
    }

    public void googlePageListener(String url) {
        synchronized (mutex) {
            if (url.equals("https://myaccount.google.com/activitycontrols") &&
                    shouldInjectUsualSettings) {

                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    injectScriptFile("jquery214min.js");
                }

                injectScriptFile("google_usual_settings.js");
                shouldInjectUsualSettings = false;
            }
        }
    }

    @Override
    public void startInjectingOnClick(View view) {

        if (!shouldInject) {

//            setAgent();
            myWebView.loadUrl(PREFERENCES_URL);

            if (android.os.Build.VERSION.SDK_INT >= 21) {
                CookieManager.getInstance().setAcceptThirdPartyCookies(myWebView, true);
            } else {
                CookieManager.getInstance().setAcceptCookie(true);
            }

            shouldInject = true;
            shouldInjectUsualSettings = true;

            initProgressDialog();
        }
    }

    public class GoogleWebAppInterface extends SocialNetworkWebViewActivity.WebAppInterface {

        private int index = 0;

        public GoogleWebAppInterface(Context context, String privacySettings) {
            super(context, privacySettings);
        }

        @JavascriptInterface
        public String getPreferencePrivacySettings() {
            return preferencesSettings.toString();
        }

        @JavascriptInterface
        public String getUsualPrivacySettings() {
            return usualSettings.toString();
        }

        @JavascriptInterface
        public String getActivityControlsSettings() {
            return activityControlsSettings.toString();
        }

        @JavascriptInterface
        public void onFinishedLoadingPreferenceSettings() {
            myWebView.post(new Runnable() {
                @Override
                public void run() {
                    myWebView.loadUrl("https://myaccount.google.com/activitycontrols");
                }
            });
        }

        @JavascriptInterface
        public void onFinishedLoadingUsualSettings() {
            myWebView.post(new Runnable() {
                @Override
                public void run() {

                    injectCssFile("activityControls.css");
                    injectScriptFile("google_activity_controls.js");
                }
            });
        }

        @JavascriptInterface
        public void dismissDialog() {

            frameLayout.post(new Runnable() {
                @Override
                public void run() {
                    frameLayout.setVisibility(View.GONE);
                }
            });
        }
    }
}