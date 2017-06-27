package eu.operando.osdk.swarm.client.events;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import eu.operando.osdk.swarm.client.models.Identity;

/**
 * Created by Edy on 10/20/2016.
 */
public class GenerateIdentitySuccessEvent extends SwarmEvent{
    private Identity identity;
    public GenerateIdentitySuccessEvent(String swarmName, String swarmPhase, JSONObject data) {
        super(swarmName, swarmPhase, data);
        try {
            this.identity = new Gson().fromJson(data.getJSONObject("generatedIdentity").toString(),Identity.class);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public Identity getIdentity() {
        return identity;
    }
}
