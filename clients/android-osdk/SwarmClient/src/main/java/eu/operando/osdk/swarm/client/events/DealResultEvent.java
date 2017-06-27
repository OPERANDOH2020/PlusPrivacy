package eu.operando.osdk.swarm.client.events;

import org.json.JSONObject;

/**
 * Created by Edy on 10/27/2016.
 */

public class DealResultEvent extends SwarmEvent {
    public DealResultEvent(String swarmName, String swarmPhase, JSONObject data) {
        super(swarmName, swarmPhase, data);
    }
}
