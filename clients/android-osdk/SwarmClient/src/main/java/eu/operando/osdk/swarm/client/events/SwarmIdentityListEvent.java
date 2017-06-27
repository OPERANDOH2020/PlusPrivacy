package eu.operando.osdk.swarm.client.events;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import eu.operando.osdk.swarm.client.models.Identity;

/**
 * Created by Edy on 10/19/2016.
 */
public class SwarmIdentityListEvent extends SwarmEvent {
    ArrayList<Identity> identities;
    @ISwarmEvent(swarm="login.js", phase = "logoutSucceed")
    public SwarmIdentityListEvent(String swarmName, String swarmPhase, JSONObject data) {
        super(swarmName, swarmPhase, data);
        try {
            this.identities = new Gson().fromJson(data.getJSONArray("identities").toString(),new TypeToken<ArrayList<Identity>>(){}.getType());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Identity> getIdentities() {
        return identities;
    }
}
