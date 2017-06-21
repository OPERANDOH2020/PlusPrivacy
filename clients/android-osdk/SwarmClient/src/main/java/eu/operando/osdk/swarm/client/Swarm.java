package eu.operando.osdk.swarm.client;

import org.json.JSONObject;

public class Swarm {
    private String name;
    private String phase;
    private JSONObject data;



    public Swarm(String name, String phase, JSONObject data){
        this.name = name;
        this.phase = phase;
        this.data = data;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhase() {
        return phase;
    }

    public void setPhase(String phase) {
        this.phase = phase;
    }

    public JSONObject getData() {
        return data;
    }

    public void setData(JSONObject data) {
        this.data = data;
    }
}
