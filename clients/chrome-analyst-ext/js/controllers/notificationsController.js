angular.module("app").
controller("notificationController", ["$scope", "connectionService", function ($scope, connectionService) {

    $scope.notifications = [];

    $scope.loadMore = function(){
        connectionService.getNotifications($scope.notifications.length, function(data){
            var notifications = data.notifications;
            notifications.forEach(function(notification){
                $scope.notifications.push(notification);
            });
            $scope.$apply();
        });
    };

    var notificationResolved = function(notificationId){
        for(var i = 0; i<$scope.notifications.length; i++){
            if($scope.notifications[i].notificationId == notificationId){
                $scope.notifications[i].isDismissed = true;
                break;
            }
        }
        $scope.$apply();
    };

    $scope.$on("notificationResolved",function(event, notificationId){
        notificationResolved(notificationId);
    });


    $scope.loadMore();

}]);