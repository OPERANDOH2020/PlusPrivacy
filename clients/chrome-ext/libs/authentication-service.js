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

var swarmService = require("swarm-service").swarmService;
var loggedIn = false;
var authenticatedUser = {};
var loggedInObservable = swarmHub.createObservable();
var notLoggedInObservable = swarmHub.createObservable();

var authenticationService = exports.authenticationService = {

    isLoggedIn: function(){
        return loggedIn;
    },
    getUser : function(){
      return authenticatedUser;
    },
    authenticateUser: function (login_details, securityFn, successFn) {
        var self = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, login_details.email, login_details.password, "chromeBrowserExtension", "userLogin", function(){});
        console.log("Keep session ",login_details.remember_me);

        var loginSuccessfully = function (swarm) {

            if(loggedIn === false){
                self.setUser(successFn);
            }

            loggedIn = swarm.authenticated;

            var daysUntilCookieExpire = 1;
            if(login_details.remember_me === true){
                daysUntilCookieExpire = 365;
            }

            Cookies.set("daysUntilCookieExpire",daysUntilCookieExpire,{expires:3650});
            Cookies.set("sessionId", swarm.meta.sessionId,  { expires: daysUntilCookieExpire });
            Cookies.set("userId", swarm.userId,{ expires: daysUntilCookieExpire });
            swarmHub.off("login.js", "success",loginSuccessfully);
            swarmHub.startSwarm("notification.js","registerInZone", "Extension");

        };

        swarmHub.on('login.js', "success", loginSuccessfully);

        swarmHub.on('login.js', "failed", function loginFailed(swarm) {
            securityFn(swarm.meta.currentPhase, swarm);
            swarmHub.off("login.js", "success",loginSuccessfully);
            swarmHub.off("login.js", "failed",loginFailed);
        });
    },

    registerUser: function (user, errorFunction, successFunction) {

        var self  = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, CONSTANTS.GUEST_EMAIL, CONSTANTS.GUEST_PASSWORD, "chromeBrowserExtension", "userLogin", errorFunction, errorFunction);

        swarmHub.on("login.js", "success_guest", function guestLoginForUserRegistration(swarm){
            swarmHub.off("login.js", "success_guest",guestLoginForUserRegistration);
            if(swarm.authenticated){
                var registerHandler = swarmHub.startSwarm("register.js", "registerNewUser", user);
                registerHandler.onResponse("success", function(swarm){
                    successFunction("success");
                    self.logoutCurrentUser();
                });

                registerHandler.onResponse("error", function(swarm){
                    errorFunction(swarm.error);
                    self.logoutCurrentUser();
                });
            }
        });
    },

    resetPassword: function (email, successCallback, failCallback) {
        var self = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, CONSTANTS.GUEST_EMAIL, CONSTANTS.GUEST_PASSWORD, "chromeBrowserExtension", "userLogin", failCallback, failCallback);

        swarmHub.on("login.js", "success_guest", function guestLoginForPasswordRecovery(swarm) {
            swarmHub.off("login.js", "success_guest", guestLoginForPasswordRecovery);
            if (swarm.authenticated) {

                var resetPassHandler = swarmHub.startSwarm("UserInfo.js", "resetPassword", email);
                resetPassHandler.onResponse("newPasswordWasSet", function (swarm) {
                    successCallback("success");
                    self.logoutCurrentUser();
                });

                resetPassHandler.onResponse("emailDeliveryUnsuccessful", function (swarm) {
                    failCallback(swarm.error);
                    self.logoutCurrentUser();
                });

                resetPassHandler.onResponse("resetPasswordFailed", function (swarm) {
                    failCallback(swarm.error);
                    self.logoutCurrentUser();
                });
            }
        });

    },

    authenticateWithToken: function(userId, authenticationToken, successCallback, failCallback){

        var self = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, userId, authenticationToken, "chromeBrowserExtension", "tokenLogin", failCallback, failCallback, function(){
            self.restoreUserSession();
        });

        var tokenLoginSuccessfully = function(swarm){

            if(loggedIn === false){
                self.setUser(successCallback);
            }

            loggedIn = swarm.authenticated;

            var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
            Cookies.set("sessionId", swarm.meta.sessionId,{expires:cookieValidityDays});
            Cookies.set("userId", swarm.userId,{expires:cookieValidityDays});

            swarmHub.off("login.js", "tokenLoginSuccessfully",tokenLoginSuccessfully);
        };

        var tokenLoginFailed = function(){
            loggedIn = false;
            Cookies.remove("userId");
            Cookies.remove("sessionId");
            swarmHub.off("login.js", "tokenLoginFailed",tokenLoginFailed);
        };

        swarmHub.on('login.js', "tokenLoginSuccessfully", tokenLoginSuccessfully);
        swarmHub.on('login.js', "tokenLoginFailed", tokenLoginFailed);

    },

    resendActivationCode:function(email, successCallback, failCallback){
        var self  = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, CONSTANTS.GUEST_EMAIL, CONSTANTS.GUEST_PASSWORD, "chromeBrowserExtension", "userLogin", failCallback, failCallback);

        swarmHub.on("login.js", "success_guest", function guestLoginForUserRegistration(swarm){
            swarmHub.off("login.js", "success_guest",guestLoginForUserRegistration);
            if(swarm.authenticated){
                var resendActivationCodeHandler = swarmHub.startSwarm("register.js", "sendActivationCode", email);
                resendActivationCodeHandler.onResponse("success", function(swarm){
                    successCallback();
                    self.logoutCurrentUser();
                });

                resendActivationCodeHandler.onResponse("failed", function(swarm){
                    failCallback(swarm.error);
                    self.logoutCurrentUser();
                });
            }
        });
    },

    restoreUserSession: function (successCallback, failCallback, errorCallback, reconnectCallback) {
        var username = Cookies.get("userId");
        var sessionId = Cookies.get("sessionId");
        var self = this;

        if (!username || !sessionId) {
            failCallback();
        }
        swarmService.restoreConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, username, sessionId, failCallback, errorCallback, reconnectCallback);
        swarmHub.on('login.js', "restoreSucceed", function restoredSuccessfully(swarm) {
            loggedIn = true;
            if(successCallback){
                self.setUser(successCallback);
            }
            swarmHub.off("login.js", "restoreSucceed",restoredSuccessfully);
        });

        swarmHub.on('login.js', "restoreSucceed", function restoredSuccessfully(swarm) {
            var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
            Cookies.set("sessionId", swarm.meta.sessionId, {expires: cookieValidityDays});
            Cookies.set("userId", swarm.userId, {expires: cookieValidityDays});
        });
    },

    setUser: function (callback) {
        var setUserHandler = swarmHub.startSwarm('UserInfo.js', 'info');
        setUserHandler.onResponse("result", function(swarm){
            authenticatedUser = swarm.result;
            if(authenticatedUser.email !== ExtensionConfig.GUEST_EMAIL){
                loggedInObservable.notify();
                if(callback){
                    callback(authenticatedUser);
                }
            }else{
                //logout guest user
                self.logoutCurrentUser();
            }
        });

    },

    getCurrentUser: function (callback) {
        loggedInObservable.observe(function () {
            callback(authenticatedUser);
        }, !loggedIn);
    },

    disconnectUser: function (callback) {
        notLoggedInObservable.observe(function () {
            callback();
        }, true);
    },

    logoutCurrentUser: function (callback) {
        swarmHub.startSwarm("login.js", "logout");
        swarmHub.on("login.js", "logoutSucceed", function logoutSucceed(swarm) {
            authenticatedUser = {};
            loggedIn = false;
            notLoggedInObservable.notify();
            notLoggedInObservable = swarmHub.createObservable();
            loggedInObservable = swarmHub.createObservable();
            Cookies.remove("userId");
            Cookies.remove("sessionId");
            swarmHub.off("login.js", "logoutSucceed",logoutSucceed);
            swarmService.removeConnection();
            if(callback){
                callback();
            }
        });
    }
}
