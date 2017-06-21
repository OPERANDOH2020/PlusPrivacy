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


angular.module("op-popup").
controller("menuCtrl", ["$scope","$window","$timeout", function ($scope, $window,$timeout) {

    $scope.initPopup = function(){
        $timeout(function(){
            $window.dispatchEvent(new Event("PopupDOMContentLoaded"));
        });

    }

}]);
