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

    public class MyWebViewClient extends WebViewClient {

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            if (shouldInject) {
                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    injectScriptFile("jquery214min.js");
                }

                injectScriptFile("google_preferences_settings.js");
//                injectCssFile("activityControls.css");
                shouldInject = false;
                initProgressDialog();
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

    public void injectCssFile(String scriptFile) {
        InputStream input;
        try {
            input = getAssets().open(scriptFile);
            byte[] buffer = new byte[input.available()];
            input.read(buffer);
            input.close();

            String encoded = Base64.encodeToString(buffer, Base64.NO_WRAP);
            myWebView.loadUrl("javascript:(function() {" +
                    "var parent = document.getElementsByTagName('head').item(0);" +
                    "var style = document.createElement('style');" +
                    "style.type = 'text/css';" +
                    // Tell the browser to BASE64-decode the string into your script !!!
                    "style.innerHTML = window.atob('" + encoded + "');" +
                    "parent.appendChild(style)" +
                    "})()");

        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
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
        }
    }

}