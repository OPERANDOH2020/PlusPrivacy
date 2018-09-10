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

var identities = [];
var lastUpdate = new Date();
const oneHour = 60*60*1000;
var listIdentitiesInProgress = false;
var waitingForIdentitiesCallbacks = [];

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
            identities.push(swarm.identity);
            success_callback(swarm.identity);
        });

        addIdentityHandler.onResponse("createIdentity_error", function(swarm){
            error_callback(swarm.error);
        });
    },

    removeIdentity: function (identity, success_callback, error_callback) {
        var removeIdentityHandler = swarmHub.startSwarm('identity.js', 'removeIdentity', identity);
        removeIdentityHandler.onResponse("deleteIdentity_success",function(swarm){
            identities = identities.filter(function(oldIdentity){
                return oldIdentity.email!=identity.email;
            });

            var defaultIdentity = identities.find(function(identity){
                return identity.email === swarm.default_identity.email;
            });

            defaultIdentity.isDefault = true;

            success_callback(swarm.identity);
        });

        removeIdentityHandler.onResponse("deleteIdentity_error",function(swarm){
            error_callback(swarm.error);
        });
    },

    listIdentities: function (callback) {

        function returnIdentities(identities){
            while(waitingForIdentitiesCallbacks.length>0){
                var cbk = waitingForIdentitiesCallbacks.pop();
                cbk(identities);
            }
        }
        waitingForIdentitiesCallbacks.push(callback);

        if(listIdentitiesInProgress == false){
            if(identities.length===0 || (new Date()-lastUpdate>oneHour)) {
                listIdentitiesInProgress = true;
                var listIdentitiesHandler = swarmHub.startSwarm('identity.js', 'getMyIdentities');
                listIdentitiesHandler.onResponse("getMyIdentities_success", function (swarm) {
                    listIdentitiesInProgress = false;
                    identities = swarm.identities;
                    lastUpdate = new Date();

                   returnIdentities(swarm.identities);
                });
            }else{
                returnIdentities(identities);
            }
        }
    },

    updateDefaultSubstituteIdentity:function(identity, callback){
        var updateDefaultIdentityHandler = swarmHub.startSwarm('identity.js', 'updateDefaultSubstituteIdentity', identity);
        updateDefaultIdentityHandler.onResponse("defaultIdentityUpdated", function(swarm){
            identities.forEach(function(oldIdentity){
                oldIdentity.isDefault = (oldIdentity.email===identity.email);
            })
            
            callback(swarm.identity);
        })
    },

    listDomains: function(callback){
        var listDomainsHandler = swarmHub.startSwarm('identity.js', 'listDomains');
        listDomainsHandler.onResponse("gotDomains", function(swarm){
           callback(swarm.domains);
        });
    },
    clearIdentitiesList : function(){
        identities = [];
        listIdentitiesInProgress = false;
        waitingForIdentitiesCallbacks = [];
    }
}

bus.registerService(identityService);
