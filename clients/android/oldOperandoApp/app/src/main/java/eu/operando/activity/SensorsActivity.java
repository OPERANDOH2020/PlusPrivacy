package eu.operando.activity;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import eu.operando.R;
import eu.operando.adapter.SensorsListAdapter;
import eu.operando.model.SensorModel;
import eu.operando.util.SensorUtils;


public class SensorsActivity extends BaseActivity {

    public static void start(Context context) {
        Intent starter = new Intent(context, SensorsActivity.class);
        context.startActivity(starter);
    }

    SensorManager sensorManager;
    List<Sensor> sensors;
    ListView lv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sensors);
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        lv = (ListView) findViewById(R.id.sensor_lv);
        sensors = sensorManager.getSensorList(Sensor.TYPE_ALL);
        final ArrayList<SensorModel> sensorModels = new ArrayList<>();
        for (Sensor sensor : sensors) {
            SensorModel sm = SensorUtils.getSensorModel(sensor);
//            SensorModel sm = new SensorModel(sensor.getName() + "\nType" + sensor.getStringType(), R.drawable.ic_sensor, "sensor");
            if (sm != null) {
                sensorModels.add(sm);
            }
        }
        SensorUtils.done();
        lv.setAdapter(new SensorsListAdapter(this, sensorModels));

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                FeaturesActivity.start(SensorsActivity.this, sensorModels.get(position));
            }
        });
    }
}
