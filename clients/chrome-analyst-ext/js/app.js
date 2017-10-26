var app = angular.module("app", ['angularModalService','ui-notification','ui.router','oc.lazyLoad','ui.select']);


app.filter('isEmpty', [function () {
    return function (object) {
        return angular.equals({}, object);
    }
}]);

app.config(['$locationProvider', function ($locationProvider) {
    $locationProvider.hashPrefix('');

}]);

app.config(['$qProvider', function ($qProvider) {
    $qProvider.errorOnUnhandledRejections(false);
}]);


app.config(function ($stateProvider, $urlRouterProvider, $ocLazyLoadProvider) {

    $ocLazyLoadProvider.config({
        debug: false,
        serie: true,
        cache: false
    });

    $stateProvider
        .state("login", {
            url: "/",
            templateUrl: "../templates/pages/login.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/js/controllers/loginController.js');
                }],
                resolvedUser: function (userService, $state) {
                    return userService.getCurrentUser().then(function (user) {
                        if(user !== "NO_USER"){
                            $state.go("dashboard.socialNetworks",{sn:"facebook"});
                        }
                    })
                }
            },
            data: {
                bodyClasses: 'login'
            }
        })
        .state("dashboard", {
            url: "/dashboard",
            redirectTo: 'dashboard.social_settings',
            views:{
                header:{
                    templateUrl:"../templates/views/header.html",
                    controller: ['$scope', '$state',
                        function( $scope, $state) {
                            $state.go('dashboard.socialnetworks');
                        }]
                }
            },
            resolve: {
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/js/controllers/headerController.js');
                }],
                resolvedUser: function (userService, $state) {
                    return userService.getCurrentUser().then(function (user) {
                        if(user !== "NO_USER"){
                            return user;
                        }
                        else{
                            $state.go("login");
                        }

                    })
                },
                settings:['ospService', function (ospService) {
                    return ospService.loadOSPs();
                }]
            }
        })
        .state("dashboard.socialNetworks",{
            url:"/sn-settings/:sn?",
            views: {
                'container@': {
                    templateUrl: "../templates/views/sn_settings.html",
                    controller:'socialNetworksController'
                }
            },
            resolve: {
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/js/controllers/socialNetworksController.js');
                }]
            },
            data: {
                bodyClasses: 'dashboard'
            }
        })
        .state("dashboard.eula",{
            url:"/eula/:osp/:eula",
            views: {
                'container@': {
                    templateUrl: "../templates/views/eula.html",
                }
            },
            resolve: {
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/js/controllers/eulaController.js');
                }]
            },
            data: {
                bodyClasses: 'dashboard'
            }
        })
        .state("dashboard.notifications",{
            url:"/notifications",
            views:{
                'container@':{
                    templateUrl:"../templates/views/notifications.html"
                }
            },
            resolve:{
                loadController:['$ocLazyLoad',function($ocLazyLoad){
                    return $ocLazyLoad.load("/js/controllers/notificationsController.js");
                }]
            },
            data: {
                bodyClasses: 'dashboard'
            }
        });


    $urlRouterProvider.otherwise("/");

});

