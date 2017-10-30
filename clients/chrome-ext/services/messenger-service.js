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
        var notificationsRequest = {};

        var responseHandler = function (response) {
            if (response.type === "NOTIFICATION_REQUESTED") {
                if (response.message && response.message.data.identifier) {
                    var identifier = response.message.data.identifier;
                    if (notificationsRequest[response.action]) {
                        if (notificationsRequest[response.action][identifier]) {
                            while (notificationsRequest[response.action][identifier].length > 0) {
                                var callback = notificationsRequest[response.action][identifier].pop();
                                callback(identifier);
                            }
                        }
                    }
                }
            } else if (response.type === "SOLVED_REQUEST") {
                if (response.action && callbacks[response.action]) {
                    while (callbacks[response.action].length > 0) {
                        var messageCallback = callbacks[response.action].pop();
                        messageCallback(response.message);
                    }
                }
            }
            else if (response.type === "BACKGROUND_DEMAND") {
                if (response.action && events[response.action]) {
                    events[response.action].forEach(function (callback) {
                        callback(response.message);
                    });
                }
            }
        };

        var on = function (event, callback) {
            if (!events[event]) {
                events[event] = [];
            }
            events[event].push(callback);
            port.postMessage({action: event, message: {messageType: "SUBSCRIBER"}});
        };

        var off = function (event, callback) {
            if (events[event]) {
                if (callback) {
                    var idx = events[event].indexOf(callback);
                    if (idx != -1) {
                        events[event].splice(idx, 1);
                    }
                }
                else {
                    delete events[event];
                }
            }
        };

        var send = function () {
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

            if (typeof arguments[arguments.length - 1] === "function") {
                callbacks[action].push(arguments[arguments.length - 1]);
            }
        }

        var requestNotification = function (event, identifier, callback) {
            if (!notificationsRequest[event]) {
                notificationsRequest[event] = [];
            }

            if (!notificationsRequest[event][identifier]) {
                notificationsRequest[event][identifier] = [];
            }
            notificationsRequest[event][identifier].push(callback);
            port.postMessage({action: event, message: {messageType: "NOTIFICATION_REQUEST", identifier: identifier}});
        }

        port.onMessage.addListener(responseHandler);
        chrome.runtime.onMessage.addListener(responseHandler);

        return {
            send: send,
            on: on,
            off: off,
            requestNotification: requestNotification
        }

    });