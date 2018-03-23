package aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework;

import android.os.BatteryManager;
import android.util.Log;


import org.aspectj.lang.JoinPoint;

import java.util.Arrays;
import java.util.List;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.event.AbstractEvent;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.event.EventFactory;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.AbstractInterceptor;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin.AbstractPlugin;

/**
 * Created by Matei_Alexandru on 07.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public abstract class Behavior<T> {

    private HookFramework hookFramework;
    private JoinPoint joinPoint;

    public Behavior(HookFramework hookFramework, JoinPoint joinPoint) {
        this.hookFramework = hookFramework;
        this.joinPoint = joinPoint;
    }

    public T run() {

        AbstractEvent event = createEvent(joinPoint);
        Log.e("AbstractEvent", event.getMethodName());
        if (check(joinPoint)) {
            Log.e("Behavior", "stop called");
            return (T) event.stop();
        }

        AbstractPlugin myCustomPlugin = hookFramework.getPluginByEventName(event.getMethodName());
//        myCustomPlugin.setEvent(event);

        if (hookFramework.getPluginsSize() == 0 || myCustomPlugin == null) {
            return pluginNotRegistered();
        }
        AbstractInterceptor interceptor = (AbstractInterceptor)
                myCustomPlugin.getInterceptor(event.getMethodName());
        if (interceptor == null) {
            return interceptorNotRegistered();
        }
        interceptor.beforeCall(joinPoint.getArgs());
        if (interceptor.isCalled()) {
            return afterCallReturn(event, interceptor);
        }
        return (T) event.stop();
    }

    public abstract T pluginNotRegistered();

    public abstract T interceptorNotRegistered();

    public abstract T afterCallReturn(AbstractEvent event, AbstractInterceptor interceptor);

    public boolean check(JoinPoint thisJoinPoint) {
        if (!thisJoinPoint.getSignature().getName().equals("getIntExtra"))
            return false;
        Log.e("check HookConcreteAdapt", thisJoinPoint.getSignature().getName());
        String[] list = {BatteryManager.EXTRA_LEVEL, BatteryManager.EXTRA_SCALE,
                BatteryManager.EXTRA_STATUS, BatteryManager.EXTRA_STATUS, BatteryManager.EXTRA_STATUS,
                BatteryManager.EXTRA_PLUGGED, BatteryManager.EXTRA_TEMPERATURE, BatteryManager.ACTION_CHARGING,
                BatteryManager.ACTION_DISCHARGING, BatteryManager.EXTRA_HEALTH, BatteryManager.EXTRA_PRESENT,
                BatteryManager.EXTRA_TECHNOLOGY, BatteryManager.EXTRA_STATUS, BatteryManager.EXTRA_VOLTAGE};
        List<String> batteryManagerConstants = Arrays.asList(list);

        return !batteryManagerConstants.contains((String) thisJoinPoint.getArgs()[0]);
    }

    private AbstractEvent createEvent(JoinPoint thisJoinPoint) {

        String clazz = thisJoinPoint.getSignature().getDeclaringType().toString();
        String methodName = thisJoinPoint.getSignature().getName();
        Object[] args = thisJoinPoint.getArgs();
        Log.e("createEvent", clazz + " " + methodName + " " + args[0].toString());

        AbstractEvent event = EventFactory.getInstance().getEvent(clazz, methodName, args);
        event.setInitialValue(thisJoinPoint.getThis());
        return event;
    }

}
