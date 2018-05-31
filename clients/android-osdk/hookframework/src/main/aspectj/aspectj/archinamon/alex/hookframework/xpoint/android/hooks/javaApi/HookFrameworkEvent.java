package aspectj.archinamon.alex.hookframework.xpoint.android.hooks.javaApi;

import android.location.Location;
import android.util.Log;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework.HookHelper;


public class HookFrameworkEvent {

    private static HookEvent hookEvent;

    private HookFrameworkEvent(){}

    public static HookEvent getInstance(){
//        initHooks();
        return hookEvent;
    }

    static {
        initHooks();
    }

    private static void initHooks() {

        hookEvent = new HookEvent(HookHelper.GET_LAST_KNOWN_LOCATION) {
            @Override
            public void beforeCall(Object[] args) {
//                stopPropagation();
                Log.w("hookEvent", "beforeCall");
                for (Object signatureArg : args) {
                    Log.e("callGetLastKnownLocat", "Arg: " + signatureArg + " " + signatureArg.getClass().toString());
                }
            }

            @Override
            public Object afterCall(Object result) {

                Location loc = (Location) result;
                Log.w("hookEvent", "afterCall");
                if (result != null) {
                    Log.e("callGetLastKnownLocat", "Lat:" + loc.getLatitude() + " Long:" + loc.getLongitude());
                    loc.setLatitude(35.66);
                    loc.setLongitude(55.66);
                    Log.e("callGetLastKnownLocat", "Lat:" + loc.getLatitude() + " Long:" + loc.getLongitude());
                }
                return result;
            }
        };


        hookEvent.add(new HookEvent(HookHelper.ON_LOCATION_CHANGED) {
            @Override
            public void beforeCall(Object[] args) {
                Log.w("onLocationChangedHook", "beforeCall");
            }

            @Override
            public Object afterCall(Object obj) {
                Log.w("onLocationChangedHook", "afterCall");
                return null;
            }
        });


        hookEvent.add(new HookEvent(HookHelper.ON_SENSOR_CHANGED) {
            @Override
            public void beforeCall(Object[] args) {
//                stopPropagation();
//                shouldCall = false;
                Log.w("onSensorChangedHook", "beforeCall");
            }

            @Override
            public Object afterCall(Object obj) {
                Log.w("onSensorChangedHook", "afterCall");
                return null;
            }
        });


        hookEvent.add(new HookEvent(HookHelper.START_MEDIA_RECORDER) {
            @Override
            public void beforeCall(Object[] args) {
                Log.w("hookStartMediaRecorder", "beforeCall");
            }

            @Override
            public Object afterCall(Object obj) {
                Log.w("hookStartMediaRecorder", "afterCall");
                return null;
            }
        });


        hookEvent.add(new HookEvent(HookHelper.INTENT_CONSTRUCTOR_CAMERA) {
            @Override
            public void beforeCall(Object[] args) {

            }

            @Override
            public Object afterCall(Object obj) {
//                return new Intent();
                return obj;
            }
        });


        hookEvent.add(new HookEvent(HookHelper.BATTERY) {
            @Override
            public void beforeCall(Object[] args) {
                Log.w("hookBattery", "beforeCall");
            }

            @Override
            public Object afterCall(Object obj) {
                Log.w("hookBattery", "afterCall");
                return obj;
            }
        });
    }
}
