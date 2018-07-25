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

angular.module('operando').controller('PreferencesController', ["$scope", "$attrs", "cfpLoadingBar", "ospService", "$state", "watchDogService", "ModalService", "messengerService","i18nService",
    function ($scope, $attrs, cfpLoadingBar, ospService, $state, watchDogService, ModalService, messengerService, i18nService) {

        var settings = [];


        function showModalProgress(socialNetwork, settings, watchDogAction) {

            var searchCookieInterval = null;

            ModalService.showModal({

                templateUrl: '/tpl/modals/single_click_enforcement.html',
                controller: ["$scope", "close", "$element", function ($scope, close, $element) {

                    $scope.close = function (result) {
                        $element.modal('hide');
                        close(result, 500);
                    };

                    $scope.cancel = function(){
                        watchDogService.cancelEnforcement();
                    };

                    $scope.singleOsp = true;

                    function checkIfIsLoggedIn(socialNetwork, callback) {
                        $scope.socialNetwork = socialNetwork;
                        var url;
                        var cookieName;

                        switch (socialNetwork) {
                            case "Facebook":
                                url = "https://facebook.com";
                                cookieName = "c_user";
                                break;
                            case "LinkedIn":
                                url = "https://www.linkedin.com";
                                cookieName = "li_at";
                                break;
                            case "Twitter":
                                url = "https://www.twitter.com";
                                cookieName = "auth_token";
                                break;
                            case "Google":
                                url = "https://www.google.com";
                                cookieName = "SID";
                                break;
                        }

                        searchCookieInterval = setInterval(function () {
                            chrome.cookies.get({url: url, name: cookieName}, function (cookie) {
                                if (cookie) {
                                    $scope.isLoggedIn = true;
                                    callback();
                                    clearInterval(searchCookieInterval);
                                }
                                else {
                                    $scope.isLoggedIn = false;
                                    $scope.$apply();
                                }
                            });
                        }, 1000);
                    }

                    checkIfIsLoggedIn(socialNetwork, function () {
                        $scope.progresses = {};
                        watchDogAction(settings, function (ospname, current, total) {
                            $scope.progresses[ospname] = {
                                ospName: ospname,
                                current: current,
                                total: total,
                                status: current == -1? "aborted" : (current < total ? "pending" : "completed")
                            };
                            $scope.$apply();
                        }, function (aborted) {
                            if(aborted){
                                $scope.completed = true;
                                $scope.isAborted = true;
                                $scope.close("Aborted");
                            }
                            else{
                                $scope.completedFeedback = i18nService._("privaySettingsWereUpdated",{"socialNetwork":socialNetwork});
                                $scope.completed = true;
                                $scope.$apply();
                            }
                        });
                    });
                }]

            }).then(function (modal) {
                modal.element.modal({
                    backdrop: 'static'
                });
                modal.closed.then(function () {
                    clearInterval(searchCookieInterval);
                });
            });
        }

        $attrs.$observe('socialNetwork', function (value) {

            retrieveUserLoggedInAccount(value);
            $scope.socialNetwork = value;

            $scope.updateSettingsLabel = i18nService._("updateSettings",{ospTitle:$scope.osp.title});
            $scope.socialNetworksPrivacySettingsLabel =i18nService._("socialNetworksPrivacySettingsLabel",{socialNetwork:$scope.osp.title});;

            ospService.generateAngularForm($scope.socialNetwork, function (_schema) {
                $scope.schema = _schema;

                $scope.form = [];
                for (var key in $scope.schema.properties) {
                    $scope.form.push({
                        key: key,
                        type: "radios",
                        titleMap: $scope.schema.properties[key].enum,
                        default: $scope.schema.properties[key].preferred,

                        init: function () {
                            var preferred = $scope.schema.properties[key].recommended;
                            var initFn = function (item) {
                                if (preferred == item.value) {
                                    item.className = "recommended";
                                }
                            };
                            return initFn;
                        }()

                    });
                    $scope.schema.properties[key].default = $scope.schema.properties[key].preferred;
                }

                $scope.model = {};

                $scope.$apply();
            });
            $scope.submitPreferences = function () {

                ospService.getOSPSettings(function (ospWriteSettings) {

                    settings = [];
                    for (var settingKey in $scope.model) {
                        settings.push(watchDogService.prepareSettings(ospWriteSettings[settingKey].write, $scope.model[settingKey]));
                    }

                    switch ($scope.socialNetwork) {
                        case "facebook" :
                            showModalProgress("Facebook", settings, watchDogService.applyFacebookSettings);
                            break;
                        case "linkedin" :
                            showModalProgress("LinkedIn", settings, watchDogService.applyLinkedInSettings);
                            break;
                        case "twitter" :
                            showModalProgress("Twitter", settings, watchDogService.applyTwitterSettings);
                            break;
                        case "google" :
                            showModalProgress("Google", settings, watchDogService.applyGoogleSettings);
                            break;

                    }
                    var preferences = [];
                    for (var setting in $scope.model) {
                        preferences.push({
                            setting_key: setting,
                            setting_value: $scope.model[setting]
                        })
                    }

                    messengerService.send("saveUserPreferences", {
                        preferenceKey: $scope.socialNetwork,
                        preferences: preferences
                    });


                }, $scope.socialNetwork);

            }
        });


        function retrieveUserLoggedInAccount (socialNetwork){

            messengerService.send("verifyThirdPartyCookies", function(){
                messengerService.send("getMyLoggedinEmail", socialNetwork, function (response) {
                    messengerService.send("updateThirdPartyCookiesImplicitValue");
                    if (response.status === "success") {

                        var encodedStr = response.data.account;
                        var parser = new DOMParser();
                        var dom = parser.parseFromString(
                            '<!doctype html><body>' + encodedStr,
                            'text/html');
                        var decodedString = dom.body.textContent;

                        $scope.socialNetworkEmail = {
                            account: decodedString,
                            type: response.data.type
                        };
                        $scope.authenticated = true;
                    } else {
                        $scope.authenticated = false;
                    }
                    $scope.$apply();
                });
            });

        }
    }]);
