package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Domain;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/14/2016.
 */

public class GetDomainsSwarmEntity extends Swarm {
    private ArrayList<Domain> domains;

    public GetDomainsSwarmEntity(String swarmingName, String phase, String command, String ctor, String tenantId, Object commandArguments) {
        super(swarmingName, phase, command, ctor, tenantId, commandArguments);
    }

    public ArrayList<Domain> getDomains() {
        return domains;
    }
}
