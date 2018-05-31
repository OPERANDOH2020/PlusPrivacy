package eu.operando.activity;


import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ExpandableListView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.List;

import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.tasks.AccordionOnGroupExpandListener;
import eu.operando.customView.MyWebViewClient;
import eu.operando.models.SocialNetworkApp;
import eu.operando.utils.WebAppI;

/**
 * Created by Alex on 3/26/2018.
 */

public abstract class SocialNetworkAppsListActivity extends SocialNetworkWebViewBaseActivity implements MyWebViewClient.SocialNetworkInterface, ScannerListAdapter.RemoveAppInterface, ScannerListAdapter.SocialNetworkColor{

    private List<SocialNetworkApp> apps;
    private ExpandableListView listView;
    private ScannerListAdapter adapter;

    @Override
    public String getURL_MOBILE() {
        return null;
    }

    @Override
    public WebViewClient getWebViewClient() {
        return null;
    }

    @Override
    public WebAppI getWebAppInterface() {
        return null;
    }

    @Override
    public String getIsLoggedJsFile() {
        return null;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scanner);
        initUI();
        initData();
    }

    public void initUI() {

        listView = (ExpandableListView) findViewById(R.id.app_list_view);
        myWebView = (WebView) findViewById(R.id.webview);
        setWebView();
        setToolbar();

    }

    public void initData() {

        String stringApps = getIntent().getStringExtra("APPS");

        Type collectionType = new TypeToken<Collection<SocialNetworkApp>>() {
        }.getType();
        apps = new Gson().fromJson(stringApps, collectionType);
        setDataListView(apps);

    }

    private void setDataListView(List<SocialNetworkApp> list) {

        listView.setOnGroupExpandListener(new AccordionOnGroupExpandListener(listView));

        adapter = new ScannerListAdapter(this, list);
        listView.setAdapter(adapter);

    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    private void setWebView() {

        WebSettings webSettings = myWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        myWebView.setWebViewClient(new MyWebViewClient(this));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }
    }

    @Override
    public void removeSocialApp(String appId) {

        RemoveWebAppInterface webAppInterface = new RemoveWebAppInterface(appId);
        myWebView.addJavascriptInterface(webAppInterface, "Android");
        myWebView.loadUrl(getURL());
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.scanner_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(
                ContextCompat.getColor(this, getSNMainColor())));
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    public void onPageListener() {

        injectScriptFile("jquery214min.js");
        injectScriptFile("RegexUtils.js");
        injectScriptFile(getJsFile());
    }

    private class RemoveWebAppInterface extends WebAppI {

        private String appId;

        private int isJQueryLoaded;

        public RemoveWebAppInterface(String appId) {
            this.appId = appId;
        }

        @JavascriptInterface
        public void showMessage(String message) {
            Log.e("msg from the dark side", message);
        }

        @JavascriptInterface
        public String getAppId() {
            return appId;
        }

        @JavascriptInterface
        public void onAppRemoved(final String appId) {
            myWebView.post(new Runnable() {
                @Override
                public void run() {

                    Toast.makeText(SocialNetworkAppsListActivity.this,
                            "App has been removed", Toast.LENGTH_SHORT).show();
                    adapter.removeGroupItem(appId);
                }
            });
        }

        @JavascriptInterface
        public int getIsJQueryLoaded() {
            return isJQueryLoaded;
        }

        @Override
        public void showToast(String message) {

        }

        @JavascriptInterface
        public void isLoaded(int jquery) {
            Log.e("WebAppI isLoaded", String.valueOf(jquery));
            isJQueryLoaded = jquery;
        }
    }
}