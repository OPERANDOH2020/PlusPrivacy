package eu.operando.swarmService.models;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 06.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SaveUserPreferencesSwarm extends Swarm {

        public SaveUserPreferencesSwarm(Object... args) {
            super("UserPreferences.js", "saveOrUpdatePreferences", args);
        }

}
