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
core.createAdapter("IdentityManager");
var persistence = undefined;
var container = require("safebox").container;

var flow = require("callflow");


function registerModels(callback){

    var models = [
        {
            modelName:"Identity",
            dataModel : {
                userId: {
                    type: "string",
                    index: true,
                    length: 254
                },
                email: {
                    type: "string",
                    index: true,
                    pk: true,
                    length:254
                },
                isDefault:{
                    type: "boolean",
                    index: true,
                    default: false
                },
                isReal:{
                    type: "boolean",
                    default: false,
                    index: true
                },
                deleted:{
                    type: "boolean",
                    default: false,
                    index:true
                }
            }
        }
    ];

    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                persistence.registerModel(model.modelName,model.dataModel,self.continue("registerDone"));
            });

        },
        registerDone:function(err,result){
            if(err) {
                this.errs.push(err);
            }
        },
        end:{
            join:"registerDone",
            code:function(){
                if(callback && this.errs.length>0){
                    callback(this.errs);
                }else{
                    callback(null);
                }
            }
        }
    })();
}

container.declareDependency("IdentityManager", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }
        })

    } else {
        console.log("Disabling persistence...");
    }
});


createIdentity = function (identityData, callback){
    identityData.email = identityData.email.toLowerCase();

    flow.create("create identity", {
        begin: function () {
            persistence.lookup.async("Identity", identityData.email, this.continue("createIdentity"));
        },
        createIdentity: function (err, identity) {
            if (err) {
                callback(err, null);
            }
            else {
                if (!persistence.isFresh(identity)) {
                    callback(new Error("Identity already exists"), null);
                }
                else {
                    persistence.externalUpdate(identity, identityData);
                    persistence.saveObject(identity, callback);

                }
            }
        }
    })();
};

generateIdentity = function(callback){
    flow.create("generateIdentity",{
        begin:function(){
            var identity = generateString().toLowerCase();
            persistence.lookup("Identity", identity, this.continue("generateIdentity"));
        },
        generateIdentity: function(err, identity){
            if(persistence.isFresh(identity)){
                callback(null, identity);
            }
            else{
                this.begin();
            }
        }
    })();
};

deleteIdentity = function (identityData, callback) {
    flow.create("remove identity", {
        begin: function () {
            if (!identityData.email) {
                callback(new Error("empty_email"), null);
            }
            else {
                persistence.findById("Identity", identityData.email, this.continue("markAsDeleted"));
            }
        },

        markAsDeleted: function (err, identity) {
            if (err) {
                callback(err, null);
            }
            else if (identity != null) {
                if(identity.isReal === true){
                    callback(new Error("could_not_delete_your_real_identity"), null);
                }
                else{
                    var markDeletedData={
                        deleted:true,
                        isDefault:false
                    };

                    persistence.externalUpdate(identity,markDeletedData);
                    persistence.saveObject(identity, this.continue("getDefaultIdentity"));
                }
            }
            else{
                if(identity == null){
                    callback(new Error("identity_not_exists"), null);
                }
            }
        },
        getDefaultIdentity:function(err, identity){
            persistence.filter("Identity", {isDefault:true, userId:identityData.userId, deleted:false}, this.continue("returnDefaultIdentity"));
        },
        returnDefaultIdentity:function(err, identities){
            if(err){
                console.log(err);
            }
            else{
               if(identities.length === 0){
                   persistence.filter("Identity", {isReal:true, userId:identityData.userId, deleted:false}, this.continue("returnRealIdentity"));
               }
                else{
                   callback(null, identities[0]);
               }
            }
        },
        returnRealIdentity:function(err, identities){
            if(err){
                console.log(err);
            }
            else if(identities.length === 0){
                callback(new Error("User has no real identity"), null);
            }
            else{
                identities[0].isDefault = true;
                persistence.saveObject(identities[0], callback);
            }
        }
    })();
};

getIdentities = function (userId, callback) {
    if (!userId) {
        callback(new Error("userId_is_required"), null);
    }
    else {
        persistence.filter("Identity", {userId: userId, deleted:false}, callback);
    }
};

setDefaultIdentity = function(identity, callback){

    flow.create("set default identity",{
        begin:function(){
            if(!identity){
                callback(new Error("no_identity_provided"), null);
            }
            else {
                persistence.filter("Identity", {isDefault:true, userId:identity.userId, deleted:false}, this.continue("clearCurrentDefaultIdentity"));
            }
        },

        clearCurrentDefaultIdentity:function(err, identities){
            var self = this;
            if(identities.length>0){
                identities.forEach(function(_identity, index){
                    _identity.isDefault = false;
                    (function (index) {
                        persistence.saveObject(_identity, function () {
                            if (index == identities.length-1) {
                                self.next("retrieveCurrentIdentity");
                            }
                        })
                    })(index);
                });
            }
            else {
                self.next("retrieveCurrentIdentity");
            }
        },

        retrieveCurrentIdentity:function(){
            persistence.findById("Identity", identity.email, this.continue("updateNewIdentity"));
        },
        updateNewIdentity:function(err, identity){
            if(err){
                callback(err, null);
            }
            else{
                identity.isDefault = true;
                persistence.saveObject(identity, callback);
            }
        }
    })();
};

setRealIdentity = function(user, callback){

    flow.create("add real identity",{

        begin:function(){
            persistence.lookup.async("Identity", user.email, this.continue("addRealIdentity"));
        },

        addRealIdentity:function(err, identity){
            if(err){
                callback(err, null);
            }
            else{
                if (!persistence.isFresh(identity)) {
                    callback(new Error("This identity already exists"), null);
                }
                else{
                    identity.isReal = true;
                    identity.isDefault = true;
                    identity.userId = user.userId;
                    persistence.saveObject(identity, callback);
                }
            }
        }

    })();
};

changeRealIdentity = function(user, callback){
    flow.create("change real identity",{
       begin: function(){
           var filter = {
               userId:user.userId,
               isReal:true,
               deleted:false
           };

           persistence.filter("Identity", filter, this.continue("changeRealIdentity"));
       },
        changeRealIdentity:function(err, identities){
            if(err){
                callback(err, null);
            }
            else if(identities.length>0){
                var identity = identities[0];
                persistence.delete(identity,function(){
                    identity.email = user.email;
                    persistence.saveObject(identity, callback);
                });
            }
            else {
                persistence.lookup("Identity", user.email, this.continue("createNewIdentity"))
            }
        },
        createNewIdentity:function(err, identity){
            if(err){
                console.log(err);
                callback(err, null);
            }
            else if (persistence.isFresh(identity)) {
                identity['userId'] = user.userId;
                identity['email'] = user.email;
                identity['isDefault'] = false;
                identity['isReal'] = false;
                identity['deleted'] = false;
                persistence.saveObject(identity, callback);
            }
            else{
                console.error("An error occured");
                callback(new Error("An identitiy already exists"), identity);
            }
        }
    })();
};

getUserId = function(proxyEmail,callback){
    persistence.findById("Identity",proxyEmail,function(err,result){
        if(err){
            callback(err);
            return;
        }
        if(result===null ){
            callback(new Error("Proxy "+proxyEmail+" is not registered"));
            return;
        }
        if(result.deleted===true ){
            callback(new Error("Proxy "+proxyEmail+" was deleted"));
            return;
        }
        callback(err,result.userId);
    })
};

deleteUserIdentities = function(userId,callback){

    flow.create("deleteAllIdentities",{
        begin:function(){
            this.errs = [];
            persistence.filter("Identity",{userId:userId},this.continue("deleteIdentities"))
        },
        deleteIdentities: function (err, identities) {
            var self = this;
            if (err) {
                callback(err);
            }
            else if (identities.length > 0) {
                identities.forEach(function (identitiy) {
                    persistence.delete(identitiy, self.continue("waitIdentityDeletion"));
                });
            }
            else {
                callback(null);
            }
        },
        waitIdentityDeletion:function(err, deletedIdentity){
            if(err){
                this.errs.push(err);
            }
        },
        end:{
            join:"waitIdentityDeletion",
            code:function(){
                if(this.errs.length>0){
                    callback(this.errs[0])
                }
                else{
                    callback(null);
                }
            }
        }
    })();

};




function generateString(){
    return Math.floor((1 + Math.random()) * 0x100000000000000)
        .toString(36)
        .substring(1);
}


