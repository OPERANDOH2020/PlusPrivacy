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


angular.module("op-popup").controller("loginCtrl", ['$scope', 'messengerService','i18nService', function($scope, messengerService, i18nService){

    var defaultUser = {remember_me:true};

    $scope.user = angular.copy(defaultUser);
    $scope.isAuthenticated = false;
    $scope.requestIsProcessed = false;

    $scope.info = {
        message: "",
        status: ""
    };

    $scope.loginAreaState = "loggedout";

    //show login form
    $scope.show_login = function () {
        $scope.loginAreaState = "login_form";
        $scope.showABPAndPrivacyPolicyOptions = false;
    }

    $scope.cancel = function () {
        $scope.loginAreaState = "loggedout";
        $scope.showABPAndPrivacyPolicyOptions = true;
    }

    clearInfoPanel = function(){
        setTimeout(function(){
            //reset to default
            //TODO this in UI
            //add fade effect
            $scope.info={
                status:"",

                message:""
            };
            delete $scope.requestStatus;
            $scope.$apply();
        },2000);
    }

    securityErrorFunction = function (error) {

        $scope.info.message = i18nService._(error);

        if (error === "accountNotActivated") {
            $scope.info.message = i18nService._(error);
            $scope.showResendActivationCode = true;
        }

        $scope.info.status = "error";
        $scope.$apply();
    }

    errorFunction = function () {
        $scope.info.message = 'Connection lost...';
        $scope.info.status = "error";
        $scope.$apply();
    }

    successFunction = function () {
        messengerService.send("getCurrentUser", function(user){
            $scope.loginAreaState = "loggedin";
            $scope.user.email = user.email;
            $scope.isAuthenticated = true;
            $scope.$apply();
        });
    }

    reconnectFunction = function(){
        $scope.info.status = "success";
        $scope.info.message = 'Connected...';
        $scope.$apply();
        clearInfoPanel();
    }

    $scope.resendActivationCode = function () {
        $scope.showResendActivationCode = false;
        $scope.requestIsProcessed = true;
        $scope.requestStatus = "pending";
        $scope.info.status = "success";
        $scope.info.message = 'Sending activation email...';

        messengerService.send("resendActivationCode", $scope.user.email, function (response) {

            $scope.requestIsProcessed = false;

            if(response.status === "success"){
                $scope.info.status = "success";
                $scope.info.message = 'Check your email!';
                $scope.requestStatus = "completed";
                $scope.$apply();
            }
            else {
                $scope.info.status = "error";
                $scope.info.message = response.message;
                $scope.requestStatus = "completed";
                $scope.$apply();
            }
        });
    }

    $scope.login = function () {
        $scope.requestIsProcessed = true;
        $scope.requestStatus = "pending";
        $scope.info.status = "success";
        $scope.info.message = 'Logging in...';
        messengerService.send("login", {
            login_details: {
                email: $scope.user.email,
                password: $scope.user.password,
                remember_me: $scope.user.remember_me
            }
        }, function (response) {
            $scope.requestIsProcessed = false;
            if (response.success) {
                setTimeout(function(){
                    chrome.runtime.openOptionsPage();
                },500);
            }
            else{

                securityErrorFunction(response.error);
            }

        });
    }

    $scope.reset_password = function () {
        $scope.requestIsProcessed = true;
        $scope.requestStatus = "pending";
        $scope.info.status = "success";
        $scope.info.message = 'Resetting your password...';

        messengerService.send("resetPassword", $scope.user.email, function (data) {

            $scope.requestIsProcessed = false;
            if (data.status === "success") {
                $scope.info.status = "success";
                $scope.info.message = 'Check your email!';
                $scope.requestStatus = "completed";
                $scope.show_login();
                $scope.$apply();
            }
            else {
                delete $scope.requestStatus;
                $scope.info.status = "error";
                $scope.info.message = "An error occurred. Try again later!";
                $scope.$apply();
            }
        });
    }

    $scope.show_forgot_password = function(){
        $scope.loginAreaState = "forgot_password";
        $scope.showABPAndPrivacyPolicyOptions = false;
    }

    $scope.show_register = function(){
        $scope.loginAreaState = "register_form";
        $scope.user = angular.copy(defaultUser);
        $scope.showABPAndPrivacyPolicyOptions = false;
    }

    $scope.register = function(){

        $scope.info.status = "success";
        $scope.info.message = 'Processing...';
        $scope.requestStatus = "pending";

        $scope.requestIsProcessed = true;

        var successFunction = function(){
            $scope.loginAreaState = "login_form";
            $scope.info.status = "success";
            $scope.info.message = 'Check your email for activation!';
            $scope.requestStatus = "completed";
            $scope.$apply();
            clearInfoPanel();

        }

        var errorFunction = function(errorMessage){
            $scope.info.message = i18nService._(errorMessage);
            $scope.info.status = "error";
            $scope.$apply();
        }

        messengerService.send("registerUser",$scope.user, function(response){

            $scope.requestIsProcessed = false;
            if(response.status == "success"){
                successFunction();
            }
            else if(response.status == "error"){
                errorFunction(response.message);
            }
        });
    };

    $scope.$watch('loginAreaState', function(){
        if($scope.info.status == "error"){
            $scope.info = {
                message: "",
                status: ""
            };
        }
    });

    $scope.logout = function(){
        $scope.requestStatus = "pending";
        $scope.requestIsProcessed = true;
        messengerService.send("logout",function(){
            $scope.requestIsProcessed = false;
            $scope.requestStatus = "completed";
            $scope.loginAreaState = "loggedout";
            $scope.isAuthenticated = false;
            $scope.user = angular.copy(defaultUser);
            $scope.$apply();
        });
    }

    messengerService.send("restoreUserSession",{}, function(status){
        if(status.success){
            successFunction();
        }
        else if(status.fail){
            $scope.loginAreaState = "loggedout";
        }
        else if(status.error){
            errorFunction();
        }
        else if(status.reconnect){
            reconnectFunction();
        }
    });


    /*messengerService.on("onReconnect",reconnectFunction);
    messengerService.on("onConnectionError",errorFunction);
    messengerService.on("onConnect",reconnectFunction);*/


    chrome.tabs.query({active:true, windowId:chrome.windows.WINDOW_ID_CURRENT}, function (tabs){
        var ourTab = tabs[0];
        if(ourTab.url.indexOf("http")===0||ourTab.url.indexOf("https")===0){
            $scope.showABPAndPrivacyPolicyOptions = true;
        }
    });

}]);

