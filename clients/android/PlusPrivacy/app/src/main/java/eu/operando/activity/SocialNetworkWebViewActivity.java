package eu.operando.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.TranslateAnimation;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.github.amlcurran.showcaseview.ShowcaseView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import java.io.IOException;
import java.io.InputStream;

import eu.operando.R;
import eu.operando.customView.ButtonTargetShowCaseView;
import eu.operando.customView.MyWebViewClient;
import eu.operando.customView.OperandoProgressDialog;

/**
 * Created by Alex on 1/19/2018.
 */

public abstract class SocialNetworkWebViewActivity extends BaseActivity implements MyWebViewClient.SocialNetworkInterface {

    protected WebView myWebView;
    protected String privacySettingsString;
    protected SocialNetworkWebViewActivity.WebAppInterface webAppInterface;
    protected boolean shouldInject = false;
    protected ProgressDialog progressDialog;
    protected CookieManager cookieManager;
    protected ImageView paperAirplane;
    protected JSONArray privacySettingsJSONArray;
    protected JSONArray usualSettings = new JSONArray();
    protected JSONArray preferencesSettings = new JSONArray();
    protected JSONArray activityControlsSettings = new JSONArray();
    protected Object mutex = new Object();
    protected ProgressBar progressBar;
    protected Button startButton;
    protected FrameLayout frameLayout;
    private int totalQuestions;


    public abstract String getURL_MOBILE();

    protected abstract String getURL();

    public abstract WebViewClient getWebViewClient();

    public abstract WebAppInterface getWebAppInterface();

    public abstract String getJsFile();


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_facebook_web_view);
        initData();
        initUI();
    }

    private void initData() {
        privacySettingsString = getIntent().getStringExtra(
                SocialNetworkFormBaseActivity.PRIVACY_SETTINGS_TAG);
        try {
            privacySettingsJSONArray = new JSONArray(privacySettingsString);
            for (int j = 0; j < privacySettingsJSONArray.length(); ++j) {

                JSONObject setting = privacySettingsJSONArray.getJSONObject(j);
                if (setting.has("method_type")) {
                    if (setting.get("method_type").equals("GET")) {
                        preferencesSettings.put(setting);
                    } else {
                        activityControlsSettings.put(setting);
                    }
                } else {
                    usualSettings.put(setting);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.e(SocialNetworkFormBaseActivity.PRIVACY_SETTINGS_TAG, privacySettingsString);
        totalQuestions = privacySettingsJSONArray.length();
    }

    private void initUI() {

        startButton = (Button) findViewById(R.id.start_injecting_button);
        progressBar = (ProgressBar) findViewById(R.id.progress_bar);
        myWebView = (WebView) findViewById(R.id.webview);
        frameLayout = (FrameLayout) findViewById(R.id.webview_frame);

        setOverlay();

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
        CookieSyncManager.getInstance().sync();
        CookieManager.setAcceptFileSchemeCookies(true);

        if (Build.VERSION.SDK_INT >= 21) {
            cookieManager.setAcceptThirdPartyCookies(myWebView, true);
        } else {
            cookieManager.setAcceptCookie(true);
        }

        myWebView.loadUrl(getURL_MOBILE());
    }

    public void startInjectingOnClick(View view) {

        if (!shouldInject) {

            setAgent();
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

    public void onPageListener() {

        synchronized (mutex) {
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

    public void setAgent() {
        String newUA = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
        myWebView.getSettings().setUserAgentString(newUA);
    }

    protected void initProgressDialog() {
        if (!isFinishing()) {
            frameLayout.setVisibility(View.VISIBLE);
            startButton.setVisibility(View.GONE);
            progressBar.setVisibility(View.VISIBLE);
        }
    }

    public void setOverlay() {

        final ShowcaseView showcaseView = new ShowcaseView.Builder(this)
                .withMaterialShowcase()
                .setTarget(new ButtonTargetShowCaseView(
                        (Button) findViewById(R.id.start_injecting_button)))
                .setContentTitle("Privacy Wizard")
                .setContentText("Press START button after you are logged")
                .setStyle(R.style.InjectingButtonShowCaseView)
                .blockAllTouches()
                .build();

        changeStatusBarColor(R.color.overlay_background);

        showcaseView.overrideButtonClick(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changeStatusBarColor(R.color.black);
                showcaseView.hide();
            }
        });

        setPaperAirplane(showcaseView);
    }

    private void setPaperAirplane(ShowcaseView showcaseView) {

        View inflatedView = View.inflate(showcaseView.getContext(),
                R.layout.fragment_webview_social_network, showcaseView);
        ImageView paperAirplane = (ImageView) inflatedView.findViewById(R.id.paper_airplane);
        paperAirplane.startAnimation(buildAnimationForPaperAirplane());
    }

    private Animation buildAnimationForPaperAirplane() {

        Animation animation = new TranslateAnimation(0, 15, 0, -15);
        animation.setDuration(500);
        animation.setFillAfter(true);
        animation.setRepeatCount(Animation.INFINITE);
        animation.setRepeatMode(Animation.REVERSE);
        animation.setInterpolator(new LinearInterpolator());

        return animation;
    }

    public void changeStatusBarColor(int color) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(ContextCompat.getColor(getApplicationContext(),
                    color));
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

    public class WebAppInterface {

        private String privacySettings;
        private int isJQueryLoaded;
        private Context context;
        private int index = 0;

        public WebAppInterface(Context context, String privacySettings) {
            this.context = context;
            this.privacySettings = privacySettings;
        }

        @JavascriptInterface
        public String getPrivacySettings() {
            return privacySettings;
        }

        @JavascriptInterface
        public void showToast(String message) {
            Log.e("msg from the dark side", message);
        }

        @JavascriptInterface
        public void onFinishedLoadingCallback() {

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (!isFinishing()) {
                        finish();
                        Toast.makeText(getApplicationContext(), "Settings Loaded", Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }

        @JavascriptInterface
        public void isLoaded(int jquery) {
            Log.e("WebAppI isLoaded", String.valueOf(jquery));
            isJQueryLoaded = jquery;
        }

        @JavascriptInterface
        public void setProgressBar() {
            index++;
            progressBar.setMax(totalQuestions);
            progressBar.setProgress(index);
        }

        @JavascriptInterface
        public void setProgressBar(int activityIndex, int totalActivity) {

            progressBar.setMax(totalActivity);
            progressBar.setProgress(index + activityIndex);
        }

        @JavascriptInterface
        public void setProgressBar(int activityIndex) {

            progressBar.setMax(totalQuestions);
            progressBar.setProgress(index + activityIndex);
        }

        public int getIsJQueryLoaded() {
            return isJQueryLoaded;
        }

        public void setIsJQueryLoaded(int isJQueryLoaded) {
            this.isJQueryLoaded = isJQueryLoaded;
        }
    }

}
