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


var core = require("swarmcore");
core.createAdapter("SocialNetworkSettingsAdapter");
var apersistence = require('apersistence');
var container = require("safebox").container;
var flow = require("callflow");

apersistence.registerModel("SocialNetworkPrivacySettings", "Redis", {
        social_network: {
            type: "string",
            index: "true"
        },
        userId:{
            type: "string",
            index: "true"
        },
        privacy_setting_key: {
            type: "string",
            index: "true"
        },
        privacy_setting_value: {
            type: "string"
        },
        lastUpdated:{
            type: "date"
        }
    },
    function (err, model) {
        if (err) {
            console.log(model);
        }
    }
);

