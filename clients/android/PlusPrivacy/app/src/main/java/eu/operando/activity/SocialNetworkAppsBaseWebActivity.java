package eu.operando.activity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Build;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.CheckBox;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.io.IOException;
import java.io.InputStream;

import eu.operando.R;
import eu.operando.customView.MyWebViewClient;
import eu.operando.storage.Storage;
import eu.operando.utils.WebAppI;

/**
 * Created by Alex on 3/28/2018.
 */

public abstract class SocialNetworkAppsBaseWebActivity extends BaseActivity implements MyWebViewClient.SocialNetworkInterface {

    protected WebView myWebView;
    protected WebAppI webAppInterface;
    protected boolean shouldInject = false;
    protected boolean triggered = false;

    protected CookieManager cookieManager;
    protected Object mutex = new Object();
    protected ProgressBar progressBar;
    protected FrameLayout frameLayout;
    protected AlertDialog loginDialog;


    public abstract String getURL_MOBILE();

    protected abstract String getURL();

    public abstract WebViewClient getWebViewClient();

    public abstract WebAppI getWebAppInterface();

    public abstract String getJsFile();

    public abstract String getIsLoggedJsFile();

    public abstract void initData();

    protected void initUI() {

        if (!Storage.getSocialNetworkDialogOption()) {
            showSocialNetworkDialog();
        }

        progressBar = (ProgressBar) findViewById(R.id.progress_bar);
        myWebView = (WebView) findViewById(R.id.webview);
        frameLayout = (FrameLayout) findViewById(R.id.webview_frame);


        WebSettings webSettings = myWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        myWebView.setWebViewClient(getWebViewClient());

        webAppInterface = getWebAppInterface();
        myWebView.addJavascriptInterface(webAppInterface, "Android");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }

        cookieManager = CookieManager.getInstance();
//        cookieManager.removeAllCookie();
        CookieSyncManager.getInstance().sync();
        CookieManager.setAcceptFileSchemeCookies(true);

        if (Build.VERSION.SDK_INT >= 21) {
            cookieManager.setAcceptThirdPartyCookies(myWebView, true);
        } else {
            cookieManager.setAcceptCookie(true);
        }

        myWebView.loadUrl(getURL_MOBILE());
    }

    public void showSocialNetworkDialog() {

        LayoutInflater inflater = getLayoutInflater();
        View convertView = inflater.inflate(R.layout.dialog_private_browsing, null);

        final CheckBox checkBox = (CheckBox) convertView.findViewById(R.id.do_not_show_cb);

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setView(convertView)
                .setTitle(R.string.social_network_privacy)
                .setMessage(R.string.social_networks_overlay_dialog_message)
                .setPositiveButton(R.string.action_ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        Storage.saveSocialNetworkDialogOption(checkBox.isChecked());
                        dialog.dismiss();
                    }
                });
        loginDialog = builder.create();
        loginDialog.show();

    }

    public void startInjecting() {

        if (!shouldInject) {

            if (loginDialog!= null){
                loginDialog.dismiss();
            }
            setUserAgent();
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

    public void setUserAgent() {
//        String newUA = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
        String newUA = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0";
        myWebView.getSettings().setUserAgentString(newUA);
        myWebView.getSettings().setUseWideViewPort(false);
        myWebView.getSettings().setLoadWithOverviewMode(true);
        myWebView.clearHistory();

    }


    public void onPageCommitVisible() {
        onPageListener();
    }

    public void onPageListener() {

        synchronized (mutex) {
            if (!triggered) {
                injectScriptFile(getIsLoggedJsFile());
            } else {
                if (shouldInject) {
                    injectScriptFile("test_jquery.js");
                    if (webAppInterface.getIsJQueryLoaded() == 0) {
                        injectScriptFile("jquery214min.js");
                    }

                    shouldInject = false;
                    injectScriptFile(getJsFile());
                }
            }
        }
    }

    public void onPageFinished() {

        if (Build.VERSION.SDK_INT < 23) {
            onPageListener();
        }
    }

    protected void initProgressDialog() {
        if (!isFinishing()) {
            frameLayout.setVisibility(View.VISIBLE);
        }
    }

    protected void injectScriptFile(String scriptFile) {
        InputStream input;
        try {
            input = getAssets().open(scriptFile);
            byte[] buffer = new byte[input.available()];
            input.read(buffer);
            input.close();

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {

                String jsString = new String(buffer);
                myWebView.evaluateJavascript(jsString, null);

            } else {

                String encoded = Base64.encodeToString(buffer, Base64.NO_WRAP);
                myWebView.loadUrl("(function() {" +
                        "" +
                        "var parent = document.getElementsByTagName('head').item(0);" +
                        "var script = document.createElement('script');" +
                        "script.type = 'text/javascript';" +
                        // Tell the browser to BASE64-decode the string into your script !!!
                        "script.innerHTML = window.atob('" + encoded + "');" +
                        "parent.appendChild(script)" +
                        "})()");

            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
