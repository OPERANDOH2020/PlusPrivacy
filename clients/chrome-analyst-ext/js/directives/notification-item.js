angular.module("app").directive("notificationItem", ["$rootScope", function ($rootScope) {

    return {
        restrict: "E",
        replace: true,
        scope: {
            notification: "="
        },
        templateUrl:"/templates/directives/notification.html"
    }
}]);