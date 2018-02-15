package eu.operando.activity;

import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.net.HttpURLConnection;
import java.util.Map;

/**
 * Created by Alex on 1/23/2018.
 */

public class TwitterWebViewActivity extends SocialNetworkWebViewActivity {

    public class MyWebViewClient extends WebViewClient {

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            if (shouldInject) {
                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    injectScriptFile("jquery214min.js");
                }

                injectScriptFile("twitter.js");
                initProgressDialog();
            }
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {

            Log.e("requestHTTP", request.getMethod() + " " + request.getUrl());
            Map<String, String> headers = request.getRequestHeaders();
            for (Map.Entry<String, String> entry : headers.entrySet()){
                String key = entry.getKey();
                String value = entry.getValue();
                Log.e("{HEADER Aos}" + key, value);
            }
            try {
                Log.e("cookie ", String.valueOf(cookieManager.hasCookies()));

                Log.e("cookie ", "cookie: " + cookieManager.getCookie("cookie"));
            } catch (Exception e){
                Log.e("exception", e.getMessage());
            }

//            WebResourceResponse response = super.shouldInterceptRequest(view, request);
//            Log.e("{statusCode Aos}", String.valueOf(response.getStatusCode()));

            return super.shouldInterceptRequest(view, request);
        }

    }

//    @Override
//    public void startInjectingOnClick(View view) {
//
//        injectScriptFile("test_jquery.js");
//        if (webAppInterface.getIsJQueryLoaded() == 0) {
//            injectScriptFile("jquery214min.js");
//        }
//
//        injectScriptFile("twitter.js");
//        initProgressDialog();
//    }

    private final String URL_MOBILE = "https://mobile.twitter.com/settings/safety";
//    private final String URL_MOBILE = "http://twitter.com/settings/safety";
    private final String URL = "https://mobile.twitter.com/settings/safety";

    public String getURL_MOBILE() {
        return URL_MOBILE;
    }

    public String getURL() {
        return URL;
    }

    @Override
    public WebViewClient getWebViewClient() {
        return new TwitterWebViewActivity.MyWebViewClient();
    }
}