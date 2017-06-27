package eu.operando.model;

import java.io.Serializable;

import eu.operando.osdk.swarm.client.models.Domain;

/**
 * Created by Edy on 10/20/2016.
 */

public class CreateIdentityBody implements Serializable{
    String email;
    String  alias;
    Domain domain;

    public CreateIdentityBody(String email, String alias, Domain domain) {
        this.email = email;
        this.alias = alias;
        this.domain = domain;
    }

    public String getEmail() {
        return email;
    }

    public String getAlias() {
        return alias;
    }

    public Domain getDomain() {
        return domain;
    }
}
