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
var swarmService = require("swarm-service").swarmService;
var portObserversPool = require("observers-pool").portObserversPool;
var bus = require("bus-service").bus;

var busActions = {
    //TODO refactor this
    login: function(request, handleResponse){

        login(request.message.login_details, function (swarmPhase, response) {

            handleResponse({
                type: "SOLVED_REQUEST",
                action: request.action,
                message: {error: response.error}
            });

        }, function () {
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
        });
    },

    logout : function (request, handleResponse) {

        logout(function () {
                handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
        });
    },

    notifyWhenLogout : function(request, handleResponse){
        authenticationService.disconnectUser(function(){
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
        });
    },

    getCurrentUser: function(request, handleResponse){

        getCurrentUser(function (user) {
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: user});
        })
    },

    restoreUserSession: function(request, handleResponse){

        restoreUserSession(function (status) {
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: status});
        })
    },
    registerUser: function(request, handleResponse){

        authenticationService.registerUser(request.message.user, function(error){
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {status:"error",message:error}});
        },  function(success){
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {status:"success"}});
        });
    },

    sendActivationCode: function (request, handleResponse) {
        authenticationService.resendActivationCode(request.message, function () {
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {status: "success"}});

        }, function (error) {
            handleResponse({
                type: "SOLVED_REQUEST",
                action: request.action,
                message: {status: "error", message: error}
            });
        });
    },

    resetPassword:function(request, handleResponse){
        authenticationService.resetPassword(request.message, function(){
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {status:"success"}});
        }, function(error){
            handleResponse({type: "SOLVED_REQUEST", action: request.action, message: {status:"error",message:error}});
        });
    }
};



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
                clientPort = null;

            });

            swarmService.onReconnect(function () {
                if (clientPort != null) {
                    clientPort.postMessage({type: "BACKGROUND_DEMAND", action: "onReconnect", message: {}});
                }
            });

            swarmService.onConnectionError(function () {
                if (clientPort != null) {
                    clientPort.postMessage({type: "BACKGROUND_DEMAND", action: "onConnectionError", message: {}});
                }
            });

            swarmService.onConnect(function () {
                if (clientPort != null) {
                    clientPort.postMessage({type: "BACKGROUND_DEMAND", action: "onConnect", message: {}});
                }
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
                        console.log("PORT negasit");
                    }
                    return;
                }

                if(busActions[request.action]){
                        var handleResponse = function(message){
                            if(clientPort){
                                clientPort.postMessage(message);
                            }
                            else{
                                console.log("CLIENTPORT IS NULL. Trying latest port...");
                                chrome.runtime.sendMessage(message,function(response){
                                });
                            }
                        };

                    var action = busActions[request.action];
                        action(request, handleResponse);
                }

                else {
                    if(bus.hasAction(request.action)){
                        var actionFn = bus.getAction(request.action);
                        var args = [];

                        var messageType = "SOLVED_REQUEST";
                        if(request.message && request.message.messageType === "SUBSCRIBER"){
                            messageType = "BACKGROUND_DEMAND";
                        }

                        else if(request.message!== undefined && (typeof request.message!=="object" && typeof request.message !== null || Object.keys(request.message).length > 0)){
                            args.push(request.message);
                        }

                        args.push(function(data){
                            var response = data;
                            if (clientPort) {
                                clientPort.postMessage({
                                    type: messageType,
                                    action: request.action,
                                    message: {status: "success", data: response}
                                });
                            }
                        });

                        args.push(function (err) {
                            if (clientPort) {
                                clientPort.postMessage({
                                    type: messageType,
                                    action: request.action,
                                    message: {error: err.message ? err.message : err}
                                });
                            }
                        });

                        actionFn.apply(actionFn, args);

                    } else{
                        console.log("Error: Unable to process action",request.action);
                    }
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
        }
        else if(clientPort.name === "applyFacebookSettings" || clientPort.name === "applyLinkedinSettings"
            || clientPort.name === "applyTwitterSettings"){
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


function login(login_details, securityErrorFunction, successFunction) {
    authenticationService.authenticateUser(login_details, securityErrorFunction, successFunction);
}

function logout(callback) {
    authenticationService.logoutCurrentUser(callback);
}

function getCurrentUser(callback) {
    authenticationService.getCurrentUser(function (user) {
        callback(user);
    })
}

function restoreUserSession(callback) {
    var status = {};

    //TODO refactoring needed here

    if (authenticationService.isLoggedIn() == true) {
        status.success = "success";
        if(callback){
            callback(status);
        }
    }
}

//TODO rewrite this
authenticationService.restoreUserSession(function () {
    status.success = "success";

}, function () {
    status.fail = "fail";

}, function () {
    status.error = "error";

}, function () {
    status.reconnect = "reconnect";

});