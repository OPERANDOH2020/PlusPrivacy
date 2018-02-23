package eu.operando.activity;

import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

/**
 * Created by Alex on 2/16/2018.
 */

public class GoogleWebViewActivity extends SocialNetworkWebViewActivity {

    private boolean shouldInjectUsualSettings = false;
    public class MyWebViewClient extends WebViewClient {

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
//https://myaccount.google.com/intro/activitycontrols
            if (shouldInject) {
                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    injectScriptFile("jquery214min.js");
                }

                injectScriptFile("google_preferences_settings.js");
                shouldInject = false;
                initProgressDialog();
            }
            if (url.equals("https://myaccount.google.com/activitycontrols") &&
                    shouldInjectUsualSettings){

                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    injectScriptFile("jquery214min.js");
                }

                injectScriptFile("google_usual_settings.js");
//                injectCssFile("activityControls.css");
                shouldInjectUsualSettings = false;
            }
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {

            Log.e("requestHTTP", request.getMethod() + " " + request.getUrl());
            Map<String, String> headers = request.getRequestHeaders();
            for (Map.Entry<String, String> entry : headers.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                Log.e("{HEADER Aos}" + key, value);
            }

//            WebResourceResponse response = super.shouldInterceptRequest(view, request);
//            Log.e("{statusCode Aos}", String.valueOf(response.getStatusCode()));

            return super.shouldInterceptRequest(view, request);
        }
    }

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
        return new GoogleWebViewActivity.MyWebViewClient();
    }

    @Override
    public void startInjectingOnClick(View view) {
        if (!shouldInject) {

//            setAgent();
            myWebView.loadUrl(PREFERENCES_URL);

//            myWebView.loadUrl(getURL());

            if (android.os.Build.VERSION.SDK_INT >= 21) {
                CookieManager.getInstance().setAcceptThirdPartyCookies(myWebView, true);
            } else {
                CookieManager.getInstance().setAcceptCookie(true);
            }

            shouldInject = true;
            shouldInjectUsualSettings = true;
        }
    }

}