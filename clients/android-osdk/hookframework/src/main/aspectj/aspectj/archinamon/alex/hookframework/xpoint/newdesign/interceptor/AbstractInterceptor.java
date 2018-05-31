package aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor;

/**
 * Created by Matei_Alexandru on 02.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public abstract class AbstractInterceptor<T,V> implements Interceptor<T,V> {

    private boolean called = true;

    public boolean isCalled() {
        return called;
    }

    public void setShouldProceed(boolean called) {
        this.called = called;
    }
}
