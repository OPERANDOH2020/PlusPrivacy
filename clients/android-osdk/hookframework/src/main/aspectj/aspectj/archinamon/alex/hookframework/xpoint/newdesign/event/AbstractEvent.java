package aspectj.archinamon.alex.hookframework.xpoint.newdesign.event;

import java.util.Random;

/**
 * Created by Matei_Alexandru on 02.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public abstract class AbstractEvent<T> implements Event<T> {

    private int id;
    private String methodName;

    private T initialValue;
    private T value;
    private static Random rnd = new Random();

    public AbstractEvent(String methodName) {
        this.methodName = methodName;
        id = rnd.nextInt();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMethodName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    @Override
    public T getInitialValue() {
        return initialValue;
    }

    public void setInitialValue(T initialValue) {
        this.initialValue = initialValue;
    }

    @Override
    public T getValue() {
        return value;
    }

    @Override
    public void modifyValue(T newValue) {
        this.value = newValue;
    }
}
