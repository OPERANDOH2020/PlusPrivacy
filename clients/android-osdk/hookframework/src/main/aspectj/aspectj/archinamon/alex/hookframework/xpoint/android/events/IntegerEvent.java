package aspectj.archinamon.alex.hookframework.xpoint.android.events;


import aspectj.archinamon.alex.hookframework.xpoint.newdesign.event.AbstractEvent;

/**
 * Created by Matei_Alexandru on 04.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class IntegerEvent extends AbstractEvent<Integer> {

    public IntegerEvent(String methodName) {
        super(methodName);
    }

    @Override
    public Integer stop() {
        return 0;
    }
}
