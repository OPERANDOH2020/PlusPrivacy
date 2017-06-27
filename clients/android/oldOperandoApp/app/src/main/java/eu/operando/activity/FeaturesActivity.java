package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.content.pm.FeatureInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.model.InstalledApp;
import eu.operando.model.SensorModel;
import eu.operando.util.PermissionUtils;

/**
 * Created by Edy on 6/27/2016.
 */
public class FeaturesActivity extends BaseActivity {
    public static void start(Context context, SensorModel sensorModel) {
        Intent starter = new Intent(context, FeaturesActivity.class);
        starter.putExtra("sensor", sensorModel);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ArrayList<InstalledApp> apps = null;
        try {
            apps = PermissionUtils.getApps(this,true);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        setContentView(R.layout.activity_notifications);
        ListView listView = (ListView) findViewById(R.id.lv);


        SensorModel sensorModel = ((SensorModel) getIntent().getSerializableExtra("sensor"));
        getSupportActionBar().setTitle("Apps using "+sensorModel.getType());
        ArrayList<InstalledApp> sensorApps = new ArrayList<>();
        for (InstalledApp app : apps) {
            if (app.getFeatures() != null) {
                for (FeatureInfo info : app.getFeatures()) {
                    if (info.name != null && info.name.contains(sensorModel.getType())) {
                        sensorApps.add(app);
                    }
                }
            }
        }
        if (listView != null) {
            listView.setAdapter(new ScannerListAdapter(this, sensorApps, null));
        }
    }
}
