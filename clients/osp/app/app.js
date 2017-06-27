var ospApp = angular.module("ospApp", ['angularModalService', 'ui-notification', 'ngIntlTelInput',
    'ngMaterial', 'ngMessages', 'mdPickers', 'datatables', 'ui.router','oc.lazyLoad',"chart.js","mgcrea.ngStrap"]);
ospApp.config(function (NotificationProvider) {
    NotificationProvider.setOptions({
        delay: 10000,
        startTop: 20,
        startRight: 10,
        verticalSpacing: 20,
        horizontalSpacing: 20,
        positionX: 'left',
        positionY: 'bottom'
    })
});

ospApp.filter('timeAgo', [function () {
    return function (object) {
        return timeSince(new Date(object));
    }
}]);


ospApp.filter('timestampToDateFormat', [function () {
    return function (object) {
        var d = new Date(object);
        var datestring = ("0" + d.getDate()).slice(-2) + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" +
            d.getFullYear();
        return datestring;
    }
}]);

ospApp.filter('isEmpty', [function () {
    return function (object) {
        return angular.equals({}, object);
    }
}]);

ospApp
    .config(function (ngIntlTelInputProvider) {
        ngIntlTelInputProvider.set({
            initialCountry: 'gb',
            customPlaceholder: function (selectedCountryPlaceholder, selectedCountryData) {
                return "Phone e.g. " + selectedCountryPlaceholder;
            }
        });
    }).
config(['$locationProvider', function ($locationProvider) {
    $locationProvider.hashPrefix('');
}]);


ospApp.config(function ($stateProvider, $urlRouterProvider, $ocLazyLoadProvider) {

    $ocLazyLoadProvider.config({
        debug: false,
        serie: true,
        cache: false
    });

    $stateProvider.state('landing', {
            url: "/",
            templateUrl: "../assets/templates/landing_page.html"
        })
        .state("login", {
            url: "/login",
            templateUrl: "../assets/templates/login_osp.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/ospLoginController.js');
                }]
            }
        })
        .state("register", {
            url: "/register",
            templateUrl: "../assets/templates/register_osp.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/ospSignupController.js');
                }]
            }
        })
        .state("offers", {
            url: "/offers",
            templateUrl: "../assets/templates/dashboard/offers.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/ospOffersController.js');
                }]
            }
        })
        .state("deals", {
            url: "/deals",
            templateUrl: "../assets/templates/dashboard/deals.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/ospDealsController.js');
                }]
            }
        })
        .state("account", {
            url: "/account",
            templateUrl: "../assets/templates/dashboard/account.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/ospAccountController.js');
                }]
            }
        })
        .state("certifications", {
            url: "/certifications",
            templateUrl: "../assets/templates/dashboard/certifications.html"

        })
        .state("billing", {
            url: "/billing",
            templateUrl: "../assets/templates/dashboard/billing.html"
        })
        .state("verify", {
            url: "/verify/:verifyCode",
            templateUrl: "../assets/templates/verify.html",
            resolve:{
                loadController: ['$ocLazyLoad', function ($ocLazyLoad) {
                    return $ocLazyLoad.load('/app/controllers/confirmOSPController.js');
                }]
            }

        });

    $urlRouterProvider.otherwise("/");


});

ospApp.run(function ($rootScope, $transitions, $state, $location, $state, userService) {

    $transitions.onBefore({}, function (trans) {

        var toState = trans.$to();
        var sequence = Promise.resolve();
        userService.isAuthenticated(function (isAuthenticated) {

            if (isAuthenticated === false) {

                if (toState.name != "register" && toState.name != "login" &&
                    toState.name != 'verify') {

                    sequence = sequence.then(function () {
                        return new Promise(function (resolve, reject) {
                            resolve($state.target('login', undefined, {location: true}));
                        })
                    });

                } else {

                }
            } else if (toState.name === "login" || toState.name === "register") {

                sequence = sequence.then(function () {
                    return new Promise(function (resolve, reject) {
                        resolve($state.target('landing', undefined, {location: true}));
                    })
                });
            }
        });
        sequence.then(function(){

        });
        return sequence;
    });
});



