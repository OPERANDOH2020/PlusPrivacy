package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.PFBObject;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/20/2016.
 */
public class GetPFBSwarm extends Swarm {
    ArrayList<PFBObject> deals;

    public GetPFBSwarm() {
        super("pfb.js", "getAllDeals");
    }

    public ArrayList<PFBObject> getDeals() {
        return deals;
    }
}
