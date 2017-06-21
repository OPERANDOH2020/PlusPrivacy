package eu.operando.osdk.swarm.client.events;

import org.json.JSONObject;

/**
 * Created by Rafa on 4/6/2016.
 */


public class SwarmEvent {

    private final String swarmName;
    private final String swarmPhase;
    private final JSONObject data;


    public SwarmEvent(String swarmName, String swarmPhase, JSONObject data) {
        this.swarmName = swarmName;
        this.swarmPhase = swarmPhase;
        this.data = data;

    }

    public JSONObject getData(){
        return this.data;
    }
}



