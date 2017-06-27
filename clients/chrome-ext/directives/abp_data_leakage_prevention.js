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
                feature: "tracking",
                homepage: "https://easylist.adblockplus.org/",
                title: "EasyPrivacy",
                feature_title: "Protect against tracking",
                feature_description: "Prevent web sites and and advertisers from tracking you.",
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


        var updateSubscriptionsInExtension = function (subscriptions) {

            ext.backgroundPage.sendMessage({
                type: "subscriptions.get",
                downloadable: true,
                ignoreDisabled: true
            }, function (extensionSubscriptions) {

                for(var i = 0; i < extensionSubscriptions.length; i++){
                    for(var j = 0; j < subscriptions.length; j++){
                        if(extensionSubscriptions[i].url == subscriptions[j].url){
                            if(subscriptions[j].checked == false){
                                ext.backgroundPage.sendMessage({
                                    type: "subscriptions.toggle",
                                    url: extensionSubscriptions[i].url,
                                    title: extensionSubscriptions[i].title,
                                    homepage: extensionSubscriptions[i].homepage
                                });
                            }
                        }
                    }
                }

            });

        };

        var getFeatureSubscriptions = function (callback) {

            messengerService.send("getUserPreferences", "abp-settings", function (response) {
                if (response.status == "success") {
                    if (response.data.length > 0) {
                        for (var i = 0; i < response.data.length; i++) {
                            for (var j = 0; j < featureSubscriptions.length; j++) {
                                if (response.data[i].feature === featureSubscriptions[j].feature) {
                                    featureSubscriptions[j].checked = response.data[i].checked;
                                }
                            }
                        }
                        callback(featureSubscriptions);
                        updateSubscriptionsInExtension(featureSubscriptions);

                    } else {
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
                    }
                }
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

        var saveFeatureSubscription = function (changedSubscription) {
            var preferences = [];
            featureSubscriptions.forEach(function (subscription) {

                if (subscription.feature === changedSubscription.feature) {
                    subscription.checked = !subscription.checked;
                }

                preferences.push({
                    feature: subscription.feature,
                    checked: subscription.checked
                });
            });
            messengerService.send("saveUserPreferences", {
                preferenceKey: "abp-settings",
                preferences: preferences
            }, function () {

            });

        };

        var subscribeToBeBeUpdated = function(callback){
            toBeUptadated.push(callback);
        }


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
            saveFeatureSubscription: saveFeatureSubscription,
            subscribeToBeBeUpdated:subscribeToBeBeUpdated,
            init:init
        }
    })
    .controller('abpController', ['$scope', "subscriptionsService", function ($scope, subscriptionsService) {


        subscriptionsService.subscribeToBeBeUpdated(updateToggleButtons);

        function updateToggleButtons() {
            subscriptionsService.getFeatureSubscriptions(function (subscriptions) {
                $scope.featureSubscriptions = subscriptions;
                $scope.$apply();
            });
        }
        updateToggleButtons();

    }]);
angular.module("abp").directive("abpLeakagePrevention", function (subscriptionsService) {
    return {
        restrict: "E",
        replace: true,
        scope: {"subscription": "="},
        templateUrl: "/operando/tpl/abp.html",
        link: function (scope, elem, attr) {
            scope.toggleOnOffButton = function () {
                setTimeout(function () {
                    ext.backgroundPage.sendMessage({
                        type: "subscriptions.toggle",
                        url: scope.subscription.url,
                        title: scope.subscription.title,
                        homepage: scope.subscription.homepage
                    });
                    subscriptionsService.saveFeatureSubscription(scope.subscription);
                }, 500);
            }
        }

    }
});
