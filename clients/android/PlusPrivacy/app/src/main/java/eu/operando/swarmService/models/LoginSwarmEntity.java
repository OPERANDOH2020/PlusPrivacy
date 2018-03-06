package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 11/3/2016.
 */

public class LoginSwarmEntity extends Swarm {
    private boolean authenticated;
    private String email;
    private String userId;

    public LoginSwarmEntity(String swarmingName, String ctor, Object... commandArguments) {
        super(swarmingName, ctor, commandArguments);
    }

    public boolean isAuthenticated() {
        return authenticated;
    }

    public String getUserId() {
        return email;
    }
}
