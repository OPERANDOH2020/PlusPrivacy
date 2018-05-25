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

angular.module('operando', ['extensions', 'identities', 'pfbdeals', 'singleClickPrivacy',
    'notifications','socialApps', 'osp', 'angularModalService', 'operandoCore', 'schemaForm', 'adblocker',
    'settingEditor','angular-loading-bar','UIComponent','login','ui.select',
    'ngAnimate','ngMessages','datatables','ngResource','mgcrea.ngStrap'])
    .config([
        '$compileProvider',
        function ($compileProvider) {   //to accept chrome protocol
            $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension|data|moz-extension):/);
            $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension|data|moz-extension):/);

        }
    ])
    .config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) {
        cfpLoadingBarProvider.includeSpinner = false;
        cfpLoadingBarProvider.includeBar = true;
        cfpLoadingBarProvider.parentSelector = '#loading-bar-container';
        cfpLoadingBarProvider.latencyThreshold = 500;
        cfpLoadingBarProvider.autoIncrement = false;

    }])
    .filter("trusthtml", ['$sce', function($sce) {
        return function(htmlCode){
            return $sce.trustAsHtml(htmlCode);
        }
    }])
    .filter('isEmpty', [function() {
        return function(object) {
            return angular.equals({}, object);
        }
    }])
    .filter("removeWhiteSpace", [function() {
        return function(text){
            var w = text.replace(/[^A-Za-z0-9]/g, "");
            w = w.toLowerCase();
            w = w.replace(/\s/g,'');
            return w;
        }
    }])
    .run(['$rootScope', '$state', '$stateParams',
        function ($rootScope, $state, $stateParams) {
            $rootScope.$state = $state;
            $rootScope.$stateParams = $stateParams;
        }
    ]).run(["$rootScope", function($rootScope){
        $rootScope.$on("$stateChangeSuccess", function (event, currentRoute, previousRoute) {
            window.dispatchEvent(new Event('scrollTop'));
        });
    }])
    .run( function(DTDefaultOptions){
        DTDefaultOptions.setLoadingTemplate('<ui-loader ></ui-loader>');
    })
    .config(function ($stateProvider, $urlRouterProvider, $ocLazyLoadProvider) {

        $ocLazyLoadProvider.config({
            debug: false,
            serie: true
        });

        // Now set up the states
        $stateProvider
            .state('home', {
                url: "/home",
                templateUrl: "views/home.html",
                cache: false
            })
            .state("socialNetworks", {
                url: "/social-networks",
                templateUrl:"views/social_networks.html",
                resolve: {
                    settings:['ospService', function (ospService) {
                        return ospService.loadOSPs();
                    }]
                }
            })
            .state("notifications", {
                url: "/notifications",
                templateUrl: "views/home/notifications.html"
            })
            .state("home.blog", {
                url: "/blog",
                templateUrl: "views/home/blog.html"
            })

            .state('preferences', {
                url: "/preferences",
                abstract: true,
                templateUrl: "views/preferences.html",
                resolve: {
                    settings:['ospService', function (ospService) {
                        return ospService.loadOSPs();
                    }],
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load(['/controllers/preferencesController.js']);
                    }]
                }
            })
            .state('preferences.sn', {
                url: "/:sn",
                params: {
                    sn: "facebook"
                },
                resolve: {
                    sn:['$stateParams', function ($stateParams) {
                        return $stateParams.sn;
                    }],
                    settings:['ospService', function (ospService) {
                        return ospService.loadOSPs();
                    }]
                },
                templateUrl:"views/preferences/social_network.html",
                controller:["$scope","$stateParams","settings", function($scope, $stateParams, settings) {

                    var socialNetworks={
                        facebook : "Facebook",
                        linkedin: "LinkedIn",
                        twitter: "Twitter",
                        google: "Google"

                    };

                    if (!$stateParams.sn) {
                        $scope.osp = {
                            key: 'facebook',
                            title: socialNetworks['facebook'],
                            settings: settings['facebook']
                        }

                    }
                    else {
                        $scope.osp = {
                            key: $stateParams.sn,
                            title: socialNetworks[$stateParams.sn.toLowerCase()],
                            settings: settings[$stateParams.sn]
                        }
                    }

                    $scope.sn = $stateParams.sn;
                }]
            })
            .state('network', {
                url: "/network",
                abstract: true,
                templateUrl: "views/network.html",
                resolve:{
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/socialAppsController.js');
                    }]
                }
            })
            .state('network.apps', {
                url: "/apps/:sn",
                params: {
                    sn: "facebook"
                },
                resolve: {
                    sn:['$stateParams', function ($stateParams) {
                        return $stateParams.sn;
                    }],
                    settings:['ospService', function (ospService) {
                        return ospService.loadOSPs();
                    }],
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/socialAppController.js');
                    }]
                },
                templateUrl:"views/apps/social_apps.html"
            })
            .state('abp', {
                url: "/ad-blocking",
                templateUrl: "views/preferences/abp.html"

            })
            .state('deals', {
                url: "/deals",
                templateProvider:["$stateParams", '$templateRequest',"messengerService",
                    function($stateParams, templateRequest,messengerService) {
                        var tplName = "views/deals.html";
                        var notLoggedIn = "views/not_authenticated.html";

                        return new Promise(function (resolve) {
                            messengerService.send("userIsAuthenticated", function (data) {
                                if(data.status && data.status =="success"){
                                    resolve(templateRequest(tplName))
                                }
                                else{
                                    resolve(templateRequest(notLoggedIn));
                                }

                            });
                        });
                    }
                ],
                resolve:{
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        //TODO load only when is needed
                        return $ocLazyLoad.load('/controllers/appLoginController.js');
                    }]
                }
            })
            .state('identityManagement', {
                url: "/identities",
                templateProvider:["$stateParams", '$templateRequest',"messengerService",
                    function($stateParams, templateRequest,messengerService) {
                        var tplName = "views/identity_management.html";
                        var notLoggedIn = "views/not_authenticated.html";

                        return new Promise(function (resolve) {
                            messengerService.send("userIsAuthenticated", function (data) {
                                if(data.status && data.status =="success"){
                                    resolve(templateRequest(tplName))
                                }
                                else{
                                    resolve(templateRequest(notLoggedIn));
                                }

                            });
                        });
                    }
                ],
                resolve:{
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        //TODO load only when is needed
                        return $ocLazyLoad.load('/controllers/appLoginController.js');
                    }]
                }
            })
            .state('extensions', {
                url: "/extensions",
                templateUrl: "views/apps/extensions.html",
                resolve:{
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/socialAppsController.js');
                    }]
                }
            })
            .state('account', {
                url: "/account",
                abstract: true,
                templateProvider:["$stateParams", '$templateRequest',"messengerService",
                    function($stateParams, templateRequest, messengerService) {
                        var tplName = "views/user_account.html";
                        var notLoggedIn = "views/not_authenticated.html";

                        return new Promise(function (resolve) {
                            messengerService.send("userIsAuthenticated", function (data) {
                                if(data.status && data.status =="success"){
                                    resolve(templateRequest(tplName))
                                }
                                else{
                                    resolve(templateRequest(notLoggedIn));
                                }

                            });
                        });
                    }
                ],
                resolve: {
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/appLoginController.js');
                    }]
                }
            })
            .state('account.personal-details', {
                url: "/personal-details",
                templateUrl: "views/account/personal_details.html",
                resolve: {
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/accountController.js');
                    }]
                }
            })
            .state('account.activity', {
                url: "/activity",
                templateUrl: "views/account/activity.html"
            })
            .state('account.billing', {
                url: "/billing",
                templateUrl: "views/account/billing.html"
            })
            .state('privacyPolicy', {
            url: "/privacy-policy",
            templateUrl: "views/privacy_policy.html"
            })
            /*.state('feedback', {
                url: "/feedback",
                templateUrl: "views/feedback.html",
                resolve: {
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/feedbackController.js');
                    }]
                }
            })*/
            .state('feedback', {
                url: "/feedback",
                templateUrl: "views/feedback_form.html",
                resolve: {
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load('/controllers/messageFeedbackController.js');
                    }]
                }
            })
            .state('contact', {
                url: "/contact",
                templateProvider:["$stateParams", '$templateRequest',"messengerService",
                    function($stateParams, templateRequest, messengerService) {
                        var tplName = "views/contact.html";
                        var notLoggedIn = "views/not_authenticated.html";

                        return new Promise(function (resolve) {
                            messengerService.send("userIsAuthenticated", function (data) {
                                if(data.status && data.status =="success"){
                                    resolve(templateRequest(tplName))
                                }
                                else{
                                    resolve(templateRequest(notLoggedIn));
                                }

                            });
                        });
                    }
                ],
                resolve: {
                    loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                        return $ocLazyLoad.load(['/controllers/contactController.js',
                            '/controllers/appLoginController.js']);
                    }]
                }
            });
        $urlRouterProvider.otherwise('/home');
    })
    .run(["i18nService",function(i18nService){
        i18nService.load();
    }]);



