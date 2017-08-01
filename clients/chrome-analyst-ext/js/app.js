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
                    return $ocLazyLoad.load('/js/controllers/socialNetworksController.js');
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
                    controller:["$scope","$stateParams","settings", function($scope, $stateParams, settings) {
                        if (!$stateParams.sn) {
                            $scope.osp = {
                                key: 'facebook',
                                title: 'Facebook',
                                settings: settings['facebook']
                            }
                        }
                        else {
                            $scope.osp = {
                                key: $stateParams.sn,
                                title: capitalizeFirstLetter($stateParams.sn),
                                settings: settings[$stateParams.sn]
                            };

                            $scope.$watch("osp", function(newValue, oldValue){
                                $scope.actualJson = JSON.stringify(newValue);
                            }, true);
                            $scope.jsonObject = JSON.stringify($scope.osp);

                            $scope.$on("deleteSNSetting", function(event,id){
                                console.log( $scope.osp.settings);
                                var settings = $scope.osp.settings;
                                for(var p in settings){
                                    if(settings[p].id === id){
                                        delete $scope.osp.settings[p];
                                        break;
                                    }
                                }
                            });
                        }

                        $scope.sn = $stateParams.sn;
                    }]
                }
            },
            data: {
                bodyClasses: 'dashboard'
            }
        });


    $urlRouterProvider.otherwise("/");

});

