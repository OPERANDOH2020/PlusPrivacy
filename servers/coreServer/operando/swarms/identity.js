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

var identitySwarming = {
    meta: {
        name: "identity.js"
    },

    vars: {
        error:{},
    },

    start: function () {
        console.log("Swarm extension started");
    },

    generateIdentity: function(){
        this.action = "generateIdentity";
        this.swarm("generateIdentityPhase");
    },

    createIdentity: function (identity) {
        console.log(identity);
        if (identity) {
            this.identity = identity;
            this.action = "createIdentity";
            this.swarm("checkUserIdentities");
        }
        else {
            this.error = new Error("Identity data was not provided for create");
            this.swarm("error");
        }
    },

    getMyIdentities: function () {
        this.action = "getMyIdentities";
        this.swarm("getUserIdentities");
    },


    updateDefaultSubstituteIdentity:function(identity){
        this.identity = identity;
        this.action = "updateDefaultSubstituteIdentity";
        this.swarm("updateDefaultSubstituteIdentityPhase");
    },


    removeIdentity: function(identity){
        if (identity) {
            this.identity = identity;
            this.action = "deleteIdentity";
            this.swarm("deleteIdentity");
        }
        else {
            this.error = new Error("identity id (email) was not provided for create");
            this.swarm("error");
        }
    },

    listDomains: function(){
        var availableDomains = [{
                name:thisAdapter.config.Core.operandoHost,
                id:thisAdapter.config.Core.operandoHost.split(".")[0]
            }];
        this.domains = availableDomains;
        this.home("gotDomains");
    },

    addIdentity: {
        node: "IdentityManager",
        code: function () {
            var self = this;
            self.identity['userId'] = this.meta.userId;
            createIdentity(self.identity, S(function (err, identity) {
                if (err) {
                    self.error.message = err.message;
                    self.swarm("error");
                }
                else {
                    self.identity = identity;
                    self.swarm("success");
                    self.swarm("checkUserNotifications");
                }
            }));
        }
    },

    checkUserNotifications:{
        node:"NotificationUAM",
        code:function(){
            clearIdentityNotifications(this.meta.userId);
        }
    },

    checkUserIdentities:{
        node:"IdentityManager",
        code: function(){
            var self = this;
            getIdentities(self.meta.userId, S(function (err, identities) {
                if (err) {
                    self.error.message = err.message;
                    self.swarm("error");
                }
                else {
                    self.identities = identities;

                    if(self.identities.length >= 20){
                        self.error.message = "You reached the maximum number of substitute identities!";
                        self.swarm("error");
                    }
                    else{
                        self.swarm("addIdentity");
                    }
                }
            }))
        }
    },

    deleteIdentity:{
        node: "IdentityManager",
        code: function () {
            var self = this;
            self.identity['userId'] = this.meta.userId;
            deleteIdentity(self.identity, S(function (err, defaultIdentity) {
                if (err) {
                    self.error.message = err.message;
                    self.swarm("error");
                }
                else {
                    self.default_identity = defaultIdentity;
                    self.swarm("success");
                }
            }));
        }
    },

    getUserIdentities:{
        node:"IdentityManager",
        code: function(){
            var self = this;
            getIdentities(self.meta.userId, S(function (err, identities) {
                    if (err) {
                        self.error.message = err.message;
                        self.swarm("error");
                    }
                    else {
                        self.identities = identities;
                        self.swarm("success");
                    }
                })
            );
        }
    },

    generateIdentityPhase: {
        node: "IdentityManager",
        code: function () {
            var self = this;
            generateIdentity(S(function(err, identity){
                if(err){
                    self.error.message = err.message;
                    self.swarm("error");
                }
                else{
                    self.generatedIdentity = identity;
                    self.swarm("success");
                }
            }));
        }
    },

    updateDefaultSubstituteIdentityPhase: {
        node: "IdentityManager",
        code: function () {
            var self = this;
            self.identity['userId'] = this.meta.userId;
            setDefaultIdentity(self.identity, S(function (err, identity) {
                if (err) {
                    self.error = err;
                    self.swarm("error");
                }
                else {
                    self.identity = identity;
                    self.home("defaultIdentityUpdated");
                }
            }));
        }
    },

    getRealEmail:function(proxy){
        this.proxy = proxy;
        this.action = "getRealEmail";
        this.swarm("getUserIdWithProxy");
    },
    getUserIdWithProxy:{
        node: "IdentityManager",
        code: function () {
            if(this.proxy==='support@'+thidAdapter.config.core.operandoHost){
                /*
                For this particular proxy the emails must be forwarded to multiple destinations.
                A little confusing and ugly, but just ignore it.
                 */
                this.realEmail = thisAdapter.config.Core.supportTeam;
                this.home('gotRealEmail')
                return;
            }
            else if(this.proxy==="contact@"+thisAdapter.config.Core.operandoHost) {
                this.realEmail = thisAdapter.config.Core.adminEmail;
                this.home('gotRealEmail')
                return
            }

            var self = this;
            getUserId(this.proxy,S(function(err, userId){
                if(err){
                    self.error.message = err.message;
                    self.swarm("error");
                }
                else{
                    self.userId = userId;
                    self.swarm("getUserEmail");
                }
            }));
        }
    },
    getUserEmail:{
        node: "UsersManager",
        code: function () {
            var self = this;
            getUserInfo(this.userId,S(function(err, userInfo){
                if(err){
                    self.error = err;
                }
                else{
                    self.realEmail = userInfo.email;
                }
                self.home("gotRealEmail");
            }));
        }
    },

    getId:function(email){
        this.email = email;
        this.swarm("getIdForEmail");
    },

    getIdForEmail:{
        node: "UsersManager",
        code: function () {
            var self = this;
            getUserId(this.email,S(function(err, userInfo){
                if(err){
                    self.error = err;
                }
                else{
                    self.id = userInfo.id;
                }
                self.home("gotId");
            }));
        }
    },

    success: {
        node: "Core",
        code: function () {
            this.home(this.action + "_success");
        }
    },

    error:{
        node: "Core",
        code: function(){
            console.log("Identity swarm error", this.error);
            this.home(this.action + "_error");
        }
    }
};

identitySwarming;
