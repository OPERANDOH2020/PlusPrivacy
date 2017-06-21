/*
 * Copyright (c) 2017 ROMSOFT.
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
core.createAdapter("OSPAdapter");
var persistence = undefined;
var container = require("safebox").container;
var flow = require("callflow");
var uuid = require('uuid');


function registerModels(callback){
    var models = [
        {
            modelName:"OspDetails",
            dataModel : {
                userId: {
                    type: "string",
                    index: true,
                    pk: true,
                    length:254
                },
                name: {
                    type: "string",
                    length:254
                },
                phone: {
                    type: "string",
                    length:30
                },
                website: {
                    type: "string",
                    index: true,
                    length:128
                },
                deals_description: {
                    type: "string",
                    length:2048
                },
                osp_accepted_time:{
                    type:"datetime"
                }
            }
        },
        {
            modelName:"OspOffer",
            dataModel : {
                userId: {
                    type: "string",
                    index: true,
                    length:254
                },
                offerId:{
                    type: "string",
                    index: true,
                    pk:true,
                    length:254
                },
                name: {
                    type: "string",
                    length:254
                },
                logo:{
                    type: "base64image"
                },
                description: {
                    type: "string",
                    length:5000
                },
                start_date:{
                    type:"datetime"
                },
                end_date:{
                    type:"datetime"
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

container.declareDependency("OSPAdapter", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
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



registerNewOSP = function (userId, ospDetailsData, callback) {
    flow.create("register new OSP", {
        begin: function () {
            persistence.lookup("OspDetails", userId, this.continue("createOSP"));
        },
        createOSP: function (err, ospDetails) {
            if (err) {
                callback(err, null);
            }
            else if (!persistence.isFresh(ospDetails)) {
                callback(new Error("OspAlreadyRegistered"), null);
            }
            else {
                ospDetails['osp_accepted_time'] = new Date();
                delete ospDetailsData['request_time'];
                persistence.externalUpdate(ospDetails, ospDetailsData);
                persistence.saveObject(ospDetails, callback);
            }
        }
    })();
};

getOSPs = function(callback){
    flow.create("getOSPs",{
        begin:function(){
            persistence.filter("OspDetails",{},callback);
        }
    })();
};


addOrUpdateOspOffer = function (ospUserId, offerDetails, callback){
    flow.create("addOspOffer", {
        begin: function () {
            persistence.lookup("OspDetails", ospUserId, this.continue("checkOspOffer"));
        },
        checkOspOffer: function (err, osp) {
            if (err) {
                callback(err);
            }
            else if (persistence.isFresh(osp)) {
                callback(new Error("ospUserDoestNotExists"));
            }
            else {
                this.next("createOspOfferId");
            }
        },

        createOspOfferId: function () {
            var ospOfferId;
            if(offerDetails.offerId){
                ospOfferId = offerDetails.offerId;
            }
            else{
                ospOfferId = uuid.v1().split("-").join("");
            }
            persistence.lookup("OspOffer", ospOfferId, this.continue("createOspOffer"));
        },
        createOspOffer: function (err, ospOffer) {
            if (err) {
                callback(new Error("Could not retrieve ospOffer by id"));
            } else
            {
                var offerEndDate = new Date(offerDetails['end_date']);
                offerEndDate.setHours(23,59,59,999);
                offerDetails['start_date'] = new Date(offerDetails['start_date']);
                offerDetails['end_date'] = offerEndDate;
                persistence.externalUpdate(ospOffer, offerDetails);
                ospOffer['userId'] = ospUserId;
                persistence.saveObject(ospOffer, callback);
            }
        }
    })();
};

deleteOspOffer = function (offerId, callback) {

    flow.create("delete osp offer", {
        begin: function () {
            if (!offerId) {
                callback(new Error("offerIdRequired"));
            }
            else {
                persistence.lookup("OspOffer", offerId, this.continue("deleteOffer"));
            }
        },
        deleteOffer: function (err, offer) {
            if (err) {
                callback(err);
            }
            else if (persistence.isFresh(offer)) {
                callback(new Error("ospOfferDoesNotExists"));
            }
            else {
                persistence.deleteById("OspOffer", offerId, callback);
            }
        }
    })();
};

getOspOffers = function(ospUserId, callback){
    flow.create("getOSPOffers",{
        begin:function(){
            persistence.filter("OspOffer",{userId:ospUserId},callback);
        }
    })();
};


getOSPOffer = function(offerId,callback){
    flow.create("getOSPOffer",{
        begin:function(){
            persistence.lookup("OspOffer",offerId,this.continue("checkOffer"));
        },
        checkOffer:function(err, offer){
            if(persistence.isFresh(offer)){
                callback(new Error("Offer not found"));
            }
            else{
                persistence.lookup("OspDetails",offer.userId, function(err, ospDetails){
                    if(err){
                        callback(err);
                    }
                    else if(persistence.isFresh(ospDetails)){
                        callback(new Error(("OSPDetails with this userId not found")));
                    }
                    else{
                        offer['website'] = ospDetails['website'];
                        callback(null, offer);
                    }
                });
            }
        }
    })();
};

getAllOffers = function(callback){
    var availableOffers = [];
    flow.create("getAllOffers",{
        begin:function(){
            persistence.filter("OspOffer",{},this.continue("checkDate"));
        },
        checkDate:function(err, offers){
            if(err){
                callback(err);
            }
            else{
                var currentDate = new Date();
                availableOffers = offers.filter(function(offer){
                    return (currentDate >= offer['start_date'] && currentDate <= offer['end_date']);
                });

                this.next("getOSPDetails");

            }
        },
        getOSPDetails:function(){
            var size = availableOffers.length;
            if(size === 0){
                callback(null,availableOffers);
            }
            else{
                availableOffers.forEach(function(offer){
                    persistence.lookup("OspDetails",offer.userId, function(err, ospDetails){
                        size --;
                        if(!persistence.isFresh(ospDetails)){
                            offer['website'] = ospDetails['website'];
                        }
                        if(size === 0){
                            callback(null,availableOffers);
                        }
                    });
                });
            }

        }

    })();
};

websiteHasOffers = function(website,callback){
    flow.create("getWebsiteOffers",{
        begin:function(){
            persistence.filter("OspDetails",{website:website},this.continue("checkAvailableDeals"));
        },
        checkAvailableDeals:function(err, ospDetails){

            if(err){
                callback(err, null);
            }
            else{
                if(ospDetails.length === 0){
                    callback(null, {hasOffers: false});
                }
                else{
                    var osp = ospDetails[ospDetails.length-1];
                    persistence.filter("OspOffer",{userId:osp.userId},this.continue("checkDate"));
                }
            }
        },
        checkDate:function(err, offers){
            if(err){
                callback(err);
            }
            else{

              var currentDate = new Date();
              var availableOffers = offers.filter(function(offer){
                    return (currentDate >= offer['start_date'] && currentDate <= offer['end_date']);
                });
                if(availableOffers.length>0){
                    callback(null, {hasOffers: true, offers: availableOffers});
                }
                else{
                    callback(null, {hasOffers: false});
                }

            }
        }

    })();
}