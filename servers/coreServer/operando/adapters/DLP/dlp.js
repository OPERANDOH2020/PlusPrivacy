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
core.createAdapter("DataLeakageProtection");
var apersistence = require('apersistence');
var container = require("safebox").container;
var flow = require("callflow");

apersistence.registerModel("DataProtectionFilter", "Redis", {
        filterId:{
          type:"string",
          index: "true",
          pk:true
        },
        filterName: {
            type: "string",
            index: true
        },
        filterType: {
            type: "string",
            index: true
        },
        filterEndPoint: {
            type: "string",
        }
    },
    function (err, model) {
        if (err) {
            console.log(model);
        }
    }
);

container.declareDependency("DataLeakageProtection", ["redisPersistence"], function (outOfService, redisPersistence) {
    if (!outOfService) {
        console.log("Enabling persistence...");
    } else {
        console.log("Disabling persistence...");
    }
})
