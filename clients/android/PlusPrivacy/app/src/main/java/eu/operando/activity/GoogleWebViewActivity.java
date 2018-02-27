package eu.operando.activity;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.Map;

import eu.operando.R;

/**
 * Created by Alex on 2/16/2018.
 */

public class GoogleWebViewActivity extends SocialNetworkWebViewActivity {

    private int totalQuestions;
    private boolean shouldInjectUsualSettings = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        totalQuestions = privacySettingsJSONArray.length();
    }

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

            startButton.setVisibility(View.GONE);
            progressBar.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public SocialNetworkWebViewActivity.WebAppInterface getWebAppInterface() {
        return new WebAppInterface(this, privacySettingsString);
    }

    public class WebAppInterface extends SocialNetworkWebViewActivity.WebAppInterface{

        private String privacySettings;
        private int isJQueryLoaded;
        private Context context;
        private int index = 0;

        public WebAppInterface(Context context, String privacySettings) {
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
            progressDialog.dismiss();
        }

        @JavascriptInterface
        public void setProgressBar() {
            index++;
            progressBar.setMax(totalQuestions);
            progressBar.setProgress(index);
        }

        @JavascriptInterface
        public void setProgressBar(int activityIndex, int totalActivity) {

            progressBar.setMax(totalQuestions);
            progressBar.setProgress(index + activityIndex);
        }

    }

}