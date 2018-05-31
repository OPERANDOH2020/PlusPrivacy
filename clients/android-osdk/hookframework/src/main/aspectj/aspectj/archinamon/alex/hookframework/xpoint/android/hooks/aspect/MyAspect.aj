package com.archinamon.example2.android.hooks.aspect;

public aspect MyAspect {

    private static final int UPDATE_THRESHOLD = 5000;
    private long mLastUpdate = System.currentTimeMillis();

    pointcut callGreet(): call(public String java.lang.StringBuilder.toString());

    String around(): callGreet() {
        String result = proceed();
        return result.replace("world", "aspect");
    }

//    pointcut callFindViewById(int id): call(public View android.app.Activity.findViewById(int)) && args(id);
//
//    View around(): callFindViewById(int) {
//        Signature signature = thisJoinPoint.getStaticPart().getSignature();
//        Log.e("callFindViewById", "call");
//
//        Object[] signatureArgs = thisJoinPoint.getArgs();
//        for (Object signatureArg : signatureArgs) {
//            Log.e("callFindViewById", "Arg: " + signatureArg);
//        }
//
//        if (signature instanceof MethodSignature) {
//            final MethodSignature ms = (MethodSignature) signature;
//
//            final Class<?>[] parameterTypes = ms.getParameterTypes();
//            for (final Class<?> pt : parameterTypes) {
//                Log.e("callFindViewById", "Parameter methodName:" + pt);
//            }
//        }
//
//        View result = proceed();
//        return result;
//    }


//    pointcut callGetLastKnownLocation(String provider): call(public Location android.location.LocationManager.getLastKnownLocation(String)) && args(provider);
//
//    Location around(): callGetLastKnownLocation(String) {
//        Log.e("callGetLastKnownLocation", "call");
//        Signature signature = thisJoinPoint.getStaticPart().getSignature();
//        Object[] signatureArgs = thisJoinPoint.getArgs();
//
//        for (Object signatureArg : signatureArgs) {
//            Log.e("callGetLastKnownLocation", "Arg: " + signatureArg);
//        }
//
//        if (signature instanceof MethodSignature) {
//            final MethodSignature ms = (MethodSignature) signature;
//
//            final Class<?>[] parameterTypes = ms.getParameterTypes();
//            for (final Class<?> pt : parameterTypes) {
//                Log.e("callGetLastKnownLocation", "Parameter methodName:" + pt);
//            }
//        }
//
//        Location result = proceed();
//        result.setLatitude(35.66);
//        result.setLongitude(55.66);
//        Log.e("callGetLastKnownLocation", "Lat: " + result.getLatitude() + " Long: " + result.getLongitude());
//        return result;
//    }


//    pointcut callOnSensorChanged(SensorEvent event): execution(public void android.hardware.SensorEventListener+.onSensorChanged(SensorEvent)) && args(event);
//
//    void around(): callOnSensorChanged(SensorEvent) {
//
////        long actualTime = System.currentTimeMillis();
////        if (actualTime - mLastUpdate > UPDATE_THRESHOLD) {
//            Signature signature = thisJoinPoint.getStaticPart().getSignature();
//            Log.e("callOnSensorChanged", "call");
//
//            Object[] signatureArgs = thisJoinPoint.getArgs();
//
//            for (Object signatureArg : signatureArgs) {
//                Log.e("callOnSensorChanged", "Arg: " + ((SensorEvent) signatureArg).values[0]);
//                Log.e("callOnSensorChanged", "Sensor Type: " + ((SensorEvent) signatureArg).sensor.getStringType());
//            }
//            ((SensorEvent) signatureArgs[0]).sensor.getType();
//
//            if (signature instanceof MethodSignature) {
//                final MethodSignature ms = (MethodSignature) signature;
//
//                final Class<?>[] parameterTypes = ms.getParameterTypes();
//                for (final Class<?> pt : parameterTypes) {
//                    Log.e("callOnSensorChanged", "Parameter methodName:" + pt);
//                }
//            }
//
//            proceed();
////            mLastUpdate = actualTime;
////        }
//    }
}
