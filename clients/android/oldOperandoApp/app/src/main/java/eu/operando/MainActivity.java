package eu.operando;


import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import org.greenrobot.eventbus.Subscribe;
import org.json.JSONException;

import java.util.Arrays;
import java.util.List;

import eu.operando.activity.AbstractLeftMenuActivity;
import eu.operando.activity.BaseActivity;
import eu.operando.events.EventLoginPage;
import eu.operando.events.EventScanPage;
import eu.operando.events.EventSignIn;
import eu.operando.fragment.AuthenticatedFragment;
import eu.operando.fragment.CreateAccountFragment;
import eu.operando.fragment.FirstScreenFragment;
import eu.operando.fragment.LoginFragment;
import eu.operando.fragment.ScannerFragment;
import eu.operando.osdk.swarm.client.events.SwarmLogoutEvent;
import eu.operando.osdk.swarm.client.utils.EventProvider;
import eu.operando.osdk.swarm.client.utils.SwarmConstants;
import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;
import eu.operando.util.Constants;

import eu.operando.osdk.swarm.client.SwarmClient;

@SuppressWarnings("ALL")
public class MainActivity extends AbstractLeftMenuActivity {


    public FrameLayout mContainer;
    public RelativeLayout aboutRL;
    public DrawerLayout mDrawerLayout;
    private SwarmClient swarmClient;

    FirstScreenFragment firstScreenFragment;
    AuthenticatedFragment authenticatedFragment;
    LoginFragment loginFragment;
    CreateAccountFragment createAccountFragment;
    ActionBarDrawerToggle drawerToggle;

    private String mActivityTitle;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        initUI();
        doOnInit();
    }


    private void initUI() {

        firstScreenFragment = new FirstScreenFragment();

        loginFragment = new LoginFragment();
        createAccountFragment = new CreateAccountFragment();
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerLayout.setScrimColor(Color.TRANSPARENT);
        mDrawerLayout.setElevation(0f);
        addFragment(R.id.main_fragment_container, firstScreenFragment, FirstScreenFragment.FRAGMENT_TAG);
        aboutRL = (RelativeLayout) findViewById(R.id.aboutRL);

        final View frame = findViewById(R.id.container);
        final View drawer = findViewById(R.id.fragment_drawer);
        drawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.string.app_name, R.string.app_name) {

            /**
             * Called when a drawer has settled in a completely open state.
             */
            public void onDrawerOpened(View drawerView) {
            }

            /**
             * Called when a drawer has settled in a completely closed state.
             */
            public void onDrawerClosed(View view) {
            }

            public void onDrawerSlide(View drawerView, float slideOffset) {
                float min = 0.5f;
                float max = 1.0f;
                float scaleFactor = (max - ((max - min) * slideOffset));

                frame.setScaleX(scaleFactor);
                frame.setScaleY(scaleFactor);
                frame.setTranslationX(400 * slideOffset);
                drawer.setAlpha(slideOffset/1.6f);
                if(slideOffset == 1)
                    drawer.setAlpha(1);
            }
        };


        this.mDrawerLayout.setDrawerListener(drawerToggle);
        setComponents(drawerToggle, mDrawerLayout);

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();

        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void doOnInit() {
        EventProvider eventProvider = EventProvider.getInstance();
        swarmClient = SwarmClient.getInstance(SwarmConstants.SWARMS_URL_DEBUG, "chromeBrowserExtension");
        //login
        /*String[] commandArguments = {"rafa", "swarm"};
        swarmClient.startSwarm("login.js", "start", "userLogin", commandArguments);*/

    }

    @Subscribe
    public void onEvent(EventLoginPage event) {

        switch (event.action) {
            case Constants.events.LOGIN: {
                showLoginPage();
                break;
            }
            case Constants.events.CREATE_ACCOUNT: {
                showRegisterPage();
                break;
            }
        }
    }

    @Subscribe
    public void onEvent(EventSignIn event) {

        //showFirstFragment();
    }

    @Subscribe
    public void onEvent(EventScanPage event) {
        showScanPage();
    }


    @Subscribe
    public void onSwarmEvent(SwarmLoginEvent loginEvent) {
        showFirstFragment();
        System.out.println("TODO with login event");
        String sessionId = "";
        try {
            sessionId = loginEvent.getData().getJSONObject("meta").getString("sessionId");
            System.out.println(loginEvent.getData().get("sessionId"));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        //Userinfo - email pe userId
//        swarmClient.startSwarm("UserInfo.js","start","info");
        //Identities list

    }

    @Subscribe
    public void onSwarmEvent(SwarmLogoutEvent logoutEvent) {
        //doOnInit();
    }

    public DrawerLayout getmDrawerLayout() {
        return mDrawerLayout;
    }

    private void showScanPage() {
        replaceFragment(
                R.id.main_fragment_container,
                new ScannerFragment(),
                "",
                null
        );
        mDrawerLayout.closeDrawers();
    }

    private void showLoginPage() {
        replaceFragment(R.id.main_fragment_container, loginFragment, LoginFragment.FRAGMENT_TAG, "st1");
    }

    private void showRegisterPage() {
        replaceFragment(R.id.main_fragment_container, createAccountFragment, CreateAccountFragment.FRAGMENT_TAG, "st2");
    }

    private void showFirstFragment() {
        replaceFragment(R.id.main_fragment_container, firstScreenFragment, FirstScreenFragment.FRAGMENT_TAG, "st3");
    }

    private void showDashboardFragment() {
        authenticatedFragment = new AuthenticatedFragment();
        replaceFragment(R.id.main_fragment_container, authenticatedFragment, AuthenticatedFragment.FRAGMENT_TAG, null);
    }
}
