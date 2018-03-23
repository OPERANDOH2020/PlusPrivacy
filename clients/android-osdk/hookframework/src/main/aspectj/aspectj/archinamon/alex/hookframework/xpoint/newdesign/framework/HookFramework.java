package aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework;

import java.util.LinkedList;
import java.util.List;

import aspectj.archinamon.alex.hookframework.xpoint.newdesign.plugin.AbstractPlugin;

/**
 * Created by Matei_Alexandru on 02.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class HookFramework {

    //    public AbstractPlugin startPlugin;
//    public AbstractPlugin nextPlugin;
    private static HookFramework instance;
    private List<AbstractPlugin> plugins;

    private HookFramework() {
        plugins = new LinkedList<>();
    }

    public static HookFramework getInstance() {
        if (instance == null)
            instance = new HookFramework();
        return instance;
    }

    // retrieve array from anywhere
    public List<AbstractPlugin> getPlugins() {
        return this.plugins;
    }

    public int getPluginsSize() {
        return this.plugins.size();
    }

    public void attach(AbstractPlugin plugin) {
        plugins.add(plugin);
    }

    public void remove(AbstractPlugin plugin) {
        plugins.remove(plugin);
    }

    public AbstractPlugin get(int index) {
        return plugins.get(index);
    }

    public AbstractPlugin getPluginByEventName(String name) {
        for (AbstractPlugin plugin : plugins) {
            if (plugin.containsStrEvent(name)) {
                return plugin;
            }
        }
        return null;
    }
}
