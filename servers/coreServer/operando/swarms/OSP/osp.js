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


var osp = {
    meta: {
        name: "osp.js"
    },

    getRequests: function () {
        this.swarm("getOspRequestsFromManager");
    },

    removeOSPRequest:function(ospUserId, feedbackMessage){
        this.feedbackMessage = feedbackMessage;
        this.ospUserId = ospUserId;
        this.swarm("removeOspRequestPhase");
    },

    acceptOSPRequest:function(ospUserId){
        this.ospUserId = ospUserId;
        this.swarm("retrieveOspRequestDataPhase");
    },

    listOSPs:function(){
        this.swarm("listOSPsPhase");
    },
    listOSPOffers:function(){
        this.userId = this.meta.userId;
        this.swarm("listOSPOffersPhase");
    },
    addOspOffer:function(offerDetails){
        this.userId = this.meta.userId;
        this.offerDetails = offerDetails;
        this.swarm("checkOfferId");
    },
    deleteOspOffer:function(offerId){
      this.offerId = offerId;
      this.swarm("deleteOspOfferPhase");
    },

    getOffersStats:function(ospId){
        this.ospId = ospId;
        this.swarm("getOSPOffers");
    },
    getCurrentUserOffers:function(){
        this.ospId = this.meta.userId;
        this.swarm("getOSPOffers");
    },
    getOfferStatistics:function(offerId){
        this.ospId = this.meta.userId;
        this.offerId = offerId;
        this.swarm("verifyOfferOwner");

    },
    getOspRequestsFromManager: {
        node: "OSPRequests",
        code: function () {
            var self = this;
            getOSPRequests(S(function(err, ospRequests){
                if(err){
                    self.error = err.message;
                    self.home("failed");
                }
                else{
                    self.ospRequests = ospRequests;
                    self.swarm("getRequestersEmails");
                }
            }));
        }
    },

    retrieveOspRequestDataPhase: {
        node: "OSPRequests",
        code: function () {
            var self = this;
            getOSPRequest(self.ospUserId, S(function (err, ospDataRequests) {
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                }
                else {
                    if (ospDataRequests.length > 0) {

                        var requestData = ospDataRequests[0];
                        delete requestData['__meta'];
                        self.requestData = requestData;
                        self.swarm("acceptOspRequestPhase");
                    }
                    else {
                        self.error = "noRequestsFoundForThisUser";
                        self.home("failed");
                    }
                }
            }));
        }
    },

    removeOspRequestPhase:{
        node:"OSPRequests",
        code:function(){
            var self = this;
            removeOSPRequest(this.ospUserId, S(function(err, ospRequest){
                if(err){
                    self.error = err.message;
                    self.home("failed");
                }else{
                    self.swarm("getUserEmailAndSendFeedback");
                }
            }));
        }
    },

    getUserEmailAndSendFeedback:{
      node:"UsersManager",
      code:function(){
          var self = this;
          getUserInfo(self.ospUserId, S(function(err, user){
              if(err){
                  console.log(err)
              }
              else{
                  startSwarm("emails.js", "sendEmail", "no-reply@" + thisAdapter.config.Core.operandoHost,
                      user['email'],
                      "Your OSP request was not accepted",
                      "Unfortunately your request was not accepted. Below is the reason :  \n" +self.feedbackMessage);

                  self.home("success");
              }
          }));
      }
    },

    removeAcceptedOspMembershipRequestPhase:{
        node:"OSPRequests",
        code:function(){
            var self = this;
            removeOSPRequest(this.ospUserId, S(function(err, ospRequest){
                if(err){
                    self.error = err.message;
                    self.home("failed");
                }else{
                    self.home("success");
                }
            }));
        }
    },

    acceptOspRequestPhase:{
      node:"OSPAdapter",
        code:function(){
            var self = this;
            registerNewOSP(self.ospUserId, self.requestData, S(function(err, ospRequest){
                if(err){
                    self.error = err.message;
                    self.home("failed");
                }
                else{

                    self.ospRequesterId = ospRequest.userId;
                    self.swarm("getUserEmailAndSendMembershipAcceptance");
                }
            }));
        }
    },

    getUserEmailAndSendMembershipAcceptance:{
        node:"UsersManager",
        code:function(){
            var self = this;
            getUserInfo(self.ospRequesterId, S(function(err, user){
                if(err){
                    console.log(err)
                }
                else{
                    var loginUrl = thisAdapter.config.PlusPrivacy.OSPHost+"/#/login";
                    startSwarm("emails.js", "sendEmail", "no-reply@" + thisAdapter.config.Core.operandoHost,
                        user['email'],
                        "Your OSP request was accepted",
                        "Congratulations,\n" +
                        "Your OSP request was accepted\n" +
                        "<p>Login at <a href=\""+loginUrl+"\">"+loginUrl+"</a> and start using the service</p>");

                    self.swarm("changeUserOrganisation");
                }
            }));

        }
    },

    changeUserOrganisation:{
        node:"UsersManager",
        code:function(){
            var self = this;
            var updateData = {
                userId:self.ospUserId,
                organisationId:"OSP"
            };

            updateUser(updateData, S(function (err, user) {
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                } else {
                    self.swarm("removeAcceptedOspMembershipRequestPhase");
                }
            }));
        }
    },

    getRequestersEmails: {
        node: "UsersManager",
        code: function () {
            var self = this;
            var emailsRetrieved = 0;
            var emailToBeRetrieved = self.ospRequests.length;
            if(self.ospRequests.length>0){
                for (var i = 0; i < self.ospRequests.length; i++) {
                    (function (index) {
                        getUserInfo(self.ospRequests[index].userId, S(function (err, user) {
                            if (err) {
                                console.error(err);
                                emailToBeRetrieved--;
                            } else if (user === null) {
                                //orphan case
                                emailToBeRetrieved--;
                            }
                            else {
                                self.ospRequests[index]['email'] = user['email'];
                                emailsRetrieved++;
                            }

                            if(emailsRetrieved === emailToBeRetrieved){
                                self.home("success");
                            }

                        }));
                    })(i);
                }
            }
            else{
                self.home("success");
            }
        }
    },

    listOSPsPhase: {
        node: "OSPAdapter",
        code: function () {
            var self = this;
            getOSPs(S(function (err, ospList) {
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                } else {
                    ospList.forEach(function(osp){
                        delete osp["__meta"];
                    });

                    self.ospList = ospList;
                    if(self.ospList.length === 0){
                        self.home("success");
                    }
                    else{
                        self.swarm("getOSPsEmails");
                    }

                }
            }))
        }
    },

    listOSPOffersPhase:{
        node: "OSPAdapter",
        code: function () {
            var self = this;
            getOspOffers(self.userId, S(function (err, offers) {
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                } else {
                    offers.forEach(function(offer){
                       delete offer["__meta"];
                    });
                    self.offers = offers;
                    self.swarm("checkIfModifiable");
                }
            }));
        }
    },

    checkIfModifiable:{
        node:"PrivacyForBenefitsManager",
        code:function(){
            var offersNumber = this.offers.length-1;
            var self = this;

            var checkOffer = function(offersNumber){
                if(offersNumber == -1){
                    return;
                }
                else {
                    getOSPAcceptedOffers(self.offers[offersNumber].offerId, S(function (err, acceptedOffers) {
                        if (err) {
                            console.log(err);
                        }
                        self.offers[offersNumber].isModifiable = (acceptedOffers.length === 0);

                        offersNumber--;
                        checkOffer(offersNumber);
                    }));
                }
            };

            checkOffer(offersNumber);
            self.home("success");
        }
    },

    getOSPsEmails: {
        node: "UsersManager",
        code: function () {
            var self = this;
            var emailsRetrieved = 0;
            var emailToBeRetrieved = self.ospList.length;
            for (var i = 0; i < self.ospList.length; i++) {
                (function (index) {
                    getUserInfo(self.ospList[index].userId, S(function (err, user) {

                        if (err) {
                            console.error(err);
                            emailToBeRetrieved--;
                        }
                        else if (user === null) {
                            //orphan case
                            emailToBeRetrieved--;
                        } else {
                            self.ospList[index]['email'] = user['email'];
                            emailsRetrieved++;
                        }
                        if(emailsRetrieved === emailToBeRetrieved){
                            self.home("success");
                        }

                    }));
                })(i);
            }
        }
    },

    checkOfferId:{
        node:"PrivacyForBenefitsManager",
        code: function () {
            var self = this;
            if (this.offerDetails.offerId) {
                getOSPAcceptedOffers(this.offerDetails.offerId, S(function (err, acceptedOffers) {
                    if (acceptedOffers.length > 0) {
                        self.error = "offerAlreadyHasDeals";
                        self.home("failed");
                    }
                    else {
                        self.swarm("createOspOffer");
                    }
                }));
            }
            else {
                self.swarm("createOspOffer");
            }
        }
    },
    createOspOffer: {
        node: "OSPAdapter",
        code: function () {
            var self = this;
            addOrUpdateOspOffer(self.userId, self.offerDetails, S(function (err, offer) {
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                }
                else {
                    delete offer["__meta"];
                    self.offer = offer;
                    self.home("success");
                }
            }));
        }
    },

    deleteOspOfferPhase:{
        node: "OSPAdapter",
        code: function () {
            var self = this;
            deleteOspOffer(self.offerId, S(function(err, offer){
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                }
                else {
                    self.offer = offer;
                    self.home("success");
                }
            }));
        }
    },

    getOSPOffers:{
        node:"OSPAdapter",
        code: function(){
            var self = this;
            getOspOffers(self.ospId, S(function (err, offers) {
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                }
                else {
                    self.offersStats = offers;
                    self.swarm("getAcceptedDeals");
                }
            }));
        }
    },
    getAcceptedDeals:{
        node:"PrivacyForBenefitsManager",
        code:function(){
            var offersNumber = this.offersStats.length-1;
            var self = this;

            var checkOffer = function(offersNumber){
                if(offersNumber == -1){
                    return;
                }
                else {
                    getOSPAcceptedOffers(self.offersStats[offersNumber].offerId, S(function (err, acceptedOffers) {
                        if (err) {
                            console.log(err);
                        }
                        if (acceptedOffers.length > 0) {
                            self.offersStats[offersNumber].deals_number = acceptedOffers.length;
                        }
                        else {
                            self.offersStats.splice(offersNumber, 1);
                        }
                        offersNumber--;
                        checkOffer(offersNumber);
                    }));
                }
            };

            checkOffer(offersNumber);
            this.home("success");
        }
    },

    getOfferAcceptedDeals:{
        node:"PrivacyForBenefitsManager",
        code:function(){
            var self = this;
                getOSPAcceptedOffers(self.offerId, S(function(err, acceptedOffers){
                    if(err){
                        console.log(err);
                    }

                    self.offerStats = [];
                    var start_date = new Date(self.offer['start_date']);
                    while(start_date < new Date(self.offer['end_date'])){
                        var currentDate = {
                            time:start_date.toDateString(),
                            impact:0
                        };
                        start_date.setDate(start_date.getDate()+1);
                        for(var i = 0; i<acceptedOffers.length; i++){
                            if(acceptedOffers[i]['accepted_date']<start_date){
                                currentDate.impact = +1;
                                acceptedOffers.splice(i,1);
                                i--;
                            }
                        }
                        self.offerStats.push(currentDate);

                    }
                    self.home("success");
                }));
        }
    },

    verifyOfferOwner:{
        node:"OSPAdapter",
        code:function(){
            var self = this;
            getOspOffers(self.ospId,S(function(err, offers){
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                }
                else {
                    self.offer = offers.find(function(offer){
                        return offer.offerId === self.offerId;
                    });
                    if(self.offer){
                        self.swarm("getOfferAcceptedDeals");
                    }
                    else{
                        self.error = ("noOfferFound");
                        self.home("failed");
                    }

                }
            }));
        }
    }


};
osp;