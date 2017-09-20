package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 30.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class UDESwarm extends Swarm {

    public UDESwarm(String arg) {
        super("UDESwarm.js", "registerDeviceId", arg);

    }
}
