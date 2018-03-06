package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 11/7/2016.
 */

public class RegisterSwarmEntity extends Swarm {
    private String status;

    public RegisterSwarmEntity(String email, String password) {
        this(new RegisterInfo(email, password, password));
    }

    private RegisterSwarmEntity(RegisterInfo commandArguments) {
        super("register.js", "registerNewUser", commandArguments);
    }

    public String getStatus() {
        return status;
    }

}