package eu.operando.swarmService.models;

import com.google.gson.annotations.SerializedName;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 11/7/2016.
 */

public class RegisterSwarm extends Swarm {
    private String status;

    public RegisterSwarm(String email, String password) {
        this(new RegisterInfo(email, password, password));
    }

    private RegisterSwarm(RegisterInfo commandArguments) {
        super("register.js", "registerNewUser", commandArguments);
    }

    public String getStatus() {
        return status;
    }

}

class RegisterInfo {
    private String username;
    private String email;
    private String password;
    @SerializedName("repeat_password")
    private String repeatPassword;

    RegisterInfo(String email, String password, String repeatPassword) {
        this.email = email;
        this.password = password;
        this.repeatPassword = repeatPassword;
    }
}