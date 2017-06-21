package eu.operando.osdk.swarm.client.utils;


import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.ServiceLoader;
import java.util.Set;

import eu.operando.osdk.swarm.client.events.ISwarmEvent;
import eu.operando.osdk.swarm.client.events.SwarmEvent;
import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;
import eu.operando.osdk.swarm.client.events.SwarmLogoutEvent;

/**
 * Created by Rafa on 4/7/2016.
 */
public class EventProvider {
    private static EventProvider instance = null;

    HashMap<String, Class> eventDictionary = new HashMap<String, Class>();

    public EventProvider() {
        prepareSwarmEvents();
    }

    private void insertEventInDictionary(String swarmName, String phase, Class<?> swarmEventClass) {
        eventDictionary.put(swarmName + phase, swarmEventClass);
    }

    public static EventProvider getInstance() {
        if (instance == null) {
            instance = new EventProvider();
        }
        return instance;
    }

    private void prepareSwarmEvents() {
        insertEventInDictionary("login.js", "success", SwarmLoginEvent.class);
        insertEventInDictionary("login.js", "logoutSucceed", SwarmLogoutEvent.class);
    }

    public Class<?> getEvent(String swarmName, String swarmPhase) {
        Class<?> eventClass = eventDictionary.get(swarmName + swarmPhase);
        return eventClass;
    }

}
