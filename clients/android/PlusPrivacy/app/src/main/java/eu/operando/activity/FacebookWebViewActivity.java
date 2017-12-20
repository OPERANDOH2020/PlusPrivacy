package eu.operando.activity;

import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.Toast;

import com.github.amlcurran.showcaseview.ShowcaseView;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import eu.operando.R;
import eu.operando.customView.ButtonTargetShowCaseView;
import eu.operando.customView.OperandoProgressDialog;

/**
 * Created by Matei_Alexandru on 07.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FacebookWebViewActivity extends BaseActivity {

    private WebView myWebView;
    private String privacySettingsString;
    private WebAppInterface webAppInterface;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_facebook_web_view);
        initData();
        initUI();
    }

    private void initData() {
        privacySettingsString = getIntent().getStringExtra(
                FacebookSettingsActivity.PRIVACY_SETTINGS_TAG);
        Log.e(FacebookSettingsActivity.PRIVACY_SETTINGS_TAG, privacySettingsString);
    }

    private void initUI() {

        setOverlay();
        myWebView = (WebView) findViewById(R.id.webview);

        String newUA = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
        myWebView.getSettings().setUserAgentString(newUA);

        WebSettings webSettings = myWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);

        myWebView.setWebViewClient(new MyWebViewClient());
//        myWebView.setWebViewClient(new InterceptingWebViewClient(this, myWebView));
//        myWebView.setWebViewClient(new WriteHandlingWebViewClient(myWebView));
        webAppInterface = new WebAppInterface(privacySettingsString);
        myWebView.addJavascriptInterface(webAppInterface, "Android");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }
        myWebView.loadUrl("http://facebook.com");
    }

    public void startInjectingOnClick(View view) {
        injectScriptFile("test_jquery.js");
        if (webAppInterface.isJQueryLoaded == 0) {
            injectScriptFile("jquery214min.js");
        }
//        injectScriptFile("test_jquery.js");
//        Log.e("loading jquery", String.valueOf(webAppInterface.isJQueryLoaded));

        injectScriptFile("script.js");
        initProgressDialog();
    }

    private void initProgressDialog() {
        OperandoProgressDialog progressDialog = new OperandoProgressDialog(this);
        progressDialog.setTitle("Applying settings...");
        progressDialog.setMessage("This may take some time");
        progressDialog.setCancelable(true);
        progressDialog.show();
    }

    public void setOverlay() {

        final ShowcaseView showcaseView = new ShowcaseView.Builder(this)
                .withMaterialShowcase()
                .setTarget(new ButtonTargetShowCaseView(
                        (Button) findViewById(R.id.privacy_wizard_activity_start_injecting_button)))
                .setContentTitle("Privacy Wizard")
                .setContentText("Press START button after you are logged into Facebook page.")
                .setStyle(R.style.InjectingButtonShowCaseView)
                .blockAllTouches()
                .build();

        changeStatusBarColor(R.color.overlay_background);

        showcaseView.overrideButtonClick(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changeStatusBarColor(R.color.primary_color_dark);
                showcaseView.hide();
            }
        });
    }

    public void changeStatusBarColor(int color) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(ContextCompat.getColor(getApplicationContext(),
                    color));
        }
    }

    private class MyWebViewClient extends WebViewClient {

        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                Log.e("InterceptReqv2", request.getMethod() + " " + request.getUrl().toString());

                Map<String, String> params = new HashMap<>();
                Set<String> queryParams = request.getUrl().getQueryParameterNames();
                for (String param : queryParams) {
                    params.put(param, request.getUrl().getQueryParameter(param));
                }

                Set<String> keys = new TreeSet<>(Arrays.asList(
                        "__user",
                        "__a",
                        "__dyn",
                        "__af",
                        "__req",
                        "__be",
                        "__pc",
                        "__rev",
                        "fb_dtsg",
                        "jazoest",
                        "__spin_r",
                        "__spin_b",
                        "__spin_t"
                ));

                if (params.keySet().contains("fb_dtsg") || params.keySet().contains("jazoest")) {
                    for (Map.Entry<String, String> entry : params.entrySet()) {
                        Log.e("WebResourceRequest", entry.getKey() + " " + entry.getValue());
                    }
                }
            }
            return super.shouldInterceptRequest(view, request);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
//            injectScriptForPrivacySettings();
        }
    }

    private void injectScriptFile(String scriptFile) {
        InputStream input;
        try {
            input = getAssets().open(scriptFile);
            byte[] buffer = new byte[input.available()];
            input.read(buffer);
            input.close();

            String encoded = Base64.encodeToString(buffer, Base64.NO_WRAP);
            myWebView.loadUrl("javascript:(function() {" +
                    "var parent = document.getElementsByTagName('head').item(0);" +
                    "var script = document.createElement('script');" +
                    "script.type = 'text/javascript';" +
                    // Tell the browser to BASE64-decode the string into your script !!!
                    "script.innerHTML = window.atob('" + encoded + "');" +
                    "parent.appendChild(script)" +
                    "})()");
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public class WebAppInterface {

        private String privacySettings;
        private int isJQueryLoaded;

        public WebAppInterface(String privacySettings) {
            this.privacySettings = privacySettings;
        }

        @JavascriptInterface
        public String getPrivacySettings() {
            return privacySettings;
        }

        @JavascriptInterface
        public void onFinishedLoadingCallback() {
            Toast.makeText(getApplicationContext(), "Settings Loaded", Toast.LENGTH_SHORT).show();
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    finish();
                }
            });
        }

        @JavascriptInterface
        public void isLoaded(int jquery) {
            Log.e("WebAppI isLoaded", String.valueOf(jquery));
            isJQueryLoaded = jquery;
        }
    }

}
