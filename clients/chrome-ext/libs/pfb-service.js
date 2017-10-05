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
var currentDeals = false;
var lastUpdate = new Date();
const oneDay = 24*60*60*1000
var pfbService = exports.pfbService = {
    getAllPfbDeals: function (success_callback) {

        if(!currentDeals || (new Date() - lastUpdate > oneDay)){
            var getAllDealsHandler = swarmHub.startSwarm('pfb.js', 'getAllDeals');
            getAllDealsHandler.onResponse("gotAllDeals", function(swarm){
                currentDeals = swarm.deals;
                lastUpdate = new Date();
                success_callback(currentDeals);
            })
        }
        else{
            success_callback(currentDeals)
        }
    },

    acceptPfbDeal: function(pfbDealId, success_callback){
        var acceptPfBDeal = swarmHub.startSwarm("pfb.js", "acceptDeal", pfbDealId);
        acceptPfBDeal.onResponse("dealAccepted", function(swarm){
            success_callback(swarm.deal);

            for(var i = 0; i< currentDeals.length; i++){
                if(currentDeals[i]['offerId'] == pfbDealId){
                    currentDeals[i].subscribed = true;
                    break;
                }
            }

        })
    },

    unsubscribePfbDeal: function(pfbDealId, success_callback){
        var unsubscribePfbDealHandler = swarmHub.startSwarm("pfb.js", "unsubscribeDeal", pfbDealId);
        unsubscribePfbDealHandler.onResponse("dealUnsubscribed", function(swarm){
            for(var i = 0; i< currentDeals.length; i++){
                if(currentDeals[i]['offerId'] == pfbDealId){
                    currentDeals[i].subscribed = false;
                    delete currentDeals[i]['voucher'];
                    break;
                }
            }
            success_callback(swarm.deal);
        })
    },
    getWebsiteDeal:function(data, success_callback, failCallback){
        pfbService.getAllPfbDeals(function(deals){

            var dealsAvailable = deals.filter(function(deal){
                var currentDate = new Date();
                return data.tabUrl.match(getHostName(deal.website)) && (currentDate<deal.end_date) && (currentDate>=deal.startDate)
            });
            
            if(dealsAvailable.length>0){
                success_callback(dealsAvailable[0])
            }else{
                failCallback('no_pfb')
            }
        })
    }
}

function getHostName(url) {
    var match = url.match(/:\/\/(www[0-9]?\.)?(.[^/:]+)/i);
    if (match != null && match.length > 2 && typeof match[2] === 'string' && match[2].length > 0) {
        return match[2];
    }
    else {
        return null;
    }
}



bus.registerService(pfbService);

