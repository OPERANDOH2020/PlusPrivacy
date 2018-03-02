package eu.operando.swarmService.models;

import java.util.List;

import eu.operando.models.privacysettings.Preference;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 06.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class GetUserPreferencesSwarmEntity extends Swarm {

    private List<Preference> preferences;

    public GetUserPreferencesSwarmEntity(String swarmingName, String phase, String command, String ctor, String tenantId, Object commandArguments) {
        super(swarmingName, phase, command, ctor, tenantId, commandArguments);
    }

    public List<Preference> getPreferences() {
        return preferences;
    }
}
