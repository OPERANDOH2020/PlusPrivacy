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


var authenticationService = require("authentication-service").authenticationService;
var portObserversPool = require("observers-pool").portObserversPool;
var bus = require("bus-service").bus;

chrome.runtime.onConnect.addListener(function (_port) {
    (function(clientPort){

        portObserversPool.registerPortObserver(clientPort);
        clientPort.onDisconnect.addListener(function(){
            portObserversPool.unregisterPortObserver(clientPort);
            clientPort = null;
        });

        if (clientPort.name === "OPERANDO_MESSAGER" || clientPort.name === "INPUT_TRACKER") {

            /**
             * Listen for swarm connection events
             **/

            clientPort.onDisconnect.addListener(function () {
                console.log("disconnected");
                clientPort = null;

            });

            /**
             * Listen for commands
             **/
            clientPort.onMessage.addListener(function (request) {

                if(request.message && request.message.sendToPort){
                    var desiredPort = portObserversPool.findPortByName(request.message.sendToPort);
                    if(desiredPort){
                        desiredPort.postMessage(request.message);
                    }else{
                        console.log("Port is no longer available");
                    }
                    return;
                }

                    if(bus.hasAction(request.action)){
                        var actionFn = bus.getAction(request.action);
                        var args = [];

                        var messageType = "SOLVED_REQUEST";
                        if(request.message && request.message.messageType === "SUBSCRIBER"){
                            messageType = "BACKGROUND_DEMAND";
                        } else if (request.message && request.message.messageType === "NOTIFICATION_REQUEST") {
                            messageType = "NOTIFICATION_REQUESTED";
                            args.push(request.message);
                        }

                        else if(request.message!== undefined && (typeof request.message!=="object" && typeof request.message !== null || Object.keys(request.message).length > 0)){
                            args.push(request.message);
                        }

                        args.push(function (data) {
                            var response = data;
                            var messageToClient = {
                                type: messageType,
                                action: request.action,
                                message: {"status": "success", "data": response}
                            };

                            if (clientPort) {
                                clientPort.postMessage(messageToClient);
                            } else {
                                console.log("CLIENTPORT IS NULL. Trying latest port...");
                                if(messageToClient.type !== "BACKGROUND_DEMAND"){
                                    chrome.runtime.sendMessage(messageToClient);
                                }

                            }
                        });

                        args.push(function (err) {
                            if(!err){
                                err = "error"
                            }

                            var messageToClient =  {
                                type: messageType,
                                action: request.action,
                                message: {error: err.message ? err.message : err}
                            };

                            if (clientPort) {
                                clientPort.postMessage(messageToClient);
                            } else {
                                console.log("CLIENTPORT IS NULL. Trying latest port...");
                                if(messageToClient.type !== "BACKGROUND_DEMAND"){
                                    chrome.runtime.sendMessage(messageToClient);
                                }
                                chrome.runtime.sendMessage(messageToClient);
                            }
                        });

                        actionFn.apply(actionFn, args);

                    } else{
                        console.log("Error: Unable to process action",request.action);
                    }
            });
        }
        else if(clientPort.name === "PLUSPRIVACY_WEBSITE"){
            clientPort.onMessage.addListener(function (request) {

                if(bus.hasAction(request.action)){
                    var action = bus.getAction(request.action);
                    var args = [];

                    if(request.message){
                        args.push(request.message);
                    }

                    portObserversPool.addPortRequestSubscriber(clientPort, request.action, function(status, response){
                        if (clientPort) {
                            clientPort.postMessage({
                                action: request.action,
                                message: {status: "success", data: response}
                            });
                        }
                    });

                    action.apply(action, args);
                }

            });
        }//TODO
        /*refactor this
         */
        else if(clientPort.name === "applyFacebookSettings" || clientPort.name === "applyLinkedinSettings"
            || clientPort.name === "applyTwitterSettings" || clientPort.name === "applyGoogleSettings"|| clientPort.name === "googleActivityControls"){
            clientPort.onMessage.addListener(function(request){

                if (bus.hasAction(request.action)) {
                    var action = bus.getAction(request.action);
                    var args = [];
                    if (request.data) {
                        args.push(request.data);
                    }
                    action.apply(action, args);
                }
            });
        }
        else if (clientPort.name === "allowSocialNetworkPopup") {
            clientPort.onMessage.addListener(function (request) {
                if (bus.hasAction(request.action)) {
                    var action = bus.getAction(request.action);
                    var args = [];
                    if (request.data) {
                        args.push(request.data);
                    }

                    args.push(function (data) {
                        var response = data;
                        if (clientPort) {
                            clientPort.postMessage({
                                action: request.action,
                                message: {status: "success", data: response}
                            });
                        }
                    });

                    args.push(function (err) {
                        if (clientPort) {
                            clientPort.postMessage({
                                action: request.action,
                                message: {error: err.message ? err.message : err}
                            });
                        }
                    });

                    action.apply(action, args);
                }
            });
        }
    }(_port));

});

//TODO rewrite this
authenticationService.restoreUserSession(function () {
    status.success = "success";

}, function () {
    status.fail = "fail";

}, function () {
    console.log("error");
    status.error = "error";

}, function () {
    status.reconnect = "reconnect";
    console.log("reconnect");

});