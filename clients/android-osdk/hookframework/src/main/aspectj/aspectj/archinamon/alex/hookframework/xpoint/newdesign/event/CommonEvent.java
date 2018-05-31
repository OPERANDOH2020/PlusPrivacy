package aspectj.archinamon.alex.hookframework.xpoint.newdesign.event;

/**
 * Created by Matei_Alexandru on 04.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class CommonEvent extends AbstractEvent{
    public CommonEvent(String methodName) {
        super(methodName);
    }

    @Override
    public Object stop() {
        return null;
    }
}
