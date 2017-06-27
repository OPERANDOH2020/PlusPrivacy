package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Identity;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/5/2016.
 */

public class IdentityListSwarm extends Swarm {
    private ArrayList<Identity> identities;

    public IdentityListSwarm() {
        super("identity.js", "getMyIdentities", (Object) null);
    }

    public ArrayList<Identity> getIdentities() {
        return identities;
    }
}
