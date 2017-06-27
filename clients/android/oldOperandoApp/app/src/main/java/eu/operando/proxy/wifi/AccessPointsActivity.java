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

package eu.operando.proxy.wifi;

import android.os.Bundle;
import android.support.v4.app.NavUtils;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.ExpandableListView;

import com.squareup.otto.Subscribe;

import eu.operando.R;
import eu.operando.proxy.MainContext;
import eu.operando.proxy.OperandoStatusEvent;


/**
 * Created by nikos on 5/4/16.
 */
public class AccessPointsActivity extends AppCompatActivity {
    private SwipeRefreshLayout swipeRefreshLayout;
    private MainContext mainContext = MainContext.INSTANCE;
    private AccessPointsAdapter accessPointsAdapter = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        setTheme(MainContext.INSTANCE.getSettings().getThemeStyle().themeAppCompatStyle());

        super.onCreate(savedInstanceState);

        setContentView(R.layout.access_points_content);


        swipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.accessPointsRefresh);
        swipeRefreshLayout.setOnRefreshListener(new ListViewOnRefreshListener());

        ExpandableListView expandableListView = (ExpandableListView) findViewById(R.id.accessPointsView);

        accessPointsAdapter = new AccessPointsAdapter(this);
        expandableListView.setAdapter(accessPointsAdapter);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setOnClickListener(new WiFiBandToggle());
        setSupportActionBar(toolbar);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            setTitle(R.string.action_access_points);
            updateSubTitle();

            Bundle extras = getIntent().getExtras();
            Boolean fromNotification = (getIntent().getExtras() != null) ? extras.getBoolean("fromNotification", false) : false;
            actionBar.setHomeButtonEnabled(!fromNotification);
            actionBar.setDisplayHomeAsUpEnabled(!fromNotification);
        }

    }

    private void updateSubTitle() {
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setSubtitle(mainContext.getSettings().getWiFiBand().getBand());
        }
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            NavUtils.navigateUpFromSameTask(this);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private class WiFiBandToggle implements View.OnClickListener {
        @Override
        public void onClick(View view) {
            mainContext.getSettings().toggleWiFiBand();
            updateSubTitle();
        }
    }

    private void refresh() {
        swipeRefreshLayout.setRefreshing(true);
        MainContext.INSTANCE.getScanner().update();
        swipeRefreshLayout.setRefreshing(false);
        accessPointsAdapter.notifyDataSetChanged();
    }

    @Override
    protected void onPause() {
        super.onPause();
        mainContext.getScanner().pause();
        mainContext.getBUS().unregister(this);

    }


    @Override
    public void onResume() {
        super.onResume();
        mainContext.getScanner().resume();
        mainContext.getBUS().register(this);
        refresh();
    }

    private class ListViewOnRefreshListener implements SwipeRefreshLayout.OnRefreshListener {
        @Override
        public void onRefresh() {
            refresh();
        }
    }

    @Subscribe
    public void onOperandoStatusEvent(OperandoStatusEvent event) {
        if (event.eventType == OperandoStatusEvent.EventType.ConnectionState) {
            refresh();
        }
    }


//    @Override
//    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
//        if (shouldReload()) {
//            reloadActivity();
//        } else {
//            mainContext.getScanner().update();
//        }
//    }
//
//    protected boolean shouldReload() {
//        Settings settings = mainContext.getSettings();
//        ThemeStyle settingThemeStyle = settings.getThemeStyle();
//        boolean result = !mainContext.getCurrentThemeStyle().equals(settingThemeStyle);
//        return result;
//    }
//
//    private void reloadActivity() {
//        finish();
//        Intent intent = new Intent(this, AccessPointsActivity.class);
//        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP |
//                Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
//        startActivity(intent);
//    }


}
