package eu.operando.osdk.swarm.client.events;

import org.json.JSONObject;

/**
 * Created by Rafa on 4/6/2016.
 */


public class SwarmLogoutEvent extends SwarmEvent {
    @ISwarmEvent(swarm="login.js", phase = "logoutSucceed")
    public SwarmLogoutEvent(String swarmName, String swarmPhase, JSONObject data) {
        super(swarmName, swarmPhase, data);
    }
}
