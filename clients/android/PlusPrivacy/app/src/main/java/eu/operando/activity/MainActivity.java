package eu.operando.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Pair;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

import eu.operando.R;
import eu.operando.adapter.DrawerRecyclerViewAdapter;
import eu.operando.feedback.view.FeedbackActivity;
import eu.operando.lightning.activity.MainBrowserActivity;
import eu.operando.models.InstalledApp;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.GetNotificationsSwarmEntity;
import eu.operando.swarmService.models.LoginSwarmEntity;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.SwarmCallback;
import eu.operando.utils.PermissionUtils;

public class MainActivity extends AppCompatActivity implements DrawerRecyclerViewAdapter.IDrawerClickCallback {

    private AlertDialog disconnectDialog;
    private ProgressDialog loadingDialog;

    private DrawerLayout drawerLayout;
    private ActionBarDrawerToggle drawerToggle;
    private RecyclerView drawerList;
    private Toolbar toolbar;

    public static void start(Context context, boolean autologin) {
        Intent starter = new Intent(context, MainActivity.class);
        starter.putExtra("autologin", autologin);
        context.startActivity(starter);
    }

    @Override
    protected void onResume() {
        super.onResume();
        initNotifications();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setMenu();
        setStatusBarColor();
//        autoLogin();
        initUI();

        SwarmClient.getInstance().setConnectionListener(new SwarmClient.ConnectionListener() {
            @Override
            public void onConnect() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        if (disconnectDialog != null)
                            disconnectDialog.dismiss();
                    }
                });
            }

            @Override
            public void onDisconnect() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (!isFinishing()) {
                            disconnectDialog =
                                    new AlertDialog.Builder(MainActivity.this)
                                            .setMessage("Connection lost, trying to reconnect...")
                                            .setNegativeButton("Exit PlusPrivacy", new DialogInterface.OnClickListener() {
                                                @Override
                                                public void onClick(DialogInterface dialogInterface, int i) {
                                                    finish();
                                                }
                                            }).setCancelable(false)
                                            .create();
                            disconnectDialog.show();
                        }
                    }
                });
            }
        });
    }

    private void autoLogin() {
        if (getIntent().getBooleanExtra("autologin", false)) {
            Pair<String, String> credentials = Storage.readCredentials();
            if (credentials.first != null && credentials.second != null) {
                swarmLogin(credentials.first, credentials.second);
                return;
            }
        } else {
            initUI();
        }
    }

    private void setStatusBarColor() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(ContextCompat.getColor(this, R.color.black));
        }
    }

    private void swarmLogin(final String username, final String password) {

        loadingDialog = new ProgressDialog(this);
        loadingDialog.setCancelable(false);
        loadingDialog.setMessage("Please wait...");
        loadingDialog.show();

        SwarmService.getInstance().login(username, password, new SwarmCallback<LoginSwarmEntity>() {
            @Override
            public void call(final LoginSwarmEntity result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        loadingDialog.dismiss();
                        if (!result.isAuthenticated()) {
                            Storage.clearData();
                            finish();
                        } else {
                            Storage.saveUserID(result.getUserId());
                            initUI();
                        }
                    }
                });
            }
        });
    }

    private void initUI() {

        setInfo();
        View.OnClickListener scanListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ScannerActivity.start(MainActivity.this);
            }
        };
        View.OnClickListener identitiesListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                IdentitiesActivity.start(MainActivity.this);
            }
        };
        findViewById(R.id.apps_rl).setOnClickListener(scanListener);
        findViewById(R.id.real_identity_rl).setOnClickListener(identitiesListener);

        findViewById(R.id.notifications_rl).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NotificationsActivity.start(MainActivity.this);
            }
        });
        findViewById(R.id.btn_pfb).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PFBActivity.start(MainActivity.this);
            }
        });
        findViewById(R.id.btn_browser).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, MainBrowserActivity.class));
            }
        });

        findViewById(R.id.btn_osp).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, SocialNetworkPrivacySettingsActivity.class));
            }
        });
    }

    private void setMenu() {

        setToolbar();
        setRecyclerViewDrawerList();

        drawerToggle = new ActionBarDrawerToggle(this, drawerLayout, toolbar, R.string.open, R.string.close);
        drawerToggle.setDrawerIndicatorEnabled(true);
        drawerLayout.addDrawerListener(drawerToggle);

        drawerToggle.setToolbarNavigationClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (drawerLayout.isDrawerVisible(GravityCompat.START)) {
                    drawerLayout.closeDrawer(GravityCompat.START);
                } else {
                    drawerLayout.openDrawer(GravityCompat.START);
                }
            }
        });

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        findViewById(R.id.logout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                logOut();
            }
        });
    }

    private void setToolbar() {
        toolbar = (Toolbar) findViewById(R.id.activity_main_screen_toolbar);

        if (toolbar != null) {
            setSupportActionBar(toolbar);
            getSupportActionBar().show();

            toolbar.setNavigationOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
                    if (drawer != null) {
                        drawer.openDrawer(GravityCompat.START);
                    }
                }
            });
        }
    }

    private void setRecyclerViewDrawerList() {

        drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawerList = (RecyclerView) findViewById(R.id.drawer_rv);

        DrawerRecyclerViewAdapter recyclerViewAdapter = new DrawerRecyclerViewAdapter(this);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);

        drawerList.setLayoutManager(linearLayoutManager);
        drawerList.setAdapter(recyclerViewAdapter);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        drawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        drawerToggle.onConfigurationChanged(newConfig);
    }

    private void setInfo() {
        ((TextView) findViewById(R.id.real_identity)).setText(Storage.readUserID());
        showUnsafeApps();
//        initNotifications();
    }

    private void initNotifications() {
        SwarmService.getInstance().getNotifications(
                new SwarmCallback<GetNotificationsSwarmEntity>() {
                    @Override
                    public void call(final GetNotificationsSwarmEntity result) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                String text = "You have " + result.getNotifications().size() + " notifications";
                                ((TextView) findViewById(R.id.tv_notifications)).setText(text);
                            }
                        });
                    }
                });
    }

    private void showUnsafeApps() {
        List<InstalledApp> installedApps = PermissionUtils.getApps(this, false);
        if (installedApps != null) {
            ((TextView) findViewById(R.id.tv_installed_apps)).setText(getString(R.string.installed_apps) + " " + installedApps.size());
            int unsafe = 0;
            for (InstalledApp app : installedApps)
                if (app.getPollutionScore() > PermissionUtils.SAFE_THRESHOLD) unsafe++;
            ((TextView) findViewById(R.id.unsafe_apps)).setText(getString(R.string.potentially_unsafe_apps) + " " + unsafe);
            if (unsafe == 0)
                ((TextView) findViewById(R.id.unsafe_apps)).setTextColor(getResources().getColor(android.R.color.holo_green_light));

        }
        Storage.saveAppList(installedApps);
    }

    private void startFeedbackActivity() {
        startActivity(new Intent(MainActivity.this, FeedbackActivity.class));
    }

    private void logOut() {
        Toast.makeText(this, "Log Out", Toast.LENGTH_SHORT).show();
//        SwarmService.getInstance().logout(null);
        Storage.clearData();
        LoginActivity.start(MainActivity.this);
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        SwarmService.getInstance().logout(null);
    }

    @Override
    public void selectItem(int position) {

        switch (position) {

            case 0: //About
//                HtmlActivity.start(this, "file:///android_asset/about.html", "About PlusPrivacy");
                startActivity(new Intent(MainActivity.this, AboutActivity.class));
                break;
            case 1: //Privacy Policy
                HtmlActivity.start(this, "file:///android_asset/privacy_policy.html", "Privacy Policy");
                break;
//            case 2: //Settings
//                SettingsActivity.start(this);
//                break;
            case 2: //Feedback
                startFeedbackActivity();
                break;
            case 3: //Account
                UserAccountActivity.start(this);
                break;
        }
        drawerLayout.closeDrawer(Gravity.START);
    }

}