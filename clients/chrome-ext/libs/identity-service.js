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

var identityService = exports.identityService = {

    generateIdentity: function (success_callback, error_callback) {
        var generateIdentityHandler = swarmHub.startSwarm('identity.js', 'generateIdentity');
        generateIdentityHandler.onResponse("generateIdentity_success", function(swarm){
             success_callback(swarm.generatedIdentity);
        });

        generateIdentityHandler.onResponse("generateIdentity_error", function(swarm){
             error_callback(swarm.error);
        });
    },

    addIdentity: function (identity, success_callback, error_callback) {
        var addIdentityHandler = swarmHub.startSwarm('identity.js', 'createIdentity', identity);

        addIdentityHandler.onResponse("createIdentity_success", function(swarm){
            success_callback(swarm.identity);
        });

        addIdentityHandler.onResponse("createIdentity_error", function(swarm){
            error_callback(swarm.error);
        });
    },

    removeIdentity: function (identity, success_callback, error_callback) {
        var removeIdentityHandler = swarmHub.startSwarm('identity.js', 'removeIdentity', identity);
        removeIdentityHandler.onResponse("deleteIdentity_success",function(swarm){
            success_callback(swarm.default_identity);
        });

        removeIdentityHandler.onResponse("deleteIdentity_error",function(swarm){
            error_callback(swarm.error);
        });
    },

    listIdentities: function (callback) {
        var listIdentitiesHandler = swarmHub.startSwarm('identity.js', 'getMyIdentities');
        listIdentitiesHandler.onResponse("getMyIdentities_success",function(swarm){
            callback(swarm.identities);
        });
    },

    updateDefaultSubstituteIdentity:function(identity, callback){
        var updateDefaultIdentityHandler = swarmHub.startSwarm('identity.js', 'updateDefaultSubstituteIdentity', identity);
        updateDefaultIdentityHandler.onResponse("defaultIdentityUpdated", function(swarm){
            callback(swarm.identity);
        })
    },

    listDomains: function(callback){
        var listDomainsHandler = swarmHub.startSwarm('identity.js', 'listDomains');
        listDomainsHandler.onResponse("gotDomains", function(swarm){
           callback(swarm.domains);
        });
    }
}

bus.registerService(identityService);
