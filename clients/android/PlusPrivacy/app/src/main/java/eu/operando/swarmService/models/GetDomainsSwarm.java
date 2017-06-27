package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Domain;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/14/2016.
 */

public class GetDomainsSwarm extends Swarm {
    private ArrayList<Domain> domains;

    public GetDomainsSwarm() {
        super("identity.js", "listDomains");
    }

    public ArrayList<Domain> getDomains() {
        return domains;
    }
}
