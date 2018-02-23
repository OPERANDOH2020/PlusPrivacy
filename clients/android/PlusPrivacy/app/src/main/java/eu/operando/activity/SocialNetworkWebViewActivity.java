package eu.operando.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.TranslateAnimation;
import android.webkit.ConsoleMessage;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import com.github.amlcurran.showcaseview.ShowcaseView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

import eu.operando.R;
import eu.operando.customView.ButtonTargetShowCaseView;
import eu.operando.customView.OperandoProgressDialog;

/**
 * Created by Alex on 1/19/2018.
 */

public abstract class SocialNetworkWebViewActivity extends BaseActivity {

    protected WebView myWebView;
    private String privacySettingsString;
    protected SocialNetworkWebViewActivity.WebAppInterface webAppInterface;
    protected boolean shouldInject = false;
    protected ProgressDialog progressDialog;
    protected CookieManager cookieManager;
    protected ImageView paperAirplane;
    protected JSONArray privacySettingsJSONArray;
    protected JSONArray usualSettings = new JSONArray();
    protected JSONArray preferencesSettings = new JSONArray();
    protected JSONArray activityControlsSettings = new JSONArray();

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
    }

    private void initUI() {

        setOverlay();

        myWebView = (WebView) findViewById(R.id.webview);

        WebSettings webSettings = myWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);

//        setAgent();

        myWebView.setWebViewClient(getWebViewClient());
        myWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
                Log.e("My JS Console", consoleMessage.message() + " -- From line "
                        + consoleMessage.lineNumber() + " of "
                        + consoleMessage.sourceId());
                return super.onConsoleMessage(consoleMessage);
            }
        });
        webAppInterface = new WebAppInterface(this, privacySettingsString);
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

    public abstract String getURL_MOBILE();

    protected abstract String getURL();

    public abstract WebViewClient getWebViewClient();

    public void startInjectingOnClick(View view) {
        if (!shouldInject) {

//            setAgent();

            myWebView.loadUrl(getURL());

            if (android.os.Build.VERSION.SDK_INT >= 21) {
                CookieManager.getInstance().setAcceptThirdPartyCookies(myWebView, true);
            } else {
                CookieManager.getInstance().setAcceptCookie(true);
            }

            shouldInject = true;
        }
    }

    public void setAgent() {
        String newUA = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0";
        myWebView.getSettings().setUserAgentString(newUA);
    }

    protected void initProgressDialog() {
        if (!isFinishing()) {
            progressDialog = new OperandoProgressDialog(this);
            progressDialog.setTitle("Applying settings...");
            progressDialog.setMessage("This may take some time");
            progressDialog.setCancelable(true);
            progressDialog.show();
        }
    }

    public void setOverlay() {

        final ShowcaseView showcaseView = new ShowcaseView.Builder(this)
                .withMaterialShowcase()
                .setTarget(new ButtonTargetShowCaseView(
                        (Button) findViewById(R.id.privacy_wizard_activity_start_injecting_button)))
                .setContentTitle("Privacy Wizard")
                .setContentText("Press START button after you are logged")
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
//                Log.e("PRIVACY", jsString);
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
//                    "script.src = \"" + SCRIPT_URL + "\";" +
                        "parent.appendChild(script)" +
                        "})()");

            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
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

//    String SCRIPT_URL = "https://raw.githubusercontent.com/OPERANDOH2020/PlusPrivacy/android/clients/android/PlusPrivacy/app/src/main/assets/twitter_desktop.js";

    public class WebAppInterface {

        private String privacySettings;
        private int isJQueryLoaded;
        private Context context;

        public WebAppInterface(Context context, String privacySettings) {
            this.context = context;
            this.privacySettings = privacySettings;
        }

        @JavascriptInterface
        @SuppressWarnings("unused")
        public void processHTML(String html) {
//            Log.e("htmlString", html);
        }

        @JavascriptInterface
        public String getPrivacySettings() {
            return privacySettings;
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
        public void showToast(String message) {
            Log.e("msg from the dark side", message);
//            Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
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
//                    myWebView.loadUrl("https://myaccount.google.com/activitycontrols");
                    injectScriptFile("google_activity_controls.js");
                }
            });
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
        public void dismissDialog() {
            progressDialog.dismiss();
        }

        @JavascriptInterface
        public String doGetRequest(String url) {
            URL obj = null;
            try {
                obj = new URL(url);

                HttpURLConnection con = (HttpURLConnection) obj.openConnection();

                // optional default is GET
                con.setRequestMethod("GET");

                //add request header
                con.setRequestProperty("User-Agent", "Mozilla/5.0");

                int responseCode = con.getResponseCode();
                Log.e("'GET' URL: ", url);
                Log.e("Response Code : ", String.valueOf(responseCode));

                BufferedReader in = new BufferedReader(
                        new InputStreamReader(con.getInputStream()));
                String inputLine;
                StringBuffer response = new StringBuffer();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                //print result
                Log.e("GET response: ", response.toString());

                return response.toString();

            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (ProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

            return null;
        }

        @JavascriptInterface
        public void isLoaded(int jquery) {
            Log.e("WebAppI isLoaded", String.valueOf(jquery));
            isJQueryLoaded = jquery;
        }

        @JavascriptInterface
        public void setProgress(int index, int total) {
            Log.e("index", String.valueOf(index));
            Log.e("total", String.valueOf(total));
            Log.e("percent", String.valueOf(index * 100 / total));
            int percent = index * 100 / total;
            progressDialog.setMax(100);
            progressDialog.setProgress(percent);
        }

        public int getIsJQueryLoaded() {
            return isJQueryLoaded;
        }

        public void setIsJQueryLoaded(int isJQueryLoaded) {
            this.isJQueryLoaded = isJQueryLoaded;
        }
    }

}
