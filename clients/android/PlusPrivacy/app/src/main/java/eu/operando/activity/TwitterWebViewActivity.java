package eu.operando.activity;


import android.view.View;
import android.webkit.CookieManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import eu.operando.customView.MyWebViewClient;

/**
 * Created by Alex on 1/23/2018.
 */

public class TwitterWebViewActivity extends SocialNetworkWebViewActivity {

    public String getURL_MOBILE() {
        return "https://mobile.twitter.com/settings/safety";
    }

    public String getURL() {
        return "https://mobile.twitter.com/settings/safety";
    }

    @Override
    public WebViewClient getWebViewClient() {
        return new TwitterWebViewClient(this);
    }

    @Override
    public WebAppInterface getWebAppInterface() {
        return new WebAppInterface(this, privacySettingsString);
    }

    @Override
    public String getJsFile() {
        return "twitter.js";
    }

    public void startInjectingOnClick(View view) {

        if (!shouldInject) {

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

    public class TwitterWebViewClient extends MyWebViewClient {

        public TwitterWebViewClient(SocialNetworkInterface socialNetworkInterface) {
            super(socialNetworkInterface);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            socialNetworkInterface.onPageListener();

        }

        @Override
        public void onPageCommitVisible(WebView view, String url) {
//            super.onPageCommitVisible(view, url);
        }
    }

}