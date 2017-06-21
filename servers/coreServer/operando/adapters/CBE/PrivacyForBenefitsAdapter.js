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
core.createAdapter("PrivacyForBenefitsManager");
var persistence = undefined;
var container = require("safebox").container;
var flow = require("callflow");
var voucher_codes = require('voucher-code-generator');


function registerModels(callback){

    var models = [
        {
            modelName: "UserPfB",
            dataModel: {
                id: {
                    type: "string",
                    index: true,
                    pk: true,
                    length: 254
                },
                userId: {
                    type: "string",
                    index: true,
                    length: 254
                },
                pfbId: {
                    type: "string",
                    index: true,
                    length: 254
                },
                voucher: {
                    type: "string",
                    length: 50
                },
                accepted_date: {
                    type: "date"
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

container.declareDependency("PrivacyForBenefitsManager", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
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


/*
websiteHasPfBDeal = function (website) {
    for (var i = 0; i < dummyVendors.length; i++) {
        if (dummyVendors[i].website == website) {
            return true;
        }
    }
    return false;
};

getPfBDeal = function (userId, website, callback) {

    var deal;
    flow.create("getWebsitePfBDeal", {
        begin: function () {
            for (var i = 0; i < dummyVendors.length; i++) {
                if (dummyVendors[i].website == website) {
                    deal = dummyVendors[i];
                    break;
                }
            }

            if (deal) {
                persistence.filter("UserPfB", {userId: userId}, this.continue("checkWebsite"));
            }
            else {
                callback(null, null);
            }
        },

        checkWebsite: function (err, deals) {

            var dealIsAlreadyAccepted = false;

            if (deals && deals.length > 0) {
                for (var i = 0; i < deals.length; i++) {
                    if (deals[i].pfbId == deal.serviceId) {
                        dealIsAlreadyAccepted = true;
                        callback(null, null);
                        break;
                    }
                }

                if(dealIsAlreadyAccepted == false){
                    callback(null, deal);
                }
            }
            else{
                callback(null, deal);
            }

        }

    })();

};

*/

getUserDeals = function (userId, callback) {
    flow.create("get user accepted deals", {
        begin: function () {
            if (!userId) {
                callback(new Error('Empty userId'), null);
            }
            else {
                persistence.filter("UserPfB", {userId: userId}, callback);
            }
        }
    })();
};

saveUserDeal = function (offerId, userId, callback) {
    flow.create("store pfb deal", {
        begin: function () {
            if (!userId) {
                callback(new Error('Empty userId'), null);
            }
            else {
                var deal = {
                    userId: userId,
                    pfbId: offerId
            };
                persistence.filter("UserPfB", deal, this.continue("saveDeal"));
            }
        },

        saveDeal: function (err) {
            if(!err){

                persistence.lookup("UserPfB", generateUUID(), function (err, deal) {

                    if (persistence.isFresh(deal)) {
                        deal.userId = userId;
                        deal.pfbId = offerId;
                        deal.accepted_date = new Date();
                        deal.voucher = voucher_codes.generate({
                                pattern: "###",
                                charset: voucher_codes.charset("alphabetic")
                            })[0].toUpperCase()+" "+voucher_codes.generate({
                                pattern: "#### #### #### #### ####",
                                charset: voucher_codes.charset("numbers")
                            })[0];
                        persistence.saveObject(deal, callback);
                    }
                })

            }
            else{
                console.log("Save deal error",err);
            }
        }
    })();
};


removeUserDeal = function(dealId, userId, callback){
    flow.create("remove pfb deal",{
        begin:function(){
                    var dealData = {
                        userId: userId,
                        pfbId: dealId
                    };

                    persistence.filter("UserPfB", dealData, this.continue("removeDeal"));
        },
        removeDeal:function(err, deals){
            if(err){
                callback(err, null);
            }
            else{//console.log(deals);
                deals.forEach(function(deal){
                    persistence.delete(deal);
                    callback(null,deal);
                })
            }
        }

    })();
};

getOSPAcceptedOffers = function(ospId,callback){
    flow.create("getAcceptedOffers",{
       begin:function(){
            persistence.filter("UserPfB",{pfbId:ospId}, callback);
       }
    })();
};


function generateUUID() {
    var d = new Date().getTime();
    var uuid = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = (d + Math.random()*16)%16 | 0;
        d = Math.floor(d/16);
        return (c=='x' ? r : (r&0x3|0x8)).toString(16);
    });
    return uuid;
}


