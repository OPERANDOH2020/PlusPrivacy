var pspApp = angular.module("pspApp", ['angularModalService', 'ui-notification', 'ngIntlTelInput',
    'ngMaterial', 'ngMessages', 'mdPickers', 'datatables', 'ngRoute', 'oc.lazyLoad',"chart.js","mgcrea.ngStrap"]);
pspApp.config(function (NotificationProvider) {
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

pspApp.filter('timeAgo', [function () {
    return function (object) {
        return timeSince(new Date(object));
    }
}]);


pspApp.filter('timestampToDateFormat', [function () {
    return function (object) {
        var d = new Date(object);
        var datestring = ("0" + d.getDate()).slice(-2) + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" +
            d.getFullYear();
        return datestring;
    }
}]);

pspApp.filter('isEmpty', [function () {
    return function (object) {
        return angular.equals({}, object);
    }
}]);

pspApp
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


pspApp.config(function ($routeProvider) {
    $routeProvider.
    when("/", {
        templateUrl: "../assets/templates/landing_page.html"
    }).
    when("/login", {
        templateUrl: "../assets/templates/login_psp.html"
    }).
    when("/osp-requests", {
        templateUrl: "../assets/templates/dashboard/osp-requests.html"
    }).
    when("/osp-members", {
        templateUrl: "../assets/templates/dashboard/osp-members.html"
    }).
    otherwise({redirectTo: '/'});

});


pspApp.run(['$rootScope', '$location', 'userService', function ($rootScope, $location, userService) {

    $rootScope.$on('$routeChangeStart', function (event, next, current) {
        userService.isAuthenticated(function (isAuthenticated) {
            console.log(next, current);

            if (isAuthenticated === false) {
                if (next.$$route.originalPath != "/login") {
                    $location.path('/');
                }
            }

        });

    });

}]);



