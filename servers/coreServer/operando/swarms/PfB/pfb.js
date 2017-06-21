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

var parseDomain = require('parse-domain');
var privacyForBenefits = {
    meta: {
        name: "pfb.js"
    },

    vars: {
        deal: null,
        deals: null,
        dealId: null,
        website: null,
        action: null
    },

    getAllDeals:function(){
      this.swarm("listAllPfbDeals");
    },

    acceptDeal: function (dealId) {
        this.dealId = dealId;
        this.swarm("acceptPfBDeal");
    },

    unsubscribeDeal:function(dealId){
        this.dealId = dealId;
        this.swarm("unsubcribePfBDeal");
    },

    getWebsiteOffer: function (_website) {
        var domainParsed = (parseDomain(_website));
        this.website = domainParsed.domain+"."+domainParsed.tld ;
        console.log(this.website);
        this.swarm("websiteHasOffer");
    },
    websiteHasOffer: {
        node: "OSPAdapter",
        code: function () {
            var self = this;
            websiteHasOffers(this.website, S(function (err, offersData) {
                if (err) {
                    console.log(err);
                    self.home("no_pfb");
                }
                else if (offersData['hasOffers'] === false) {
                    self.home("no_pfb");
                }
                else {
                    self.offers = offersData.offers;
                    self.home("success");
                }
            }));
        }
    },
    listAllPfbDeals: {
        node: "OSPAdapter",
        code:function(){
            var self = this;
            getAllOffers( S(function(err, deals){
                if(err){
                    console.log(err);
                }
                else{
                    if(self.meta['tenantId'] === "ios"){
                        self.deals = [];
                        self.home("gotAllDeals");
                    }else{
                        self.deals = deals;
                    }

                    self.swarm("checkUserDeals");
                }
            }));
        }
    },

    checkUserDeals: {
        node: "PrivacyForBenefitsManager",
        code: function () {

            var self = this;
            getUserDeals(self.meta.userId, S(function (err, userDeals) {
                if (err) {
                    console.log(err);
                }
                else {
                    for (var j = 0; j < self.deals.length; j++) {
                        for (var i = 0; i < userDeals.length; i++) {
                            if (userDeals[i].pfbId === self.deals[j].offerId) {
                                self.deals[j].subscribed = true;
                                self.deals[j].voucher = userDeals[i].voucher;
                                break;
                            }
                        }
                        if(!self.deals[j].subscribed){
                            self.deals[j].subscribed = false;
                        }
                    }
                    self.home("gotAllDeals");
                }
            }));
        }
    },


    acceptPfBDeal: {
        node: "PrivacyForBenefitsManager",
        code: function () {
            var self = this;
            saveUserDeal(self.dealId, self.meta.userId,S(function(err, deal){
                if (err) {
                    console.log(err);
                }
                else {
                    self.deal = deal;
                    self.action="subscribed";
                    self.swarm("getService");
                    self.home("dealAccepted");
                    self.swarm("checkUserNotifications");
                }
            }));
        }
    },

    checkUserNotifications:{
        node:"NotificationUAM",
        code:function(){
            clearDealsNotifications(this.meta.userId);
        }
    },


    getService:{
        node:"OSPAdapter",
        code:function(){
            var self = this;
            getOSPOffer(this.deal.pfbId, S(function(err, service){
                 if(err){
                     console.log(err);
                 }
                else{
                     self.service = service;
                     self.swarm("getUserEmail");
                 }
            }));
        }
    },

    getUserEmail:{
        node:"UsersManager",
        code:function(){
            var self = this;
            getUserInfo(this.meta.userId, S(function(err, userInfo){
                if(userInfo && userInfo.email){
                    self['to'] = userInfo.email;
                    self.swarm("notifyUserByEmail");
                }
            }));
        }
    },

    notifyUserByEmail:{
        node: "EmailAdapter",
        code: function () {
            this['from']="deals@PlusPrivacy.com";
            this['subject'] = "PlusPrivacy deal: "+this.service.website;

           if(this.action == "subscribed"){
               this['content'] = "You have successfully subscribed to " + this.service.website+". ";
               this['content'] += "Your voucher is " + this.deal.voucher;
            }
            else{
                this['content'] = "You have successfully unsubscribed to " + this.service.website;
            }

            var self = this;
            sendEmail(self['from'],self['to'],self['subject'],self['content'],S(function(err, deliveryResult){
                delete self['from'];
                delete self['to'];
                delete self['subject'];
                delete self['content'];

                if(err){
                    self.error = err;
                    console.log(err);
                }else{
                    console.log("Pfb email successfully sent");
                }
            }));
        }
    },

    unsubcribePfBDeal:{
        node: "PrivacyForBenefitsManager",
        code: function () {
            var self = this;
            removeUserDeal(self.dealId, self.meta.userId,S(function(err, deal){
                if(!err){
                    self.deal = deal;
                    self.action = "unsubscribed";
                    self.swarm("getService");
                    self.home("dealUnsubscribed");
                }
            }));
        }
    }

}
privacyForBenefits;