package eu.operando.util;

import java.util.ArrayList;
import java.util.HashMap;

import eu.operando.R;
import eu.operando.model.SensorModel;

/**
 * Created by Edy on 6/24/2016.
 */
public class SensorUtils {
    public static final HashMap<String, Integer> SENSOR_ICONS;
    private static ArrayList<String> alreadyAddedSensors;

    static {
        alreadyAddedSensors = new ArrayList<>();
        SENSOR_ICONS = new HashMap<>();
        SENSOR_ICONS.put("accelerometer", R.drawable.ic_accelerometer);
        SENSOR_ICONS.put("gravity", R.drawable.ic_gravity);
        SENSOR_ICONS.put("gyroscope", R.drawable.ic_gyro);
        SENSOR_ICONS.put("light", R.drawable.ic_light);
        SENSOR_ICONS.put("magnetic", R.drawable.ic_magnetometer);
        SENSOR_ICONS.put("orientation", R.drawable.ic_orientation);
        SENSOR_ICONS.put("pressure", R.drawable.ic_pressure);
        SENSOR_ICONS.put("proximity", R.drawable.ic_prox);
        SENSOR_ICONS.put("step", R.drawable.ic_step);
        SENSOR_ICONS.put("temperature", R.drawable.ic_temp);
    }

    public static SensorModel getSensorModel(android.hardware.Sensor sensor) {
        for (String name : SENSOR_ICONS.keySet()) {
            if (sensor.getStringType().contains(name)) {
                if (!alreadyAddedSensors.contains(name)) {
                    alreadyAddedSensors.add(name);
                    if(name.equals("magnetic")){
                        return new SensorModel(sensor.getName(),SENSOR_ICONS.get(name),"compass");
                    }
                    return new SensorModel(sensor.getName(), SENSOR_ICONS.get(name),name);
                } else {
                    return null;
                }
            }
        }
        return new SensorModel(sensor.getName(), R.drawable.ic_sensor,"undefined");
    }

    public static void done(){
        alreadyAddedSensors.clear();
    }
}
