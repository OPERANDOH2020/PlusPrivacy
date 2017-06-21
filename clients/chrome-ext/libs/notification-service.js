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
    registerForPushNotifications:function(success_callback,error_callback){
        var plusprivacyGCMId = ["276859564715"];
        chrome.gcm.register(plusprivacyGCMId,function(pushNotificationId){
            chrome.storage.local.get("deviceId",function(response){
                if(!response){
                    error_callback(new Error("The device id was not set yet"));
                }else {
                    var handler = swarmHub.startSwarm("UDESwarm.js", "updateNotificationToken", response.deviceId, pushNotificationId);

                    handler.onResponse("Notification Identifier Registered",function (swarm) {
                        success_callback(swarm);
                    });
                    handler.onResponse("failed",function (swarm) {
                        error_callback(swarm.err);
                    });
                }
            })
        })
    },
    notificationReceived:function(callback){
        chrome.gcm.onMessage.addListener(callback)
    },
    associateUserWithDevice:function(success_callback,error_callback){
        chrome.storage.local.get("deviceId",function(response){
            if(!response.deviceId) {
                response.deviceId = new Date().getTime().toString(16) + Math.floor(Math.random() * 10000).toString(16);
            }
        
            var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",response.deviceId);
            handler.onResponse("Device Registered",function (swarm) {
                console.log("Device id is: ",response.deviceId);
                chrome.storage.local.set({"deviceId":response.deviceId});
                success_callback();

            });

            handler.onResponse("failed",function (swarm) {
                error_callback(swarm.err);
            });
        });
    },
    disassociateUserWithDevice:function(success_callback,error_callback){
        /*
        There is a little bug here. However, in the next version this feature will disappear so there is no point in trying to fix it at the moment.
         */
        chrome.storage.local.get("deviceId",function(response){
            
            var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",response.deviceId,true);
            handler.onResponse(function (swarm) {
                if(swarm.err){
                    error_callback(swarm.err)
                }else{
                    success_callback(deviceId)
                }
            })
        })
    }
};
bus.registerService(notificationService);