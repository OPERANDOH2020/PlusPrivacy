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

angular.module('popupMenu', [])
    .directive('menuItem', function () {

        return {
            restrict: 'E',
            replace: true,
            scope: {},
            templateUrl:'/operando/tpl/menu_item.html',
            link: function(scope,element, attributes){
                scope.iconClass = attributes.iconClass;
                scope.menuLabel = attributes.menuLabel;
                scope.tabToOpen = attributes.tabToOpen;

                element.on("click", function(){
                    window.open(chrome.runtime.getURL("operando/operando.html#"+scope.tabToOpen),"operando");
                })
            },

            controller: function ($scope) {

            }
        }

    }).//uiLoader is also available on loader.js, but this file is merged with other files in directives.js
    directive("uiLoader", function(){
        return {
            restrict: 'E',
            replace: true,
            scope: {status:"@?"},
            templateUrl: '/operando/tpl/ui/loader.html',
            controller: function ($scope) {

                function changeStatus() {
                    if (angular.isDefined($scope.status)) {
                        switch ($scope.status) {
                            case "pending":
                                break;
                            case "completed":
                                break;
                            default:
                                $scope.status = "pending";
                        }

                    } else {
                        $scope.status = "pending";
                    }
                }

                changeStatus();

            }

        }
    });
