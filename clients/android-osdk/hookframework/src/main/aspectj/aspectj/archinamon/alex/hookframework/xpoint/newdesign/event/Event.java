package aspectj.archinamon.alex.hookframework.xpoint.newdesign.event;

public interface Event<T> {
    T getValue();
    T getInitialValue();
    void modifyValue(T nv);
    T stop();
    //void stopPropagation();
    //void stopEvent();
}
