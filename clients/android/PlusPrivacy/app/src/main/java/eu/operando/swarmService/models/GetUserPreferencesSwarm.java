package eu.operando.swarmService.models;

import java.util.List;

import eu.operando.models.privacysettings.Preference;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 06.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class GetUserPreferencesSwarm extends Swarm {

    public GetUserPreferencesSwarm(Object... args) {
        super("UserPreferences.js", "getPreferences", args);
    }

    private List<Preference> preferences;

    public List<Preference> getPreferences() {
        return preferences;
    }
}
