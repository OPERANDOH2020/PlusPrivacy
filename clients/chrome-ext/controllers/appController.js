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
controller("appCtrl", ["$scope","$rootScope", "messengerService","$window","$state", function ($scope, $rootScope, messengerService, $window, $state) {
    $scope.appVersion = chrome.app.getDetails().version;
    $scope.userIsLoggedIn = false;
    $scope.state = $state;
    $scope.logout = function () {
        messengerService.send("logoutCurrentUser");
    };


    /*var userDataIsRetrieved = function(response){
        //messengerService.off("getCurrentUser",userDataIsRetrieved);
        $scope.user = response.data;
        $scope.userIsLoggedIn = true;
        //$state.reload();
        $scope.$apply();
        $rootScope.$broadcast("dismissLoginModal");
    }*/


    messengerService.send("userIsAuthenticated", function (data) {
        var refreshPageData = function(refresh){
            return function(response){
                $scope.user = response.data;
                $scope.userIsLoggedIn = true;

                if(refresh){
                    console.log("dau refresh");
                    $rootScope.$broadcast("dismissLoginModal");
                    $state.reload();
                }
                else{
                    console.log("nu dau refresh inca");
                    refresh = true;
                }
                $scope.$apply();
            }
        };

        if(data.status && data.status == "success"){
            //we don't need to refresh the state
            messengerService.on("getCurrentUser",refreshPageData(false));
        }
        else{
            messengerService.on("getCurrentUser",refreshPageData(true));
        }

    });



    messengerService.on("userUpdated", updatedUserHandler);

    messengerService.on("notifyWhenLogout", logoutHandler);


    function updatedUserHandler(){
        messengerService.send("getCurrentUser",function(response){
            $scope.user = response.data;
            $scope.$apply();
        });
    }

    function logoutHandler(){
        console.log("afara");
        $scope.userIsLoggedIn = false;
        //messengerService.off("notifyWhenLogout", logoutHandler);
        //messengerService.on("getCurrentUser",userDataIsRetrieved);
        $state.reload();
    }


    $scope.checkCondition = function() {
        console.log($state.includes('extensions') || $state.includes('network'));
        return ($state.includes('extensions') || $state.includes('network'))?"home":"extensions";
    }

}]);


