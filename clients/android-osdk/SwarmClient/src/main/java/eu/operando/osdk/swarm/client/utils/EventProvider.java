package eu.operando.osdk.swarm.client.utils;


import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.ServiceLoader;
import java.util.Set;

import eu.operando.osdk.swarm.client.events.CreateIdentitySuccessEvent;
import eu.operando.osdk.swarm.client.events.DealResultEvent;
import eu.operando.osdk.swarm.client.events.DomainsListSuccessEvent;
import eu.operando.osdk.swarm.client.events.GenerateIdentitySuccessEvent;
import eu.operando.osdk.swarm.client.events.ISwarmEvent;
import eu.operando.osdk.swarm.client.events.PFBListEvent;
import eu.operando.osdk.swarm.client.events.SwarmEvent;
import eu.operando.osdk.swarm.client.events.SwarmIdentityListEvent;
import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;
import eu.operando.osdk.swarm.client.events.SwarmLogoutEvent;

/**
 * Created by Rafa on 4/7/2016.
 */
public class EventProvider {
    private static EventProvider instance = null;

    private HashMap<String, Class> eventDictionary = new HashMap<String, Class>();

    private EventProvider() {
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
        insertEventInDictionary("identity.js","getMyIdentities_success",SwarmIdentityListEvent.class);
        insertEventInDictionary("identity.js","generateIdentity_success",GenerateIdentitySuccessEvent.class);
        insertEventInDictionary("identity.js","createIdentity_success",CreateIdentitySuccessEvent.class);
        insertEventInDictionary("identity.js","gotDomains",DomainsListSuccessEvent.class);
        insertEventInDictionary("pfb.js","gotAllDeals", PFBListEvent.class);
        insertEventInDictionary("pfb.js","dealAccepted",DealResultEvent.class);
        insertEventInDictionary("pfb.js","dealUnsubscribed",DealResultEvent.class);
    }

    public Class<?> getEvent(String swarmName, String swarmPhase) {
        return (Class<?>) eventDictionary.get(swarmName + swarmPhase);
    }

}
