package aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor;

public interface Interceptor<T,V> {

    public void beforeCall(Object[] args);
    public T afterCall(V result);
}
