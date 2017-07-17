var app = angular.module("app", ['angularModalService','ui-notification','ui.router','oc.lazyLoad']);


app.filter('isEmpty', [function () {
    return function (object) {
        return angular.equals({}, object);
    }
}]);

app.
config(['$locationProvider', function ($locationProvider) {
    $locationProvider.hashPrefix('');
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
                resolvedUser:function(userService, $state){
                    return userService.getCurrentUser().then(function(user){
                        $state.go("dashboard");
                    },function(_error){

                    })
                }
            },
            data: {
                bodyClasses: 'login'
            }
        })
        .state("dashboard", {
            url: "/dashboard",
            templateUrl: "../templates/pages/dashboard.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/js/controllers/dashboardController.js');
                }],
                resolvedUser:function(userService, $state){
                    return userService.getCurrentUser().then(function(user){
                        return user;
                    },function(_error){
                        $state.go("login");
                    })
                }
            },
            data: {
                bodyClasses: 'dashboard'
            }
        });

    $urlRouterProvider.otherwise("/");

});

