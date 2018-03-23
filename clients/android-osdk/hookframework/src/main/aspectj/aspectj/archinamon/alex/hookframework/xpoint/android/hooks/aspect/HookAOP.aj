package com.archinamon.example2.android.hooks.aspect;

public aspect HookAOP {

//    private HashMap<String, HookEvent> hooks = new HashMap<>();
//
//    pointcut callStopPropagation(): call(public void com.uphyca.gradle.android.aspectj.hooks.javaApi.HookEvent.stopPropagation());
//    void around(): callStopPropagation() {
//
//        proceed();
//        hooks.clear();
//        Log.w("callStopPropagation", "size: " + hooks.size());
//    }
//
//    pointcut callNewHookEvent(String methodName): execution(public com.uphyca.gradle.android.aspectj.hooks.javaApi.HookEvent.new(String)) && args(methodName);
//    after(): callNewHookEvent(String) {
//
//        Object[] args = thisJoinPoint.getArgs();
//        Log.e("callNewHookEvent", "Constructor called");
//        HookEvent hookEvent = (HookEvent) thisJoinPoint.getThis();
//        hooks.put(args[args.length - 1].toString(), hookEvent);
//    }
//
////    pointcut callGetLastKnownLocation(String provider): call(public Object+ android.location.LocationManager.getLastKnownLocation(String)) && args(provider);
////    Object around(): callGetLastKnownLocation(String){
////
////        HookEvent hookEvent = hooks.get(thisJoinPoint.getSignature().getName());
////        if (hookEvent != null) {
////            hookEvent.beforeCall(thisJoinPoint.getArgs());
////            if (hooks.size() != 0) {
////
////                Log.w("HookAOP", thisJoinPoint.getKind() + " " + thisJoinPoint.getSignature().getName() + " " + thisJoinPoint.getTarget().getClass().toString());
////                if (hookEvent.shouldCall) {
////                    return (Location) hookEvent.afterCall(proceed());
////                }
////            }
////        }
////
////        return new Location(LocationManager.NETWORK_PROVIDER);
////    }
//
//    pointcut callOnLocationChanged(Location location):execution( public void android.location.LocationListener+.onLocationChanged(Location)) && args(location);
//    pointcut callOnSensorChanged(SensorEvent event):execution( public void android.hardware.SensorEventListener +.onSensorChanged(SensorEvent)) && args(event);
//    pointcut callStartMediaRecorder():call( public void android.media.MediaRecorder.start());
//    void around ():callOnSensorChanged(SensorEvent) || callOnLocationChanged(Location) || callStartMediaRecorder(){
//
//        HookEvent hookEvent = hooks.get(thisJoinPoint.getSignature().getName());
//        if (hookEvent != null) {
//            hookEvent.beforeCall(thisJoinPoint.getArgs());
//        }
//        if (hooks.size() != 0) {
//            if (hookEvent != null) {
//                if (hookEvent.shouldCall) {
//                    proceed();
//                }
//                hookEvent.afterCall(new Object());
//            } else {
//                proceed();
//            }
//        }
//    }
//
//    pointcut callOnBatteryChanged(String name, int defaultValue):call( public int android.content.Intent+.getIntExtra(String, int)) && args(name, defaultValue);
//    int around ():callOnBatteryChanged(String, int) {
//
//        String[] list = {BatteryManager.EXTRA_LEVEL, BatteryManager.EXTRA_SCALE,
//                BatteryManager.EXTRA_STATUS, BatteryManager.EXTRA_STATUS, BatteryManager.EXTRA_STATUS,
//                BatteryManager.EXTRA_PLUGGED, BatteryManager.EXTRA_TEMPERATURE, BatteryManager.ACTION_CHARGING,
//                BatteryManager.ACTION_DISCHARGING, BatteryManager.EXTRA_HEALTH, BatteryManager.EXTRA_PRESENT,
//                BatteryManager.EXTRA_TECHNOLOGY, BatteryManager.EXTRA_STATUS, BatteryManager.EXTRA_VOLTAGE};
//        List<String> batteryManagerConstants = Arrays.asList(list);
//
//        if (batteryManagerConstants.contains((String) thisJoinPoint.getArgs()[0])) {
//            Log.e("callOnBatteryChanged", "call");
//            HookEvent hookEvent = hooks.get(thisJoinPoint.getSignature().getName());
//            if (hookEvent != null) {
//                hookEvent.beforeCall(thisJoinPoint.getArgs());
//            }
//            if (hooks.size() != 0) {
//                if (hookEvent != null) {
//                    Log.e("callOnBatteryChanged", "on proceed call");
//                    if (hookEvent.shouldCall) {
//                        return proceed();
//                    }
//                    hookEvent.afterCall(new Object());
//                } else {
//                    return proceed();
//                }
//            }
//            return 0;
//        }
//        return proceed();
//    }
//
//    pointcut callNewIntent(String action): call(public android.content.Intent.new(String)) && args(action);
//    //    Object around(): callNewIntent(String) {
////
////        HookEvent hookEvent = hooks.get(thisJoinPoint.getSignature().getName());
////        if (hookEvent != null) {
////            hookEvent.beforeCall(thisJoinPoint.getArgs());
////        }
////        if (hooks.size() != 0) {
////            if (hookEvent != null) {
////                if (hookEvent.shouldCall) {
////                    return hookEvent.afterCall((Object) proceed());
////                }
////                return hookEvent.afterCall(new Object());
////            } else {
////                return new Intent();
////            }
////        }
////        return proceed();
////    }
//
//    Object around(): callNewIntent(String){
//
//        if (hooks.size() == 0) {
//            return proceed();
//        }
////        ((Location)thisJoinPoint.getThis()).setLatitude();
//        HookEvent hookEvent = hooks.get(thisJoinPoint.getSignature().getName());
//        if (hookEvent == null) {
//            return new Object();
//        }
//        hookEvent.beforeCall(thisJoinPoint.getArgs());
//        if (hookEvent.shouldCall) {
//            return hookEvent.afterCall((Object) proceed());
//        }
//        return hookEvent.afterCall(new Object());
//    }
}