package eu.operando.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Pair;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.special.ResideMenu.ResideMenu;
import com.special.ResideMenu.ResideMenuItem;

import java.util.List;

import eu.operando.R;
import eu.operando.lightning.activity.MainBrowserActivity;
import eu.operando.models.InstalledApp;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.GetNotificationsSwarm;
import eu.operando.swarmService.models.LoginSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import eu.operando.utils.PermissionUtils;
import io.paperdb.Paper;

public class MainActivity extends AppCompatActivity {

    public static void start(Context context, boolean autologin) {
        Intent starter = new Intent(context, MainActivity.class);
        starter.putExtra("autologin", autologin);
        context.startActivity(starter);
    }

    private ResideMenu resideMenu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        autoLogin();
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

    private void swarmLogin(final String username, final String password) {

        SwarmService.getInstance().login(username, password, new SwarmCallback<LoginSwarm>() {
            @Override
            public void call(final LoginSwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                if (!result.isAuthenticated()) {
                                    Storage.clearData();
                                    finish();
                                } else {
                                    Storage.saveUserID(result.getUserId());
                                    initUI();
                                }
                            }
                        }, 1);
                    }
                });

            }
        });
    }

    private void initUI() {
        initMenu();
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
        findViewById(R.id.btn_identities).setOnClickListener(identitiesListener);
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
//                KotlinBrowserActivityKt.start(MainBrowserActivity.this);
                startActivity(new Intent(MainActivity.this, MainBrowserActivity.class));
            }
        });
    }

    private void setInfo() {
        ((TextView) findViewById(R.id.real_identity)).setText(Storage.readUserID());
        showUnsafeApps();
        initNotifications();
    }

    @Override
    protected void onResume() {
        super.onResume();
        initNotifications();
    }

    private void initNotifications() {
        SwarmClient.getInstance().startSwarm(new GetNotificationsSwarm(),
                new SwarmCallback<GetNotificationsSwarm>() {
                    @Override
                    public void call(final GetNotificationsSwarm result) {
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

    private void initMenu() {
        resideMenu = new ResideMenu(this);
        resideMenu.setBackground(R.drawable.bg);
        resideMenu.attachToActivity(this);
        resideMenu.setScaleValue(0.9f);
        resideMenu.setUse3D(true);

        View.OnClickListener menuClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int index = (int) v.getTag();
                onDrawerItemClicked(index);
            }
        };


        String[] titles = new String[]{"Settings", "About", "Trusted apps"};
        int[] icons = new int[]{R.drawable.ic_settings,
                R.drawable.ic_action_about,
                R.drawable.ic_trusted};

        for (int i = 0; i < titles.length; i++) {
            ResideMenuItem item = new ResideMenuItem(this, icons[i], titles[i]);
            item.setOnClickListener(menuClickListener);
            item.setTag(i);
            resideMenu.addMenuItem(item, ResideMenu.DIRECTION_LEFT);
        }

        findViewById(R.id.ic_menu).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
            }
        });

        findViewById(R.id.ic_profile).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_RIGHT);
            }
        });

        ResideMenuItem logoutItem = new ResideMenuItem(this, 0, "Log Out");
        logoutItem.setTag(titles.length);
        logoutItem.setOnClickListener(menuClickListener);
        resideMenu.addMenuItem(logoutItem, ResideMenu.DIRECTION_RIGHT);

    }

    private void onDrawerItemClicked(int index) {
//        Toast.makeText(this, index + "", Toast.LENGTH_SHORT).show();
        switch (index) {
            case 0: //Settings
                SettingsActivity.start(this);
                break;
            case 1: //About
                AboutActivity.start(this);
                break;
            case 2: //Trusted Apps
                Toast.makeText(this, "Coming Soon", Toast.LENGTH_SHORT).show();
//                TrustedAppsActivity.start(this);
                break;
            case 3: //LogOut
                logOut();
                break;
        }
    }

    private void logOut() {
        Toast.makeText(this, "Log Out", Toast.LENGTH_SHORT).show();
        SwarmService.getInstance().logout(null);
        Storage.clearData();
        LoginActivity.start(MainActivity.this);
        finish();
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        return resideMenu.dispatchTouchEvent(ev);
    }
}
