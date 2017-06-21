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


var swarmConnection = null;
var connectCallbacks = [];
var reconnectCallbacks = [];
var connectionErrorCallback = [];

function runConnectCallbacks() {
    connectCallbacks.forEach(function (callback) {
        callback();
    });
}

function runReconnectCallbacks() {
    reconnectCallbacks.forEach(function (callback) {
        callback();
    });
}

function runConnectionErrorCallback() {
    connectionErrorCallback.forEach(function (callback) {
        callback();
    });
}


var swarmService = exports.swarmService = {

    initConnection: function (host, port, email, password, tenant, ctor, securityErrorFunction, errorFunction, reconnectCbk, connectCbk) {
        if (errorFunction) {
            this.onConnectionError(errorFunction)
        }

        if (reconnectCbk) {
            this.onReconnect(reconnectCbk);
        }

        if (connectCbk) {
            this.onConnect(connectCbk);
        }

        if (!swarmConnection) {
            swarmConnection = new SwarmClient(host, port, email, password, tenant, ctor, securityErrorFunction, runConnectionErrorCallback, runReconnectCallbacks, runConnectCallbacks);
            swarmHub.resetConnection(swarmConnection);
        }
        else {
            swarmConnection.tryLogin(email, password, tenant, ctor, false, securityErrorFunction, runConnectionErrorCallback, runReconnectCallbacks, runConnectCallbacks);
        }
    },
    restoreConnection: function (host, port, email, sessionId, securityErrorFunction, errorFunction, reconnectCbk, connectCbk) {

        if (errorFunction) {
            this.onConnectionError(errorFunction)
        }

        if (reconnectCbk) {
            this.onReconnect(reconnectCbk);
        }

        if (connectCbk) {
            this.onConnect(connectCbk);
        }


        swarmConnection = new SwarmClient(host, port, email, sessionId, "chromeBrowserExtension", "restoreSession", securityErrorFunction, runConnectionErrorCallback, runReconnectCallbacks, runConnectCallbacks);
        swarmHub.resetConnection(swarmConnection);
    },
    removeConnection: function () {
         swarmConnection.logout();
         swarmConnection = null;
         connectCallbacks = [];
         reconnectCallbacks = [];
         connectionErrorCallback = [];
    },
    onReconnect: function (callback) {
        reconnectCallbacks.push(callback);
    },
    onConnect: function (callback) {
        connectCallbacks.push(callback);
    },
    onConnectionError: function (callback) {
        connectionErrorCallback.push(callback);
    }


};
