package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Identity;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/5/2016.
 */

public class IdentityListSwarmEntity extends Swarm {
    private ArrayList<Identity> identities;

    public IdentityListSwarmEntity(String swarmingName, String ctor, ArrayList<Identity> identities, Object... commandArguments) {
        super(swarmingName, ctor, commandArguments);
        this.identities = identities;
    }

    public ArrayList<Identity> getIdentities() {
        return identities;
    }
}
