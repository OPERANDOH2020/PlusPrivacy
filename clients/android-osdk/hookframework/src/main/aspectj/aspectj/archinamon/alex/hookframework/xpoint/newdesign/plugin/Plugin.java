package aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin;


import aspectj.archinamon.alex.hookframework.xpoint.newdesign.interceptor.Interceptor;

/**
 * Created by Matei_Alexandru on 02.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class Plugin extends AbstractPlugin {
    public Plugin(String ev, Interceptor interceptor) {
        super(ev, interceptor);
    }


}
