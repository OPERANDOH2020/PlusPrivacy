package eu.operando.swarmService.models;

import eu.operando.models.Identity;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/14/2016.
 */

public class CreateIdentitySwarm extends Swarm {
    public CreateIdentitySwarm( Identity identity) {
        super("identity.js", "createIdentity", identity);
    }
}
