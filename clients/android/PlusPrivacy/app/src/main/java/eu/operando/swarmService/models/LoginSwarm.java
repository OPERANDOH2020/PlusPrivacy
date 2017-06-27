package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 11/3/2016.
 */

public class LoginSwarm extends Swarm {
    private boolean authenticated;
    private String email;
    private String userId;
    public LoginSwarm(String username, String password) {
        super("login.js", "userLogin", username,password);
    }

    public boolean isAuthenticated() {
        return authenticated;
    }

    public String getUserId() {
        return email;
    }
}
