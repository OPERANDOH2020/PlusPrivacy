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


operandoCore
    .factory("messengerService", function () {

        var port = chrome.runtime.connect({name: "OPERANDO_MESSAGER"});
        var callbacks = {};
        var events = {};


        var responseHandler = function (response) {
            console.log(response);
            if (response.type === "SOLVED_REQUEST") {
                if (response.action && callbacks[response.action]) {
                    while (callbacks[response.action].length > 0) {
                        var messageCallback = callbacks[response.action].pop();
                        //console.log(response.message);
                        messageCallback(response.message);
                    }
                }
            }
            else {
                if (response.type === "BACKGROUND_DEMAND") {
                    console.log(response.action);
                    if (response.action && events[response.action]) {
                        events[response.action].forEach(function (callback) {
                            callback(response.message);
                        });
                    }
                }
            }

        };

        var on = function (event, callback) {
            if (!events[event]) {
                events[event] = [];
            }
            events[event].push(callback);
            port.postMessage({action: event, message:{messageType:"SUBSCRIBER"}});
        };

        var off = function (event, callback) {
            if (events[event]) {
                var idx = events[event].indexOf(callback);
                if (idx != -1) {
                    events[event].splice(idx, 1);
                }
            }
        };

        var send = function (){
            var action = arguments[0];

            switch (arguments.length) {
                case 1:
                    port.postMessage({action: action});
                    break;
                case 2:
                    if (typeof arguments[1] === "function") {
                        port.postMessage({action: action});
                    } else {
                        port.postMessage({action: action, message: arguments[1]});
                    }
                    break;
                case 3:
                    port.postMessage({action: action, message: arguments[1]});
                    break;
            }

            if (!callbacks[action]) {
                callbacks[action] = [];
            }

            if(typeof arguments[arguments.length-1] === "function"){
                callbacks[action].push(arguments[arguments.length-1]);
            }
        }

        port.onMessage.addListener(responseHandler);
        chrome.runtime.onMessage.addListener(responseHandler);

        return {
            send: send,
            on: on,
            off:off
        }

    });