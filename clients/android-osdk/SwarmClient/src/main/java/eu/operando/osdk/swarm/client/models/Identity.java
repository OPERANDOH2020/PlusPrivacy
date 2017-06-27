package eu.operando.osdk.swarm.client.models;

/**
 * Created by Edy on 10/19/2016.
 */

public class Identity {
    private String userId;
    private String email;
    private boolean isDefault;

    public String getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public boolean isDefault() {
        return isDefault;
    }
}
