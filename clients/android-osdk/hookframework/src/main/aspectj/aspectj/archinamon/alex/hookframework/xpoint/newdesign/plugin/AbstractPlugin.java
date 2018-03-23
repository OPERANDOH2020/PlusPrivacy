package aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin;


import java.util.HashMap;
import java.util.Map;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework.HookFramework;
import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.Interceptor;

public abstract class AbstractPlugin {

//    private String strEvent;
//    private Interceptor interceptor;
//    private Event event;

//    public AbstractPlugin(String methodName, Interceptor interceptor) {
//        this.strEvent = methodName;
//        this.interceptor = interceptor;
//    }

    private Map<String, Interceptor> hashMap;

    public AbstractPlugin() {
        hashMap = new HashMap<>();
        HookFramework hookFramework = HookFramework.getInstance();
        hookFramework.attach(this);
    }

    public AbstractPlugin(String methodName, Interceptor interceptor) {
        this();
        hashMap.put(methodName, interceptor);
    }

    public void add(String methodName, Interceptor interceptor){
        hashMap.put(methodName, interceptor);
    }

    public boolean containsStrEvent(String methodName) {
        return hashMap.containsKey(methodName);
    }

    public Interceptor getInterceptor(String event){
        return hashMap.get(event);
    }

//    public String getStrEvent() {
//        return strEvent;
//    }
//
//    public Interceptor getInterceptor() {
//        return interceptor;
//    }
//
//    public void setEvent(Event event) {
//        this.event = event;
//    }
//
//    public Event getEvent() {
//        return event;
//    }
}