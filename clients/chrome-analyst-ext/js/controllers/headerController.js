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

    var notificationsHandler = function(notifications){
        $scope.notifications = notifications;
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

    connectionService.getNotifications(notificationsHandler);

    connectionService.onNotificationReceived(handlePushedNotifications);

}]);
