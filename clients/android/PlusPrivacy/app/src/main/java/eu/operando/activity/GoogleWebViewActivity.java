package eu.operando.activity;

import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

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

                injectScriptFile("google.js");
                shouldInject = false;
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

//            WebResourceResponse response = super.shouldInterceptRequest(view, request);
//            Log.e("{statusCode Aos}", String.valueOf(response.getStatusCode()));

            return super.shouldInterceptRequest(view, request);
        }
    }

    private final String URL_MOBILE = "https://myaccount.google.com/activitycontrols";

    private final String URL = "https://myaccount.google.com/activitycontrols";

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
}