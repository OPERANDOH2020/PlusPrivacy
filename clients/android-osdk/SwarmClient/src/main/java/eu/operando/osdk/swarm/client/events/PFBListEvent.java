package eu.operando.osdk.swarm.client.events;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import eu.operando.osdk.swarm.client.models.PFBObject;

/**
 * Created by Edy on 10/26/2016.
 */

public class PFBListEvent extends SwarmEvent {
    private ArrayList<PFBObject> pfbs;
    public PFBListEvent(String swarmName, String swarmPhase, JSONObject data) {
        super(swarmName, swarmPhase, data);
        try {
            pfbs = new Gson().fromJson(data.getJSONArray("deals").toString(),new TypeToken<ArrayList<PFBObject>>(){}.getType());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<PFBObject> getPfbs() {
        return pfbs;
    }
}
