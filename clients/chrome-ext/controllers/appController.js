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
controller("appCtrl", ["$scope", "messengerService","$window", function ($scope, messengerService,$window) {

    $scope.userIsLoggedIn = false;

    $scope.logout = function () {
        messengerService.send("logout", logoutHandler);
    }

    messengerService.send("getCurrentUser",function(user){
        $scope.user = user;
        $scope.userIsLoggedIn = true;
        $scope.$apply();
    });

    messengerService.on("userUpdated", updatedUserHandler);

    messengerService.send("notifyWhenLogout", logoutHandler);


    function updatedUserHandler(){
        messengerService.send("getCurrentUser",function(user){
            $scope.user = user;
            $scope.$apply();
        });
    }

    function logoutHandler(){
        $scope.userIsLoggedIn = false;
        $window.location.href = "http://plusprivacy.com";
    }

}]);


