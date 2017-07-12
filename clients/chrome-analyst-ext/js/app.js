var app = angular.module("app", ['angularModalService','ui.router','oc.lazyLoad']);


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
            templateUrl: "../templates/login.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/js/controllers/loginController.js');
                }]
            }
        })
        .state("dashboard", {
            url: "/dashboard",
            templateUrl: "../assets/templates/register_osp.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/ospSignupController.js');
                }]
            }
        });

    $urlRouterProvider.otherwise("/");

});
