package eu.operando.activity;

import android.app.ProgressDialog;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.util.Map;

import eu.operando.customView.OperandoProgressDialog;

/**
 * Created by Matei_Alexandru on 19.01.2018.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class LinkedinWebViewActivity extends SocialNetworkWebViewActivity{

    public class MyWebViewClient extends WebViewClient {

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
//            injectScriptForPrivacySettings();
            if (shouldInject) {
                injectScriptFile("test_jquery.js");
                if (webAppInterface.getIsJQueryLoaded() == 0) {
                    //injectScriptFile("jquery214min.js");
                }

                //injectScriptFile("linkedin.js");
                injectScriptFile("jquery214min.js");
                injectScriptFile("linkedin.js");
//                myWebView.loadUrl("javascript:window.Android.processHTML('<head>'+document.getElementsByTagName('html')[0].innerHTML+'</head>');");
                initProgressDialog();
                shouldInject = false;
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
                Log.e(key, value);
            }

            return super.shouldInterceptRequest(view, request);
        }
    }

    @Override
    protected void initProgressDialog() {
        if (!isFinishing()) {
            progressDialog = new ProgressDialog(this);
            progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            progressDialog.setTitle("Applying settings...");
            progressDialog.setMessage("This may take some time");
            progressDialog.setCancelable(true);
            progressDialog.show();
        }
    }

    private final String URL_MOBILE = "http://linkedin.com";
    private final String URL = "http://linkedin.com/psettings/privacy";

    public String getURL_MOBILE() {
        return URL_MOBILE;
    }

    public String getURL() {
        return URL;
    }

    @Override
    public WebViewClient getWebViewClient() {
        return new MyWebViewClient();
    }
}
