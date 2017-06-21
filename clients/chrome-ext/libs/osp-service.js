/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */


var bus = require("bus-service").bus;

var ospService = exports.ospService = {
    getOSPSettings: function (success_callback) {
        var getOSPSettingsHandler = swarmHub.startSwarm('PrivacyWizardSwarm.js', 'getOSPSettings');
        getOSPSettingsHandler.onResponse("gotOSPSettings",function(swarm){
            success_callback(swarm.ospSettings);
        });
    }
}

bus.registerService(ospService);

