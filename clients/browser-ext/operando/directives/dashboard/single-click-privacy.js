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

                        templateUrl: '/tpl/modals/single_click_button_modal.html',
                        controller: ["$scope", "close", "$element", "messengerService", function ($scope, close, $element, messengerService) {

                            $scope.enforcePrivacy = function(){

                                messengerService.send("dismissPrivacyNotifications");

                                ModalService.showModal({

                                        templateUrl: '/tpl/modals/single_click_enforcement.html',
                                        controller: ["$scope", "close", "watchDogService", function ($scope, close, watchDogService) {

                                            $scope.progresses = {};
                                            $scope.osps = [];
                                            $scope.noSocialNetworkAvailable = false;
                                            var checkingInterval = null;

                                            $scope.close = function (result) {
                                                $element.modal('hide');
                                                close(result, 500);
                                                if(checkingInterval){
                                                    clearInterval(checkingInterval);
                                                    checkingInterval = null;
                                                }
                                            };

                                            $scope.cancel = function(){
                                                watchDogService.cancelEnforcement();
                                                if(checkingInterval){
                                                    clearInterval(checkingInterval);
                                                    checkingInterval = null;
                                                }
                                            };

                                            $scope.$watch('progresses', function(newValue, oldValue){
                                                $scope.ospsAborted = 0;
                                                for(var osp in newValue){
                                                    if(newValue[osp]['isAborted'] === true){
                                                        $scope.ospsAborted++;
                                                    }
                                                };

                                            },true);


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
                                                },
                                                google:{
                                                    url : "https://www.google.com",
                                                    cookie_name : "SID"
                                                }
                                            };

                                            $scope.loginUrls = {};
                                            for(var ospName in readCookieConf){
                                                $scope.loginUrls[ospName] = readCookieConf[ospName].url;
                                                $scope.osps.push({name:ospName});
                                            }




                                            var readCookie  = function(ospKey,conf){
                                                return new Promise(function(resolve, reject){
                                                    chrome.cookies.get({url: conf.url, name: conf.cookie_name}, function (cookie) {
                                                        var loggedIn = cookie?true:false;
                                                        for(var i = 0; i<$scope.osps.length; i++){
                                                            if($scope.osps[i].name == ospKey){
                                                                $scope.osps[i].loggedIn = loggedIn;
                                                                break;
                                                            }
                                                        }
                                                        resolve();
                                                    });
                                                });
                                            };


                                            var enforce = function () {
                                                console.log("enforce");
                                                $scope.securedOSPs = [];

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

                                                        var loggedinOSPs = $scope.osps.filter(function(osp){
                                                            return osp.loggedIn == true;
                                                        });

                                                        var notLoggedinOSPs = $scope.osps.filter(function(osp){
                                                            return osp.loggedIn == false;
                                                        });

                                                        if (notLoggedinOSPs.length === Object.keys(readCookieConf).length) {

                                                            if (checkingInterval) {
                                                                clearInterval(checkingInterval);
                                                                checkingInterval = null;
                                                            }

                                                            $scope.noSocialNetworkAvailable = true;
                                                        } else {
                                                            $scope.noSocialNetworkAvailable = false;
                                                            if(!checkingInterval){
                                                                checkingInterval = setInterval(enforce, 2000);
                                                            }

                                                        }
                                                        $scope.$apply();

                                                        var newLoggedInOSPs = loggedinOSPs.map(function(loggedinOSP){
                                                            return loggedinOSP.name;
                                                        });

                                                        notLoggedinOSPs.forEach(function(notLoggedInOsp){
                                                            $scope.progresses[notLoggedInOsp.name] = {
                                                                ospName: notLoggedInOsp.name,
                                                                status: "notLoggedIn"
                                                            };
                                                        });

                                                        $scope.osps = angular.copy(notLoggedinOSPs);
                                                        $scope.$apply();
                                                        if(newLoggedInOSPs.length>0) {

                                                            (function(newLoggedInOSPs){
                                                                watchDogService.maximizeEnforcement(newLoggedInOSPs, function (ospname, current, total) {
                                                                    console.log(ospname);
                                                                    $scope.progresses[ospname] = {
                                                                        ospName: ospname,
                                                                        current: current,
                                                                        total: total,
                                                                        status: current == -1 ? "aborted" : (current < total ? "pending" : "completed")
                                                                    };
                                                                    $scope.$apply();
                                                                }, function (jobsFinished) {

                                                                    $scope.completed = true;

                                                                    if (jobsFinished === 0) {
                                                                        if ($scope.operationSucceed == true) {
                                                                            delete $scope.operationSucceed;
                                                                            $scope.operationPartialSucceed = true;
                                                                        } else if($scope.operationPartialSucceed != true){
                                                                            $scope.operationAborted = true;
                                                                        }
                                                                    }
                                                                    else if (jobsFinished < newLoggedInOSPs.length) {
                                                                        $scope.operationPartialSucceed = true;
                                                                    }
                                                                    else {
                                                                        if ($scope.operationPartialSucceed == true) {
                                                                            delete $scope.operationSucceed;
                                                                        }
                                                                        else if ($scope.operationAborted == true) {
                                                                            delete $scope.operationAborted;
                                                                            $scope.operationPartialSucceed = true;
                                                                        } else {
                                                                            $scope.operationSucceed = true;
                                                                        }
                                                                    }
                                                                    $scope.$apply();
                                                                    if (jobsFinished !== 0) {

                                                                        var sequence = Promise.resolve();
                                                                        newLoggedInOSPs.forEach(function (osp) {
                                                                            sequence = sequence.then(function(){
                                                                                return new Promise(function(resolve){
                                                                                    messengerService.send("removePreferences", osp, resolve);
                                                                                });
                                                                            })

                                                                        });
                                                                    }
                                                                });

                                                            })(newLoggedInOSPs);
                                                        }
                                                    }
                                                    else{
                                                        if(checkingInterval){
                                                            clearInterval(checkingInterval);
                                                            checkingInterval = null;
                                                        }
                                                    }
                                                });
                                            };
                                            enforce();
                                            $scope.enforce = function(){
                                                enforce();
                                            };
                                            checkingInterval = setInterval(enforce,2000);

                                        }]

                                    }).then(function (modal) {
                                        modal.element.modal({
                                            backdrop: 'static'
                                        });
                                    });
                            }
                        }
                        ]
                    }).then(function (modal) {
                        modal.element.modal({
                            backdrop: 'static'
                        });
                    });
                }

            },
            templateUrl: '/tpl/single_click_button.html'

        }

    });