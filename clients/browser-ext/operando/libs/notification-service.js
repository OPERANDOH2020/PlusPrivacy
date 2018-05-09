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
var deviceService = require("device-service").deviceService;

var notificationService = exports.notificationService = {

    getNotifications: function (callback) {
        var getNotificationHandler = swarmHub.startSwarm('notification.js', 'getNotifications');
        getNotificationHandler.onResponse("gotNotifications", function(swarm){
            callback(swarm.notifications);
        });
    },
    dismissNotification:function(notificationData, callback){
        var dismissNotificationHandler = swarmHub.startSwarm("notification.js", "dismissNotification", notificationData.notificationId);
        dismissNotificationHandler.onResponse("notificationDismissed", function(){
            callback();
        })
    },
    registerForPushNotifications:function(){
        var plusprivacyGCMId = ["276859564715"];
        if(chrome.gcm){
            chrome.gcm.register(plusprivacyGCMId,function(pushNotificationId){
                deviceService.getDeviceId(function(deviceId){
                    swarmHub.startSwarm("UDESwarm.js", "updateNotificationToken", deviceId, pushNotificationId);
                });
            })
        }
        else{
            //TODO implement it for other browsers
        }

    },
    notificationReceived:function(callback){
        if(chrome.gcm){
            chrome.gcm.onMessage.addListener(callback)
        }
        else{
            //TODO implement it for other browsers
        }


    }
};
bus.registerService(notificationService);