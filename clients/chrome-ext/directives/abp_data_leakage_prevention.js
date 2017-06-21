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
    .factory("subscriptionsService", function () {

        /**
         * from chromeadblockplus/firstRun.js
         **/
        var featureSubscriptions = [
            {
                feature: "tracking",
                homepage: "https://easylist.adblockplus.org/",
                title: "EasyPrivacy",
                feature_title:"Protect against tracking",
                feature_description:"Prevent web sites and and advertisers from tracking you.",
                url: "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
            },
            {
                feature: "social",
                homepage: "https://www.fanboy.co.nz/",
                title: "Fanboy's Social Blocking List",
                feature_title:"Remove social media buttons",
                feature_description:"Automatically remove buttons such as Facebook Like – these are used to track your behavior.",
                url: "https://easylist-downloads.adblockplus.org/fanboy-social.txt"
            },
            {
                feature: "malware",
                homepage: "http://malwaredomains.com/",
                title: "Block malware",
                feature_title:"Block malware",
                feature_description:"Make your browsing more secure by blocking known malware domains.",
                url: "https://easylist-downloads.adblockplus.org/malwaredomains_full.txt"
            }

        ];

       var getFeatureSubscriptions = function(callback){
            callback(featureSubscriptions);
       };

        return {
            getFeatureSubscriptions: getFeatureSubscriptions
        }
    })
    .controller('abpController', ['$scope',"subscriptionsService", function ($scope, subscriptionsService) {


    subscriptionsService.getFeatureSubscriptions(function(subscriptions){
        $scope.featureSubscriptions = subscriptions;
    });


    function updateToggleButtons()
    {
        ext.backgroundPage.sendMessage({
            type: "subscriptions.get",
            downloadable: true,
            ignoreDisabled: true
        }, function(subscriptions)
        {
            var known = Object.create(null);
            for (var i = 0; i < subscriptions.length; i++)
                known[subscriptions[i].url] = true;
            for (var i = 0; i < $scope.featureSubscriptions.length; i++)
            {
                var featureSubscription = $scope.featureSubscriptions[i];
                $scope.featureSubscriptions[i].checked = featureSubscription.url in known;

                $scope.$apply();
            }
        });
    }

    ext.onMessage.addListener(function(message)
    {
        if (message.type == "subscriptions.listen")
        {
            updateToggleButtons();
        }
    });
    ext.backgroundPage.sendMessage({
        type: "subscriptions.listen",
        filter: ["added", "removed", "updated", "disabled"]
    });



}])
angular.module("abp").directive("abpLeakagePrevention", function () {
    return {
        restrict: "E",
        replace: true,
        scope: {"subscription": "="},
        templateUrl: "/operando/tpl/abp.html",
        link: function(scope, elem, attr){
            scope.toggleOnOffButton = function(){
                setTimeout(function(){
                    ext.backgroundPage.sendMessage({
                        type: "subscriptions.toggle",
                        url: scope.subscription.url,
                        title: scope.subscription.title,
                        homepage: scope.subscription.homepage
                    });
                },500);
            }
        },

    }
});
