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

var adapterPort     = 3000;
var adapterHost     = "localhost";
var util            = require("swarmcore");
var assert          = require('double-check').assert;
globalVerbosity     = false;

var client     = util.createClient(adapterHost, adapterPort, "testLoginUser", "ok","testTenant", "testCtor");

client.startSwarm("notification.js","getNotifications");
swarmHub.on("notification.js","success", function(swarm){
    console.log(swarm.notifications);
    assert.objectHasFields(swarm.notifications);
    client.logout();
});
