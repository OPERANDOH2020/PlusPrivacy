package eu.operando.swarmService.models;

import eu.operando.models.privacysettings.OspSettings;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 31.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class PrivacyWizardSwarm extends Swarm {
    public PrivacyWizardSwarm(String ctor) {
        super("PrivacyWizardSwarm.js", ctor);
    }

    private OspSettings ospSettings;

    public OspSettings getOspSettings() {
        return ospSettings;
    }
}