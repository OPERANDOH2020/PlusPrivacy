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

var pfbService = exports.pfbService = {

    getAllPfbDeals: function (success_callback) {
        var getAllDealsHandler = swarmHub.startSwarm('pfb.js', 'getAllDeals');
        getAllDealsHandler.onResponse("gotAllDeals", function(swarm){
            success_callback(swarm.deals);
        })
    },

    acceptPfbDeal: function(pfbDealId, success_callback){
        var acceptPfBDeal = swarmHub.startSwarm("pfb.js", "acceptDeal", pfbDealId);
        acceptPfBDeal.onResponse("dealAccepted", function(swarm){
            success_callback(swarm.deal);
        })
    },

    unsubscribePfbDeal: function(pfbDealId, success_callback){
        var unsubscribePfbDealHandler = swarmHub.startSwarm("pfb.js", "unsubscribeDeal", pfbDealId);
        unsubscribePfbDealHandler.onResponse("dealUnsubscribed", function(swarm){
            success_callback(swarm.deal);
        })
    },
    getWebsiteDeal:function(data, success_callback, failCallback){
        var pfbHandler = swarmHub.startSwarm("pfb.js", "getWebsiteOffer", data.tabUrl);
        pfbHandler.onResponse("success", function (swarm) {
            var offer = swarm.offers[0];
            console.log(offer);
            success_callback(offer);
        });

        pfbHandler.onResponse("no_pfb", function (swarm) {
            failCallback("no_pfb");
        });
    }
}

bus.registerService(pfbService);

