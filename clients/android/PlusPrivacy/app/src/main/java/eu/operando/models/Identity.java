package eu.operando.models;

/**
 * Created by Edy on 12/5/2016.
 */

public class Identity {
    //for creation
    private String email;
    private String alias;
    private Domain domain;

    //for receiving
    private String userId;
    private boolean isReal;
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

    public boolean isReal() {
        return isReal;
    }

    public Identity(String email, String alias, Domain domain) {
        this.email = email;
        this.alias = alias;
        this.domain = domain;
    }
}
