package eu.operando.osdk.swarm.client;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONObject;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;
import eu.operando.osdk.swarm.client.events.SwarmLogoutEvent;
import eu.operando.osdk.swarm.client.utils.EventProvider;
import eu.operando.osdk.swarm.client.utils.SwarmConstants;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;


/**
 * Created by Rafa on 4/5/2016.
 */
public class SwarmHub {

    private Socket ioSocket;
    private List<Swarm> swarms = new ArrayList<Swarm>();
    private static SwarmHub instance = null;
    private EventProvider eventProvider;

    protected SwarmHub(){
        eventProvider = eventProvider.getInstance();
    }
    public static SwarmHub getInstance(){
        if(instance == null){
            instance = new SwarmHub();
        }
        return instance;
    }

    public void handleMessage(JSONObject data) {
        try {
            JSONObject metaResponse = new JSONObject(data.get("meta").toString());
            String swarmingName = metaResponse.getString(SwarmConstants.SWARMING_NAME);
            String currentPhase = metaResponse.getString(SwarmConstants.CURRENT_PHASE);

            System.out.println(swarmingName);
            System.out.println(currentPhase);

            Swarm swarm = new Swarm(swarmingName, currentPhase, data);
            //swarms.add(swarm);
            fireEvent(swarm);

        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }


    private void fireEvent(Swarm swarm){

        try {
            Class<?> clazz = eventProvider.getEvent(swarm.getName(),swarm.getPhase());
            Constructor<?> constructor = clazz.getConstructor(String.class, String.class, JSONObject.class);
            Object instance = constructor.newInstance(swarm.getName(), swarm.getPhase(), swarm.getData());
            EventBus.getDefault().post(instance);

        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

}
