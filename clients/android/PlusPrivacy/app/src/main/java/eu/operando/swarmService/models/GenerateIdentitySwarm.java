package eu.operando.swarmService.models;

import eu.operando.models.Identity;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/14/2016.
 */

public class GenerateIdentitySwarm extends Swarm {
    private Identity generatedIdentity;
    public GenerateIdentitySwarm() {
        super("identity.js", "generateIdentity");
    }

    public Identity getIdentity() {
        return generatedIdentity;
    }
}
