package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 29-Jun-17.
 */

public class ResetPasswordSwarm extends Swarm {
    public ResetPasswordSwarm(String email) {
        super("UserInfo.js", "resetPassword", email);
    }
}
