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

var adapterPort         = 3000;
var adapterHost         = "localhost";
globalVerbosity = false;
var assert              = require('double-check').assert;


var util       = require("swarmcore");
var client     = util.createClient(adapterHost, adapterPort, "testExtension", "ok","testTenant", "testCtor");

assert.callback("Swarm extension", function(callback){
    console.log("Start swarming...");
    client.startSwarm("extension.js","registerRequest",{}, "RafaelMastaleru","RMS");

    swarmHub.on("extension.js","onClient", function(swarm){
        assert.equal(swarm.requestWasFullfilled, true);
        callback();
        client.logout();
    });

});