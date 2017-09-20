package eu.operando.swarmService;

import android.util.Pair;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import eu.operando.storage.Storage;
import eu.operando.swarmService.models.IdentityListSwarm;
import eu.operando.swarmService.models.LoginSwarm;
import eu.operando.swarmService.models.RegisterSwarm;
import eu.operando.swarmService.models.ResetPasswordSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Edy on 11/3/2016.
 */

public class SwarmService {
    private static final String SWARMS_URL = "https://plusprivacy.com:8080";
    private static final String SWARMS_URL_DEBUG = "http://192.168.103.149:8080";
    private static final String SWARMS_URL_JOS = "http://192.168.100.144:9001";
    private static final String SWARMS_URL_CIPRIAN = "http://192.168.103.133:8080";

    private static SwarmService instance;

    private SwarmClient swarmClient;

    private SwarmService() {
        SwarmClient.init(SWARMS_URL);
        swarmClient = SwarmClient.getInstance();
    }

    public static SwarmService getInstance() {
        if (instance == null) {
            instance = new SwarmService();
        }

        return instance;
    }

    public void login(String username, String password, SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(new LoginSwarm(username, password), callback);
    }

    public void logout(SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(new Swarm("login.js", "logout", (Object) null), callback);
    }

    public void signUp(final String email, final String password, final SwarmCallback<? extends Swarm> callback) {
        //connect to swarms
        login("guest@operando.eu", "guest", new SwarmCallback<Swarm>() {
            @Override
            public void call(Swarm result) {
                //register user
                swarmClient.startSwarm(new RegisterSwarm(email, password), new SwarmCallback<RegisterSwarm>() {

                    @Override
                    public void call(RegisterSwarm result) {
                        try {
                            callback.result(new JSONObject(new Gson().toJson(result)));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        //logout guest
                        logout(new SwarmCallback<Swarm>() {
                            @Override
                            public void call(Swarm result) {
//                                swarmClient.restartSocket();
                            }
                        });
                    }
                });
            }
        });
    }
    public void resetPassword(final String email, final SwarmCallback<Swarm> callback){
        login("guest@operando.eu", "guest", new SwarmCallback<Swarm>() {
            @Override
            public void call(Swarm result) {
                swarmClient.startSwarm(new ResetPasswordSwarm(email), callback);
            }
        });
    }
    public void getIdentitiesList(SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(new IdentityListSwarm(),callback);
    }

    public void autoLogin(){
        Pair<String, String> credentials = Storage.readCredentials();
        if (credentials.first != null && credentials.second != null) {
            login(credentials.first, credentials.second,null);
        }
    }
}
