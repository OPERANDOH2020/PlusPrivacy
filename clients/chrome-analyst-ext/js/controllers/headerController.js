angular.module("app").
controller("headerController", ["$scope", "$state", "ospService","connectionService", function ($scope, $state, ospService, connectionService) {

    var socialNetworks = {
        facebook: "Facebook",
        linkedin: "LinkedIn",
        twitter: "Twitter",
        google: "Google"

    };
    ospService.getOSPs(function (osps) {
        $scope.osps = [];
        osps.forEach(function (osp) {

            ospService.getOSPSettings(function (settings) {
                $scope.osps.push({
                    key: osp.toLowerCase(),
                    title: socialNetworks[osp.toLowerCase()],
                    settings: settings
                });
            }, osp);

        });
    });

    var notificationsHandler = function(data){
        $scope.notifications = data.notifications;
        $scope.notificationsCount = data.count;
        $scope.$apply();
    };

    var handlePushedNotifications = function(notification){
        chrome.notifications.create("newPushedNotification",{
            type:'basic',
            iconUrl:"/assets/images/icons/bell.png",
            title:notification.data.title,
            message:"New analyst notification!",
            buttons:[
                {
                    title:"Take action",
                    iconUrl:"/assets/images/icons/take_action.png"

                },
                {
                    title:"Dismiss",
                    iconUrl:"/assets/images/icons/dismiss.png"

                }
            ],
            requireInteraction:true
        });
    };

    connectionService.getNotifications(0,notificationsHandler);

    connectionService.onNotificationReceived(handlePushedNotifications);

    $scope.seeAllNotifications = function(){
        $state.go("dashboard.notifications");
    }

}]);
