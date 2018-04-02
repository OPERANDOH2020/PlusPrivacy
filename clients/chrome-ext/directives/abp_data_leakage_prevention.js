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


angular.module("abp", [])
    .factory("subscriptionsService", function (messengerService) {

        /**
         * from chromeadblockplus/firstRun.js
         **/
        var featureSubscriptions = [
           {
                feature: "standard-ad-blocking",
                homepage: "https://easylist.adblockplus.org/",
                title: "Standard ad-blocking",
                feature_title: "Block advertisements",
                feature_description: "Prevent unwanted adds to be shown when visiting websites",
                url: "http://easylist-downloads.adblockplus.org/easylist.txt"
            },
            {
                feature: "tracking",
                homepage: "https://easylist.adblockplus.org/",
                title: "EasyPrivacy",
                feature_title: "Protect against tracking",
                feature_description: "Prevent web sites and advertisers from tracking you.",
                url: "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
            },
            {
                feature: "social",
                homepage: "https://www.fanboy.co.nz/",
                title: "Fanboy's Social Blocking List",
                feature_title: "Remove social media buttons",
                feature_description: "Automatically remove buttons such as Facebook Like – these are used to track your behavior.",
                url: "https://easylist-downloads.adblockplus.org/fanboy-social.txt"
            },
            {
                feature: "malware",
                homepage: "http://malwaredomains.com/",
                title: "Block malware",
                feature_title: "Block malware",
                feature_description: "Make your browsing more secure by blocking known malware domains.",
                url: "https://easylist-downloads.adblockplus.org/malwaredomains_full.txt"
            }

        ];

        var toBeUptadated = [];


        function notifyObservers(){
            for(var i = 0; i<toBeUptadated.length; i++){
                toBeUptadated[i]();
            }
        }

        var getFeatureSubscriptions = function (callback) {

            ext.backgroundPage.sendMessage({
                type: "subscriptions.get",
                downloadable: true,
                ignoreDisabled: true
            }, function (subscriptions) {
                var known = Object.create(null);
                for (var i = 0; i < subscriptions.length; i++)
                    known[subscriptions[i].url] = true;
                for (var i = 0; i < featureSubscriptions.length; i++) {
                    featureSubscriptions[i].checked = featureSubscriptions[i].url in known;
                }
                callback(featureSubscriptions);
            });

        };

        var updateSubscriptions = function (callback) {
            ext.backgroundPage.sendMessage({
                type: "subscriptions.get",
                downloadable: true,
                ignoreDisabled: true
            }, function (extensionSubscriptions) {
                var preferences = [];
                featureSubscriptions.forEach(function (subscription, index) {
                    var subscriptionIsOn = false;
                    for(var i = 0; i < extensionSubscriptions.length; i++){

                        if (extensionSubscriptions[i].url === subscription.url) {
                            subscriptionIsOn = true;
                            break;
                        }

                    }
                    featureSubscriptions[index].checked = subscriptionIsOn;
                    preferences.push({
                        feature: subscription.feature,
                        checked: subscriptionIsOn
                    });

                });


                messengerService.send("saveUserPreferences", {
                    preferenceKey: "abp-settings",
                    preferences: preferences
                }, callback);

            })
        };

        var subscribeToBeBeUpdated = function(callback){
            toBeUptadated.push(callback);
        };


        var init = function(){
            ext.onMessage.addListener(function (message) {
                if (message.type == "subscriptions.toggle") {
                    updateSubscriptions(function(){
                        notifyObservers();
                    });
                }
            });

            ext.backgroundPage.sendMessage({
                type: "subscriptions.listen",
                filter: ["added", "removed", "updated", "disabled"]
            });
        };

        return {
            getFeatureSubscriptions: getFeatureSubscriptions,
            subscribeToBeBeUpdated:subscribeToBeBeUpdated,
            init:init
        }
    })
    .controller('abpController', ['$scope',"$rootScope", "subscriptionsService","messengerService", function ($scope, $rootScope, subscriptionsService, messengerService) {
        $scope.abpIsEnabled = true;
        $scope.loaded = false;


        function saveAdBlockerSetting(isEnabled){
            messengerService.send("saveUserPreferences", {
                preferenceKey: "abp-status",
                preferences: isEnabled
            });
        }

        $rootScope.$on("toggleEvent",function(event){
            ext.backgroundPage.sendMessage({
                type: "subscriptions.get",
                downloadable: true
            }, function (subscriptions) {

                var subscriptionsWithName = subscriptions.filter(function(subscription){
                    return subscription.homepage != null;
                });

                var totalDisabled = subscriptionsWithName.filter(function(subscription){
                    return subscription.disabled == true;
                });


                if(totalDisabled.length == subscriptionsWithName.length){
                    $scope.abpIsEnabled = false;
                }
                else{
                    $scope.abpIsEnabled = true;
                }

                saveAdBlockerSetting($scope.abpIsEnabled);
                $scope.$apply();

            });
        });

        messengerService.send("getUserPreferences","abp-status",function(response){

            if(response.status === "success" && typeof response.data === "boolean" ){
                $scope.abpIsEnabled = response.data;
            }

            $scope.loaded = true;
            $scope.$apply();
        });


        subscriptionsService.subscribeToBeBeUpdated(updateToggleButtons);

        function updateToggleButtons() {
            subscriptionsService.getFeatureSubscriptions(function (subscriptions) {
                $scope.featureSubscriptions = subscriptions;
                $scope.$apply();
            });
        }
        updateToggleButtons();

        $scope.toggleAdBlocking = function(){
            $scope.abpIsEnabled = !$scope.abpIsEnabled;
            $rootScope.$broadcast('updateToggle',$scope.abpIsEnabled );
            saveAdBlockerSetting($scope.abpIsEnabled);
        }

    }]);
angular.module("abp").directive("abpLeakagePrevention", ["subscriptionsService",function (subscriptionsService) {
    return {
        restrict: "E",
        replace: true,
        scope: {"subscription": "="},
        templateUrl: "/operando/tpl/abp.html",
        link: function (scope, elem, attr) {
            scope.toggleOnOffButton = function ($event) {
                setTimeout(function () {
                    scope.subscription.checked = !scope.subscription.checked;
                    ext.backgroundPage.sendMessage({
                        type: "subscriptions.toggle",
                        keepInstalled:true,
                        url: scope.subscription.url,
                        title: scope.subscription.title,
                        homepage: scope.subscription.homepage
                    },function(){
                        if($event.originalEvent && $event.originalEvent.isTrusted === true){
                            scope.$emit("toggleEvent");
                        }
                    });
                }, 500);
            };

                var sequence = Promise.resolve();
                scope.$on("updateToggle", function(event, status){

                    if(scope.subscription.checked != status){
                        sequence = sequence.then(function(){
                            scope.subscription.checked = status;
                            return new Promise(function(resolve, reject){
                                ext.backgroundPage.sendMessage({
                                    type: "subscriptions.toggle",
                                    keepInstalled:true,
                                    url: scope.subscription.url,
                                    title: scope.subscription.title,
                                    homepage: scope.subscription.homepage
                                },function(){
                                    setTimeout(function(){
                                        resolve();
                                        scope.$apply();
                                    },50);
                                });

                            });
                        });

                    }
                })
        }
    }
}]);
