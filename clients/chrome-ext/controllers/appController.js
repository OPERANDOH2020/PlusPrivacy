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

angular.module("operando").
controller("appCtrl", ["$scope", "messengerService","$window","$state", function ($scope, messengerService, $window, $state) {
    $scope.appVersion = chrome.app.getDetails().version;
    $scope.userIsLoggedIn = false;
    $scope.state = $state;
    $scope.logout = function () {
        messengerService.send("logoutCurrentUser", logoutHandler);
    }

    messengerService.send("getCurrentUser",function(response){
        $scope.user = response.data;
        $scope.userIsLoggedIn = true;
        $scope.$apply();
    });

    messengerService.on("userUpdated", updatedUserHandler);

    messengerService.send("notifyWhenLogout", logoutHandler);


    function updatedUserHandler(){
        messengerService.send("getCurrentUser",function(response){
            $scope.user = response.data;
            $scope.$apply();
        });
    }

    function logoutHandler(){
        $scope.userIsLoggedIn = false;
        messengerService.send("provideLogoutLink",function(response){
            $window.location.href = response.data;
        });
    }


    $scope.checkCondition = function() {
        console.log($state.includes('extensions') || $state.includes('network'));
        return ($state.includes('extensions') || $state.includes('network'))?"home":"extensions";
    }

}]);


