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

var webRequest = chrome.webRequest;

var DependencyManager = require("DependencyManager").DependencyManager;
var bus = require("bus-service").bus;

bus.getAction("interceptHeadersResponse")("all-header-responses");
bus.getAction("interceptHeadersBeforeRequest")("change-referer");
bus.getAction("interceptHeadersBeforeRequest")("dropbox");
bus.getAction("interceptHeadersBeforeRequest")("delete-fb-app");

chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {

    if (message.message === "getCookies") {
        if (message.url) {
            chrome.cookies.getAll({url: message.url}, function (cookies) {
                sendResponse(cookies);
            });
            return true;
        }
    }

    if (message.message === "waitForAPost") {
       bus.getAction("interceptSingleRequest")(message.osp,message, sendResponse);
       return true;
    }

    if(message.message ==="waitForHeadersRequest"){
        bus.getAction("interceptHeadersBeforeRequest")(message.osp,message, sendResponse);
        return true;
    }
});


var getDeviceIdAction = bus.getAction("getDeviceId");
getDeviceIdAction(function (deviceId) {
    chrome.runtime.setUninstallURL(ExtensionConfig.UNINSTALL_URL + deviceId);
});

var checkWhiteListedDomains = function (reason) {
    if (reason === "install") {

        chrome.storage.local.get("UserPrefs", function (items) {
            var userPreferences;
            if (typeof items === "object" && Object.keys(items).length === 0) {
                userPreferences = {};
            }
            else {
                userPreferences = JSON.parse(items['UserPrefs']);
            }

            if (userPreferences['whitelisted-domains']) {
                var addFilter = function (domain) {
                    var message = {
                        text: domain,
                        type: "filters.add"
                    };
                    ext.backgroundPage.sendMessage(message);
                };
                var whiteListedDomains = userPreferences['whitelisted-domains'];
                whiteListedDomains.forEach(function (whiteListedDomain) {
                    addFilter(whiteListedDomain);
                });
            }

        });

    }
};

chrome.runtime.onInstalled.addListener(checkWhiteListedDomains);