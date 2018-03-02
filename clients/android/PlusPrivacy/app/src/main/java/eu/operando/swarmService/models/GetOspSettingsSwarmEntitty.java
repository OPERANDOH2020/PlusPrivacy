package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Domain;
import eu.operando.models.privacysettings.OspSettings;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 31.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class GetOspSettingsSwarmEntitty extends Swarm {

    private OspSettings ospSettings;

    public GetOspSettingsSwarmEntitty(String swarmingName, String phase, String command, String ctor, String tenantId, Object commandArguments) {
        super(swarmingName, phase, command, ctor, tenantId, commandArguments);
    }

    public OspSettings getOspSettings() {
        return ospSettings;
    }

}