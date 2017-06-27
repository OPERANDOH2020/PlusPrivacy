/*
 * Copyright (c) 2016 {UPRC}.
 *
 * OperandoApp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OperandoApp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OperandoApp.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contributors:
 *       Nikos Lykousas {UPRC}, Constantinos Patsakis {UPRC}
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

package eu.operando.proxy;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.security.KeyChain;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.Toast;

import com.squareup.otto.Subscribe;

import org.apache.commons.io.IOUtils;
import org.bouncycastle.operator.OperatorCreationException;


import java.io.IOException;
import java.io.InputStream;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.security.GeneralSecurityException;
import java.security.cert.Certificate;
import java.security.cert.CertificateEncodingException;

import be.shouldit.proxy.lib.APL;
import eu.operando.R;
import eu.operando.proxy.about.AboutActivity;
import eu.operando.proxy.filters.domain.DomainFiltersActivity;
import eu.operando.proxy.filters.response.ResponseFiltersActivity;
import eu.operando.proxy.service.ProxyService;
import eu.operando.proxy.settings.SettingActivity;
import eu.operando.proxy.settings.Settings;
import eu.operando.proxy.settings.ThemeStyle;
import eu.operando.proxy.util.CertificateUtil;
import eu.operando.proxy.util.Logger;
import eu.operando.proxy.util.MainUtil;
import eu.operando.proxy.wifi.AccessPointsActivity;
import mitm.Authority;
import mitm.BouncyCastleSslEngineSource;
import mitm.RootCertificateException;

//proxy status: active, paused, stopped. (ean den exw certs, to isProxyRunning einai false).
//link to proxy: established, non-established
enum OperandoProxyStatus {
    ACTIVE,
    PAUSED,
    STOPPED
}

enum OperandoProxyLink {
    VALID,
    INVALID
}

public class MainProxyActivity extends AppCompatActivity implements OnSharedPreferenceChangeListener {

    private MainContext mainContext = MainContext.INSTANCE;
    private FloatingActionButton fab = null;
    private WebView webView = null;

    //Buttons
    private Button WiFiAPButton = null;
    private Button responseFiltersButton = null;
    private Button domainFiltersButton = null;
    private Button debugLogButton = null;

    public static void start(Context context) {
        Intent starter = new Intent(context, MainProxyActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {


        MainUtil.initializeMainContext(getApplicationContext());
        Settings settings = mainContext.getSettings();
        settings.initializeDefaultValues();
        setCurrentThemeStyle(settings.getThemeStyle());
        setTheme(getCurrentThemeStyle().themeAppCompatStyle());
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        settings.registerOnSharedPreferenceChangeListener(this);


        webView = (WebView) findViewById(R.id.webView);
        webView.getSettings().setJavaScriptEnabled(true);


        fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MainUtil.isServiceRunning(mainContext.getContext(), ProxyService.class) && !MainUtil.isProxyPaused(mainContext)) {
                    //Update Preferences to BypassProxy
                    MainUtil.setProxyPaused(mainContext, true);
                    fab.setImageResource(android.R.drawable.ic_media_play);
                    //Toast.makeText(mainContext.getContext(), "-- bypass (disable) proxy --", Toast.LENGTH_SHORT).show();
                } else if (MainUtil.isServiceRunning(mainContext.getContext(), ProxyService.class) && MainUtil.isProxyPaused(mainContext)) {

                    MainUtil.setProxyPaused(mainContext, false);
                    fab.setImageResource(android.R.drawable.ic_media_pause);
                    //Toast.makeText(mainContext.getContext(), "-- re-enable proxy --", Toast.LENGTH_SHORT).show();
                } else if (!mainContext.getAuthority().aliasFile(BouncyCastleSslEngineSource.KEY_STORE_FILE_EXTENSION).exists()) {
                    try {
                        installCert();
                    } catch (RootCertificateException | GeneralSecurityException | OperatorCreationException | IOException ex) {
                        Logger.error(this, ex.getMessage(), ex.getCause());
                    }
                }
            }
        });

        //Buttons

        WiFiAPButton = (Button) findViewById(R.id.WiFiAPButton);
        WiFiAPButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                Intent i = new Intent(mainContext.getContext(), AccessPointsActivity.class);
                startActivity(i);
            }
        });


        responseFiltersButton = (Button) findViewById(R.id.responseFiltersButton);
        responseFiltersButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent i = new Intent(mainContext.getContext(), ResponseFiltersActivity.class);
                startActivity(i);
            }
        });

        domainFiltersButton = (Button) findViewById(R.id.domainFiltersButton);
        domainFiltersButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent i = new Intent(mainContext.getContext(), DomainFiltersActivity.class);
                startActivity(i);
            }
        });


        /*debugLogButton = (Button) findViewById(R.id.debugLogButton);

        debugLogButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
//                AlertDialog.Builder builder = new AlertDialog.Builder(MainProxyActivity.this);
//
//                builder.setPositiveButton(android.R.string.ok, null);
//                builder.setTitle("Operando Proxy Conf");
//                builder.setMessage("host: 127.0.0.1, port: 8899");
//                builder.create().show();

                Intent i = new Intent(android.provider.Settings.ACTION_APN_SETTINGS);
                i.putExtra("sub_id", 1); //SubscriptionManager.NAME_SOURCE_SIM_SOURCE
                startActivity(i);


                Map<APLNetworkId, WifiConfiguration> networks = APL.getConfiguredNetworks();
                Iterator<Map.Entry<APLNetworkId, WifiConfiguration>> entries = networks.entrySet().iterator();
                while (entries.hasNext()) {
                    Map.Entry<APLNetworkId, WifiConfiguration> entry = entries.next();
                    //System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
                }
                try {
                    Proxy proxy = APL.getCurrentHttpProxyConfiguration();
                    InetSocketAddress proxyAddress = (InetSocketAddress) proxy.address();
                    Log.e("OPERANDO", proxy.toString() + " --> " + proxyAddress.getHostName() + "::" + "---->" + proxyAddress.getPort());
                } catch (Exception e) {
                    //e.printStackTrace();
                }
            }
        });
        */

        //Action Bar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        ActionBar actionBar = getSupportActionBar();


        initializeProxyService();
    }

    private void startProxyService() {
        if (mainContext.getSharedPreferences().getBoolean("proxyPaused", false))
            fab.setImageResource(android.R.drawable.ic_media_play);
        else
            fab.setImageResource(android.R.drawable.ic_media_pause);
        MainUtil.startProxyService(mainContext);
    }

    private void installCert() throws RootCertificateException, GeneralSecurityException, OperatorCreationException, IOException {

        new AsyncTask<Void, Void, Certificate>() {
            Exception error;
            ProgressDialog dialog;

            @Override
            protected void onPreExecute() {
                dialog = ProgressDialog.show(MainProxyActivity.this, null,
                        "Generating SSL certificate...");
                dialog.setCancelable(false);
            }

            @Override
            protected Certificate doInBackground(Void... params) {
                try {
                    Certificate cert = BouncyCastleSslEngineSource.initializeKeyStoreStatic(mainContext.getAuthority());
                    return cert;
                } catch (Exception e) {
                    error = e;
                    return null;
                }
            }

            @Override
            protected void onPostExecute(Certificate certificate) {
                dialog.dismiss();

                if (certificate != null) {
                    Intent intent = KeyChain.createInstallIntent();
                    try {
                        intent.putExtra(KeyChain.EXTRA_CERTIFICATE, certificate.getEncoded());
                    } catch (CertificateEncodingException e) {
                        e.printStackTrace();
                    }
                    intent.putExtra(KeyChain.EXTRA_NAME, mainContext.getAuthority().commonName());
                    startActivityForResult(intent, 1);
                } else {
                    Toast.makeText(
                            MainProxyActivity.this,
                            "Failed to load certificates, exiting: "
                                    + error.getMessage(), Toast.LENGTH_LONG)
                            .show();
                    finish();
                }
            }
        }.execute();

    }


    private void initializeProxyService() {
        Authority authority = mainContext.getAuthority();
        try {
            if (CertificateUtil.isCACertificateInstalled(authority.aliasFile(BouncyCastleSslEngineSource.KEY_STORE_FILE_EXTENSION),
                    BouncyCastleSslEngineSource.KEY_STORE_TYPE,
                    authority.password())) {
                startProxyService();
            } else {
                installCert();
            }
        } catch (RootCertificateException | GeneralSecurityException | OperatorCreationException | IOException ex) {
            Logger.error(this, ex.getMessage(), ex.getCause());
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1) {
            if (resultCode == Activity.RESULT_OK) {
                startProxyService();
            } else {
                //super.onActivityResult(requestCode, resultCode, data);
                if (mainContext.getAuthority().aliasFile(BouncyCastleSslEngineSource.KEY_STORE_FILE_EXTENSION).exists()) {
                    mainContext.getAuthority().aliasFile(BouncyCastleSslEngineSource.KEY_STORE_FILE_EXTENSION).delete();
                }
            }
        }
    }


    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        if (shouldReload()) {
            reloadActivity();
        } else {
            mainContext.getScanner().update();
        }
    }

    protected boolean shouldReload() {
        Settings settings = mainContext.getSettings();
        ThemeStyle settingThemeStyle = settings.getThemeStyle();
        boolean result = !getCurrentThemeStyle().equals(settingThemeStyle);
        if (result) {
            setCurrentThemeStyle(settingThemeStyle);
        }
        return result;
    }

    private void reloadActivity() {
        finish();
        Intent intent = new Intent(this, MainProxyActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP |
                Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }


    @Override
    protected void onPause() {
        super.onPause();
        mainContext.getBUS().unregister(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mainContext.getBUS().register(this);
        updateStatusView();
    }


    private ThemeStyle currentThemeStyle;

    protected ThemeStyle getCurrentThemeStyle() {
        return currentThemeStyle;
    }

    protected void setCurrentThemeStyle(ThemeStyle currentThemeStyle) {
        this.currentThemeStyle = currentThemeStyle;
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.settings_menu:
                Intent settingsIntent = new Intent(mainContext.getContext(), SettingActivity.class);
                startActivity(settingsIntent);
                return true;
            case R.id.apn_menu: {
                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle(R.string.action_apn);
                builder.setPositiveButton(android.R.string.cancel, null);
                builder.setNegativeButton("Open APN Settings", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        Intent apnIntent = new Intent(android.provider.Settings.ACTION_APN_SETTINGS);
                        apnIntent.putExtra("sub_id", 1); //SubscriptionManager.NAME_SOURCE_SIM_SOURCE
                        startActivity(apnIntent);
                    }
                });
                String message = "In order to enable OperandoApp proxy while using wireless networks (e.g. 3G), you will need to modify the corresponding Access Point configuration for your provider. Please set the following values:\n\nProxy: 127.0.0.1\nPort: 8899";
                builder.setMessage(message);
                builder.create().show();

                return true;
            }
            case R.id.help_menu:
                Toast.makeText(this, "You have selected HELP (To be added).", Toast.LENGTH_SHORT).show();
                return true;
            case R.id.about_menu:
                Intent aboutIntent = new Intent(mainContext.getContext(), AboutActivity.class);
                startActivity(aboutIntent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Subscribe
    public void onOperandoStatusEvent(OperandoStatusEvent event) {
        updateStatusView();
    }


    private void updateStatusView() {

        OperandoProxyStatus proxyStatus = OperandoProxyStatus.STOPPED;
        OperandoProxyLink proxyLink = OperandoProxyLink.INVALID;

        boolean isProxyRunning = MainUtil.isServiceRunning(mainContext.getContext(), ProxyService.class);
        boolean isProxyPaused = MainUtil.isProxyPaused(mainContext);

        if (isProxyRunning) {
            if (isProxyPaused) {
                proxyStatus = OperandoProxyStatus.PAUSED;
            } else {
                proxyStatus = OperandoProxyStatus.ACTIVE;
            }
        }

        try {
            Proxy proxy = APL.getCurrentHttpProxyConfiguration();
            InetSocketAddress proxyAddress = (InetSocketAddress) proxy.address();
            if (proxyAddress != null) {
                //TODO: THIS SHOULD BE DYNAMIC
                String proxyHost = proxyAddress.getHostName();
                int proxyPort = proxyAddress.getPort();

                if (proxyHost.equals("127.0.0.1") && proxyPort == 8899) {
                    proxyLink = OperandoProxyLink.VALID;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }


        String info = "";
        try {
            InputStream is = getResources().openRawResource(R.raw.info_template);
            info = IOUtils.toString(is);
            IOUtils.closeQuietly(is);
        } catch (IOException e) {
            e.printStackTrace();
        }


        info = info.replace("@@status@@", proxyStatus.name());
        info = info.replace("@@link@@", proxyLink.name());
        webView.loadDataWithBaseURL("", info, "text/html", "UTF-8", "");
        webView.setBackgroundColor(Color.TRANSPARENT); //TRANSPARENT

    }

}
