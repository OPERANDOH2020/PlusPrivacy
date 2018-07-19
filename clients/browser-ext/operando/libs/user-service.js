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
var userUpdatedObservable = swarmHub.createObservable();
var trackingVerificationsInProgress = 0;
var thirdPartyCookiesVerificationsInProgress = 0;
var browserTrackingImplicitValue = null;
var browserAcceptThirdPartyCookiesImplicitValue = null;
var userService = exports.userService = {

    changePassword:function(changePasswordData, success_callback, error_callback){
        var changePasswordHandler = swarmHub.startSwarm('UserInfo.js', 'changePassword', changePasswordData.currentPassword, changePasswordData.newPassword);
        changePasswordHandler.onResponse("passwordSuccessfullyChanged", function(response){
            success_callback();
        });

        changePasswordHandler.onResponse("passwordChangeFailure", function(response){
            error_callback(response.error);
        });
    },

    userUpdated : function(callback){
        userUpdatedObservable.observe(callback, true);
    },
    getUserPreferences:function(preferenceKey,success_callback, error_callback){
        chrome.storage.local.get("UserPrefs", function (items) {
            var userPreferences;
            if (typeof items === "object" && Object.keys(items).length === 0) {
                userPreferences = {};
            }
            else {
                userPreferences = JSON.parse(items['UserPrefs']);
            }

            var keyPreferences = {};

            if (userPreferences[preferenceKey] !== 'undefined' ) {
                keyPreferences = userPreferences[preferenceKey];
            }
            success_callback(keyPreferences);
        });
    },

    saveUserPreferences:function(data, success_callback, error_callback){
        chrome.storage.local.get("UserPrefs", function (items) {
            var userPreferences;
            if (typeof items === "object" && Object.keys(items).length === 0) {
                userPreferences = {};
            }
            else {
                userPreferences = JSON.parse(items['UserPrefs']);
            }

            userPreferences[data.preferenceKey] = data.preferences;

            chrome.storage.local.set({UserPrefs: JSON.stringify(userPreferences)});
            success_callback(data.preferences);
        });
    },
    removePreferences:function(preferenceKey, success_callback, error_callback){

        chrome.storage.local.get("UserPrefs", function (items) {
            var userPreferences;
            if (typeof items === "object" && Object.keys(items).length === 0) {
                userPreferences = {};
            }
            else {
                userPreferences = JSON.parse(items['UserPrefs']);
            }

            if (userPreferences[preferenceKey]) {
                delete userPreferences[preferenceKey];
                chrome.storage.local.set({UserPrefs: JSON.stringify(userPreferences)},success_callback);
            }else{
                error_callback();
            }
        });
    },

    removeAccount:function(success_callback, error_callback){
        var removeAccountHandler = swarmHub.startSwarm("UserInfo.js", "deleteAccount");

        removeAccountHandler.onResponse("success", function(response){
            success_callback(response);
        });

        removeAccountHandler.onResponse("failed", function(response){
            error_callback(response.error);
        })
    },

    contactMessage:function(data,success_callback, error_callback){
        var contactMessageHandler = swarmHub.startSwarm("contact.js", "sendMessage",data);
        contactMessageHandler.onResponse("success", function(response){
            success_callback();
        });
        contactMessageHandler.onResponse("error", function(response){
            error_callback();
        });
    },

    feedbackMessage:function(feedback, success_callback, error_callback){
        //to preserve the old, more complex feedback form we kept the same format.
        var feedbackRaw = {"Any other feedback?":feedback.message};
        var xhrReq = new XMLHttpRequest();
        xhrReq.addEventListener("load",function(){
            if(this.responseText){
                success_callback(JSON.parse(this.responseText));
            }
            else{
                error_callback("Failed submitting feedback message!");
            }
        });
        var resourceURI = ExtensionConfig.SERVER_HOST_PROTOCOL+"://"+ExtensionConfig.OPERANDO_SERVER_HOST + ":" + ExtensionConfig.OPERANDO_SERVER_PORT+"/feedback/responses";
        xhrReq.open("POST",resourceURI);
        xhrReq.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhrReq.send(JSON.stringify(feedbackRaw));

    },
    resetExtension:function(){
            chrome.storage.sync.clear(function(){
                chrome.storage.local.clear(function(){
                    chrome.runtime.reload();
                });
            });
    },

    verifyTrackingIsDown: function (callback) {
        trackingVerificationsInProgress++;

        userService.verifyThirdPartyCookies(function () {

            if (chrome.privacy && chrome.privacy.websites && chrome.privacy.websites.trackingProtectionMode) {
                 chrome.privacy.websites.trackingProtectionMode.get({},function (got) {

                    if (browserTrackingImplicitValue === null) {
                        browserTrackingImplicitValue = got.value;
                    }

                    if (got.value === "always") {
                        chrome.privacy.websites.trackingProtectionMode.set({
                            value: "private_browsing"
                        },callback);

                    } else {
                        callback();
                    }

                });
            }
            else {
                callback();
            }
        });
    },

    updateTrackingImplicitValue: function () {

        if (chrome.privacy && chrome.privacy.websites && chrome.privacy.websites.trackingProtectionMode) {
            trackingVerificationsInProgress--;
            if (trackingVerificationsInProgress === 0) {
                chrome.privacy.websites.trackingProtectionMode.set({
                    value: browserTrackingImplicitValue
                });
            }
        }

        userService.updateThirdPartyCookiesImplicitValue();

    },


    verifyThirdPartyCookies: function (callback) {

        if (chrome.privacy && chrome.privacy.websites && chrome.privacy.websites.cookieConfig) {

            thirdPartyCookiesVerificationsInProgress++;

            chrome.privacy.websites.cookieConfig.get({},function (got) {

                if (browserAcceptThirdPartyCookiesImplicitValue === null) {
                    browserAcceptThirdPartyCookiesImplicitValue = got.value;
                }

                if (got.value.behavior === "reject_third_party") {
                    chrome.privacy.websites.cookieConfig.set({
                        value: {behavior: "allow_all"}
                    },callback);

                } else {
                    callback();
                }

            });

        }
        else {
            callback();
        }
    },

    updateThirdPartyCookiesImplicitValue:function(){
        if(chrome.privacy && chrome.privacy.websites && chrome.privacy.websites.cookieConfig){
            thirdPartyCookiesVerificationsInProgress--;
            if(thirdPartyCookiesVerificationsInProgress === 0){
                chrome.privacy.websites.cookieConfig.set({
                    value : browserAcceptThirdPartyCookiesImplicitValue
                });
            }
        }
    }

};

bus.registerService(userService);
bus.registerObservers({"userUpdated":userUpdatedObservable});