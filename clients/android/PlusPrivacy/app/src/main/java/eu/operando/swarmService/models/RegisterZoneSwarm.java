package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 24.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class RegisterZoneSwarm extends Swarm {

    public RegisterZoneSwarm(String arg) {
        super("notification.js", "registerInZone", arg);
    }

}
