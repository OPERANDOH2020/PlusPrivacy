package eu.operando.osdk.swarm.client.events;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import eu.operando.osdk.swarm.client.models.Domain;

/**
 * Created by Edy on 10/20/2016.
 */

public class DomainsListSuccessEvent extends SwarmEvent {
    private ArrayList<Domain> domains;
    public DomainsListSuccessEvent(String swarmName, String swarmPhase, JSONObject data) {
        super(swarmName, swarmPhase, data);
        try {
            domains = new Gson().fromJson(data.getJSONArray("domains").toString(),new TypeToken<ArrayList<Domain>>(){}.getType());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Domain> getDomains() {
        return domains;
    }
}
