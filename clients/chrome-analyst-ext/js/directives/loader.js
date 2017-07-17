angular.module("app").directive("uiLoader", function () {
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl: '/templates/ui-loader.html'
    }
});