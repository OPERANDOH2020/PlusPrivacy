package eu.operando.swarmService.models;

import java.util.List;

import eu.operando.models.PFBObject;
import eu.operando.models.PfbDeal;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 12/20/2016.
 */
public class PfbSwarmEntity extends Swarm {

    private List<PFBObject> deals;
    private PfbDeal deal;

    public PfbSwarmEntity(List<PFBObject> deals, PfbDeal deal, String swarmingName, String ctor, Object... commandArguments) {
        super(swarmingName, ctor, commandArguments);
        this.deals = deals;
        this.deal = deal;
    }

    public List<PFBObject> getDeals() {
        return deals;
    }

    public void setDeals(List<PFBObject> deals) {
        this.deals = deals;
    }

    public PfbDeal getDeal() {
        return deal;
    }

    public void setDeal(PfbDeal deal) {
        this.deal = deal;
    }
}
