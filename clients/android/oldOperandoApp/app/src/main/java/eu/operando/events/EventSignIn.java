package eu.operando.events;

import eu.operando.osdk.swarm.client.SwarmClient;

/**
 * Created by raluca on 08.04.2016.
 */
public class EventSignIn {

    private String email;
    private String password;

    public EventSignIn(String email, String password) {
        this.email = email;
        this.password = password;

        try {
            //login
            String[] commandArguments = {this.email, this.password};
            SwarmClient.getInstance().startSwarm("login.js", "start", "userLogin", commandArguments);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
