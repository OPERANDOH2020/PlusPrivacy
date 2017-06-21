package eu.operando.osdk.swarm.client;


import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;

import eu.operando.osdk.swarm.client.utils.EventProvider;
import eu.operando.osdk.swarm.client.utils.SwarmConstants;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class SwarmClient {

    private Socket ioSocket;
    private SwarmHub swarmHub;
    private String tenantId;
    private static SwarmClient instance = null;

    protected SwarmClient(String connectionURL, String tenantId) {

        this.tenantId = tenantId;
        try {

            ioSocket = IO.socket(connectionURL);
            swarmHub = SwarmHub.getInstance();
            ioSocket.connect();

            Emitter.Listener onNewMessage = new Emitter.Listener() {
                @Override
                public void call(final Object... args) {
                    JSONObject data = (JSONObject) args[0];
                    swarmHub.handleMessage(data);
                }
            };

            this.ioSocket.on("message", onNewMessage);
            //getIdentity();
        } catch (URISyntaxException exception) {
            //WHAT TODO:-??
        }
    }

    public static SwarmClient getInstance(String connectionURL, String tenantId) {
        if (instance == null) {
            instance = new SwarmClient(connectionURL, tenantId);
        }
        return instance;
    }

    public static SwarmClient getInstance() throws Exception {
        if(instance == null){
            throw new Exception("Swarm instance was not inialized");
        }
        return instance;
    }

    public void startSwarm(String swarmName, String phase, String ctor, String[]... data) {

        JSONObject swarmMeta = new JSONObject();
        JSONObject swarmData = new JSONObject();
        Gson gsonData = new Gson();

        try {
            swarmMeta.put("swarmingName", swarmName);
            swarmMeta.put("phase", phase);
            swarmMeta.put("command", "start");
            swarmMeta.put("ctor", ctor);
            swarmMeta.put("tenantId", this.tenantId);
            if (data.length > 0) {
                JSONArray jsonArray = new JSONArray(data[0]);
                swarmMeta.put("commandArguments", jsonArray);
            }

            swarmData.put("meta", swarmMeta);

        } catch (JSONException e) {
            e.printStackTrace();
        }

        this.ioSocket.emit("message", swarmData);
    }

}
