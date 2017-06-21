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

angular.module("singleClickPrivacy",[])
    .directive('singleclickprivacy',function(){

        return{
            restrict: 'E',
            replace: true,
            scope: {},
            controller : function($scope, ModalService){

                $scope.enforce = function(){
                    ModalService.showModal({

                        templateUrl: '/operando/tpl/modals/single_click_button_modal.html',
                        controller: ["$scope", "close", "messengerService", function ($scope, close, messengerService) {

                            $scope.close = function (result) {
                                close(result, 500);
                            };
                            $scope.enforcePrivacy = function(){

                                messengerService.send("dismissPrivacyNotifications");

                                ModalService.showModal({

                                        templateUrl: '/operando/tpl/modals/single_click_enforcement.html',
                                        controller: ["$scope", "close", "watchDogService", function ($scope, close, watchDogService) {
                                            var readCookieConf = {
                                                facebook:{
                                                    url:"https://facebook.com",
                                                    cookie_name:"c_user"
                                                },
                                                linkedin:{
                                                    url:"https://www.linkedin.com",
                                                    cookie_name:"li_at"
                                                },
                                                twitter:{
                                                    url:"https://www.twitter.com",
                                                    cookie_name:"auth_token"
                                                }
                                            }

                                            var readCookie  = function(ospKey,conf){
                                                return new Promise(function(resolve, reject){
                                                    chrome.cookies.get({url: conf.url, name: conf.cookie_name}, function (cookie) {
                                                        if (cookie) {
                                                            $scope.osps.push(ospKey);
                                                            resolve();
                                                        }
                                                        else {
                                                            resolve("Not logged in "+ospKey);
                                                        }
                                                    });
                                                });
                                            }

                                            var enforce = function () {

                                                $scope.progresses = {};
                                                $scope.osps = [];
                                                $scope.noSocialNetworkAvailable = false;

                                                var promise = Promise.resolve();
                                                for (var ospKey in readCookieConf) {
                                                    (function (ospKey) {
                                                        promise = promise.then(function () {
                                                            return readCookie(ospKey, readCookieConf[ospKey]);
                                                        })
                                                    }(ospKey));
                                                }

                                                promise.then(function () {
                                                    if ($scope.osps.length > 0) {
                                                        watchDogService.maximizeEnforcement($scope.osps, function (ospname, current, total) {
                                                            $scope.progresses[ospname] = {
                                                                ospName: ospname,
                                                                current: current,
                                                                total: total,
                                                                status: current < total ? "pending" : "completed"
                                                            }
                                                            $scope.$apply();
                                                        }, function () {
                                                            $scope.completed = true;
                                                        });
                                                    }
                                                    else{
                                                        $scope.noSocialNetworkAvailable = true;
                                                        $scope.$apply();
                                                    }
                                                });
                                            }
                                            enforce();
                                            $scope.enforce = enforce;

                                        }]

                                    }).then(function (modal) {
                                        modal.element.modal();
                                    });
                            }
                        }
                        ]
                    }).then(function (modal) {
                        modal.element.modal();
                    });
                }

            },
            templateUrl: '/operando/tpl/single_click_button.html'

        }

    });