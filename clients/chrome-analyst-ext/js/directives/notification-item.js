angular.module("app").directive("notificationItem", [function () {

    return {
        restrict: "E",
        replace: true,
        scope: {
            notification: "="
        },
        templateUrl:"/templates/directives/notification.html"
    }
}]);

angular.module("app").directive("notificationLarge", ["ModalService","connectionService",function (ModalService,connectionService) {
    return {
        restrict: "E",
        replace: true,
        scope: {
            notification: "="
        },
        templateUrl:"/templates/directives/notification-large.html",
        controller:function($scope, $rootScope){

            function resolveNotification(notificationId){

                $scope.$apply();
            }

            $scope.resolve = function(){
                var notification = $scope.notification;
                ModalService.showModal({
                    templateUrl: '/templates/modals/resolve_notification.html',
                    controller: function ($scope, close) {
                        $scope.notification = notification;
                        $scope.resolve = function(){
                            connectionService.dismissNotification($scope.notification.notificationId,function(){
                                $rootScope.$broadcast("notificationResolved",$scope.notification.notificationId);
                            })
                        };
                        $scope.close = function (result) {
                            close(result, 500);
                        };
                    }
                }).then(function (modal) {
                    modal.element.modal();
                });
            }
        }
    }
}]);