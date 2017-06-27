package eu.operando.swarmService.models;

import com.google.gson.annotations.SerializedName;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 11/7/2016.
 */

public class RegisterSwarm extends Swarm {
    private String status;
    private String error;

    public RegisterSwarm(String name, String email, String password) {
        this(new RegisterInfo(name, email, password, password));
    }

    private RegisterSwarm(RegisterInfo commandArguments) {
        super("register.js", "registerNewUser", commandArguments);
    }

    public String getStatus() {
        return status;
    }

    public String getError() {
        return error;
    }
}

class RegisterInfo {
    private String username;
    private String email;
    private String password;
    @SerializedName("repeat_password")
    private String repeatPassword;

    RegisterInfo(String username, String email, String password, String repeatPassword) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.repeatPassword = repeatPassword;
    }
}