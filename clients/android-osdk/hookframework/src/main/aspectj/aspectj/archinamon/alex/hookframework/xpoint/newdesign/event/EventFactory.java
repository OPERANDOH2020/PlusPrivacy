package aspectj.archinamon.alex.hookframework.xpoint.newdesign.event;

import android.util.Log;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import aspectj.archinamon.alex.hookframework.xpoint.android.events.IntegerEvent;
import aspectj.archinamon.alex.hookframework.xpoint.android.events.LocationEvent;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework.HookHelper;

/**
 * Created by Matei_Alexandru on 02.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class EventFactory {

    private HashMap<String, EventSignature> hashMap;
    private static EventFactory instance;

    private EventFactory() {
        hashMap = new HashMap<>();
        hashMap.put(HookHelper.GET_LAST_KNOWN_LOCATION, new EventSignature(LocationEvent.class));
        hashMap.put(HookHelper.ON_LOCATION_CHANGED, new EventSignature(LocationEvent.class));
        hashMap.put(HookHelper.ON_SENSOR_CHANGED, new EventSignature(CommonEvent.class));
        hashMap.put(HookHelper.START_MEDIA_RECORDER, new EventSignature(CommonEvent.class));
        hashMap.put(HookHelper.INTENT_CONSTRUCTOR_CAMERA, new EventSignature(CommonEvent.class, true));
        hashMap.put(HookHelper.INTENT_CONSTRUCTOR, new EventSignature(CommonEvent.class, true));
        hashMap.put(HookHelper.INTENT_CONSTRUCTOR_SPEECH_TO_TEXT,
                new EventSignature(CommonEvent.class));
        hashMap.put(HookHelper.BATTERY, new EventSignature(IntegerEvent.class));
        hashMap.put(HookHelper.BUILD_OK_HTTP_REQUEST, new EventSignature(CommonEvent.class));
        hashMap.put(HookHelper.SOCKET_GET_INPUT_STREAM, new EventSignature(CommonEvent.class));
    }

    public void addEventType(String ct, Class clazz) {
        hashMap.put(ct, new EventSignature(clazz, true));
    }

    public static EventFactory getInstance() {
        if (instance == null) {
            return new EventFactory();
        }
        return instance;
    }

    public AbstractEvent getEvent(String clazz, String methodName, Object[] args) {
//        switch (methodName) {
//            case HookHelper.GET_LAST_KNOWN_LOCATION:
//                return new LocationEvent(methodName);
//            case HookHelper.ON_LOCATION_CHANGED:
//                return new LocationEvent(methodName);
//            case HookHelper.BATTERY:
//                return new IntegerEvent(methodName);
//            case HookHelper.ON_SENSOR_CHANGED:
//                return new CommonEvent(methodName);
//            case HookHelper.BUILD_OK_HTTP_REQUEST:
//                return new CommonEvent(methodName);
//            case HookHelper.INTENT_CONSTRUCTOR:
//                return new CommonEvent(methodName + args[0]);
//            default:
//                return new CommonEvent(methodName);
//        }
        try {
            Log.e("getAbstractEvent", methodName + args[0].toString());
            EventSignature eventSignature = hashMap.get(methodName);
            AbstractEvent event = (AbstractEvent) eventSignature.getClazz()
                    .getDeclaredConstructor(String.class).newInstance(
                            eventSignature.getStringEvent(methodName, args[0]));
            Log.e("Event", event.getMethodName());
            return (AbstractEvent) event;
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        return new CommonEvent(methodName);
    }

    private class EventSignature {
        private Class clazz;
        private boolean args;

        public EventSignature(Class clazz, boolean args) {
            this.clazz = clazz;
            this.args = args;
        }

        public EventSignature(Class clazz) {
            this.clazz = clazz;
            this.args = false;
        }

        public Class getClazz() {
            return clazz;
        }

        public void setClazz(Class clazz) {
            this.clazz = clazz;
        }

        public boolean getArgs() {
            return args;
        }

        public void setArgs(boolean args) {
            this.args = args;
        }

        public String getStringEvent(String methodName, Object arg) {
            if (args) {
                return methodName + arg.toString();
            }
            return methodName;
        }
    }
}
