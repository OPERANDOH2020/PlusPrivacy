package eu.operando.swarmService.models;

import eu.operando.models.Identity;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/14/2016.
 */

public class GenerateIdentitySwarmEntity extends Swarm {
    private Identity generatedIdentity;

    public GenerateIdentitySwarmEntity(String swarmingName, String phase, String command, String ctor, String tenantId, Object commandArguments) {
        super(swarmingName, phase, command, ctor, tenantId, commandArguments);
    }

    public Identity getIdentity() {
        return generatedIdentity;
    }

}
