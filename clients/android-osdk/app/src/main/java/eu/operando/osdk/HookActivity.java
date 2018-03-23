package eu.operando.osdk;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.BatteryManager;
import android.os.Bundle;
import android.provider.MediaStore;
import android.speech.RecognizerIntent;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

import aspectj.archinamon.alex.hookframework.xpoint.android.hooks.javaApi.HookEvent;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.BatteryInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.CameraIntentInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.LocationInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.MediaRecorderInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.OkHttpRequestInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.OnLocationChangedInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.SensorInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.interceptors.SpeechToTextInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.android.request.TestOkHttpClient;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework.HookHelper;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin.AbstractPlugin;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin.Plugin;

/**
 * Created by Alex on 3/20/2018.
 */

public class HookActivity extends AppCompatActivity implements LocationListener, SensorEventListener {

    private LocationManager locationManager;
    public static final int MY_PERMISSIONS_REQUEST_LOCATION = 99;
    private static final int UPDATE_THRESHOLD = 5000;
    private HookEvent hookEvent;

    private SensorManager sensorManager;
    private Sensor light;
    private Sensor gyroscope;
    private Sensor accelerometer;
    private Sensor proximity;

    private List<Sensor> sensorList;
    private ListView sensorListView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my);
        initGUI();

        initHooks();

        initLocation(LocationManager.NETWORK_PROVIDER);
        initSensors();
        initBattery();
        initRequest();

        StringBuilder sb = new StringBuilder();
        sb.append("Hello, world");
        ((TextView) findViewById(R.id.greeting)).setText(sb.toString());
    }

    private void initRequest() {

//        new OkHttpInterceptor().execute();
//        new RequestTest(MyActivity.this).run();
//        new TestUrlConnection().execute();
//        new TestHttpRequest().execute();
//        new TestSocketRequest().execute();

        try {
            new TestOkHttpClient().run();
        } catch (Exception e) {
            e.printStackTrace();
        }
//        new TestHttpClient().execute();

    }

    private void initHooks() {

        AbstractPlugin plugin = new Plugin(HookHelper.GET_LAST_KNOWN_LOCATION, new LocationInterceptor());
        plugin.add(HookHelper.ON_LOCATION_CHANGED, new OnLocationChangedInterceptor());

        new Plugin(HookHelper.BATTERY, new BatteryInterceptor());
        new Plugin(HookHelper.ON_SENSOR_CHANGED, new SensorInterceptor());
        new Plugin(HookHelper.START_MEDIA_RECORDER, new MediaRecorderInterceptor());
        new Plugin(HookHelper.INTENT_CONSTRUCTOR_CAMERA, new CameraIntentInterceptor());
        new Plugin(HookHelper.INTENT_CONSTRUCTOR_SPEECH_TO_TEXT, new SpeechToTextInterceptor());
        new Plugin(HookHelper.BUILD_OK_HTTP_REQUEST, new OkHttpRequestInterceptor());
        new Plugin(HookHelper.SOCKET_GET_INPUT_STREAM, new OkHttpRequestInterceptor());
    }

    private Button recordButton;
    private Button photoButton;
    private Button speechToTextButton;
    private TextView speechToTextTV;
    private static final int REQUEST_IMAGE_CAPTURE = 1;
    private static final int SPEECH_REQUEST_CODE = 0;

    private void initGUI() {
        recordButton = (Button) findViewById(R.id.record_btn);
        photoButton = (Button) findViewById(R.id.photo_btn);
        speechToTextButton = (Button) findViewById(R.id.speech_to_text_btn);
        speechToTextTV = (TextView) findViewById(R.id.speechto_text_result_tv);

        recordButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                Intent intent = new Intent(MyActivity.this, AudioRecordTest.class);
//                startActivity(intent);
            }
        });

        photoButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                if(takePictureIntent == null){
                    Log.w("takePictureIntent", "null");
                }
                if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
                    startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
                }
            }
        });
        speechToTextButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
                intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                        RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
                startActivityForResult(intent, SPEECH_REQUEST_CODE);
            }
        });
    }

    protected void onActivityResult(int requestCode, int resultCode,
                                    Intent data) {
        if (requestCode == SPEECH_REQUEST_CODE && resultCode == RESULT_OK) {
            List<String> results = data.getStringArrayListExtra(
                    RecognizerIntent.EXTRA_RESULTS);
            String spokenText = results.get(0);

            speechToTextTV.setText(spokenText);
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void initBattery() {
        IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = registerReceiver(null, intentFilter);

        int level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
        int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        float batteryPct = level / (float) scale * 100;

        Log.w("batteryStatus", " " + (int) batteryPct + "%");
    }

    private void initSensors() {
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        light = sensorManager
                .getDefaultSensor(Sensor.TYPE_LIGHT);
        gyroscope = sensorManager
                .getDefaultSensor(Sensor.TYPE_GYROSCOPE);
        accelerometer = sensorManager
                .getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        proximity = sensorManager
                .getDefaultSensor(Sensor.TYPE_PROXIMITY);

        sensorList = sensorManager.getSensorList(Sensor.TYPE_ALL);
//        sensorListView = (ListView) findViewById(R.id.list_view);
//        ArrayAdapter<Sensor> adapter = new SensorListViewAdapter(this, R.layout.sensor_item, sensorList);
//        sensorListView.setAdapter(adapter);
    }

    public void initLocation(String provider) {
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        if (checkLocationPermission()) {
            if (ContextCompat.checkSelfPermission(this,
                    Manifest.permission.ACCESS_FINE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED) {

                //Request location updates:
                locationManager.requestLocationUpdates(provider, 400, 1, this);

                if (locationManager.isProviderEnabled(provider)) {

                    Location location = locationManager.getLastKnownLocation(provider);
                    // Initialize the location fields
                    if (location != null) {
                        System.out.println("Provider " + provider + " has been selected.");
                        onLocationChanged(location);
                    } else {
                        Log.e("Provider", "Location not available");
                    }
                }
            }
        }
    }

    public boolean checkLocationPermission() {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {

            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                    Manifest.permission.ACCESS_FINE_LOCATION)) {

                // Show an explanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.
                new AlertDialog.Builder(this)
                        .setTitle(R.string.title_location_permission)
                        .setMessage(R.string.text_location_permission)
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                //Prompt the user once explanation has been shown
                                ActivityCompat.requestPermissions(HookActivity.this,
                                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                                        MY_PERMISSIONS_REQUEST_LOCATION);
                            }
                        })
                        .create()
                        .show();
            } else {
                // No explanation needed, we can request the permission.
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        MY_PERMISSIONS_REQUEST_LOCATION);
            }
            return false;
        } else {
            return true;
        }
    }

//    @Override
//    public void onRequestPermissionsResult(int requestCode,
//                                           String permissions[], int[] grantResults) {
//        switch (requestCode) {
//            case MY_PERMISSIONS_REQUEST_LOCATION: {
//                // If request is cancelled, the result arrays are empty.
//                if (grantResults.length > 0
//                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//
//                    // permission was granted, yay! Do the
//                    // location-related task you need to do.
//                    if (ContextCompat.checkSelfPermission(this,
//                            Manifest.permission.ACCESS_FINE_LOCATION)
//                            == PackageManager.PERMISSION_GRANTED) {
//
//                        //Request location updates:
//                        hookEvent.requestLocationUpdates(provider, 400, 1, this);
//                    }
//                } else {
//                    // permission denied, boo! Disable the
//                    // functionality that depends on this permission.
//                }
//                return;
//            }
//        }
//    }

    @Override
    public void onLocationChanged(Location location) {
        int lat = (int) (location.getLatitude());
        int lng = (int) (location.getLongitude());
        Log.e("onLocationChanged", "lat: " + String.valueOf(lat) + " long: " + String.valueOf(lng));
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {
        Toast.makeText(this, "Enabled new provider " + provider,
                Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onProviderDisabled(String provider) {
        Toast.makeText(this, "Disabled provider " + provider,
                Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
//        long actualTime = System.currentTimeMillis();
//        if (actualTime - mLastUpdate > UPDATE_THRESHOLD) {

//            mLastUpdate = actualTime;
        if (event.sensor.getType() == Sensor.TYPE_GYROSCOPE) {
            float x = event.values[0], y = event.values[1], z = event.values[2];
            Log.w("TYPE_GYROSCOPE", String.valueOf(x) + " " + String.valueOf(y) + " " + String.valueOf(z));
        }
        if (event.sensor.getType() == Sensor.TYPE_LIGHT) {
            float light_val = event.values[0];
            Log.w("TYPE_LIGHT", String.valueOf(light_val));
        }
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            float x = event.values[0], y = event.values[1], z = event.values[2];
            Log.w("TYPE_ACCELEROMETER", String.valueOf(x) + " " + String.valueOf(y) + " " + String.valueOf(z));
        }
        if (event.sensor.getType() == Sensor.TYPE_PROXIMITY) {
            float x = event.values[0];
            Log.w("TYPE_PROXIMITY", String.valueOf(x));
        }
//        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }

    private long mLastUpdate;

    @Override
    protected void onResume() {
        super.onResume();
//        if (checkLocationPermission()) {
//            if (ContextCompat.checkSelfPermission(this,
//                    Manifest.permission.ACCESS_FINE_LOCATION)
//                    == PackageManager.PERMISSION_GRANTED) {
//
//                //Request location updates:
//                locationManager.requestLocationUpdates(provider, 400, 1, this);
//            }
//        }
//        sensorManager.registerListener(this, light, SensorManager.SENSOR_DELAY_NORMAL);
//        sensorManager.registerListener(this, gyroscope, SensorManager.SENSOR_DELAY_NORMAL);
//        sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
//        sensorManager.registerListener(this, proximity, SensorManager.SENSOR_DELAY_NORMAL);

        mLastUpdate = System.currentTimeMillis();
    }

    @Override
    protected void onPause() {
        super.onPause();
//        locationManager.removeUpdates(this);
        sensorManager.unregisterListener(this);
    }
}
