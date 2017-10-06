'use strict';
app.controller('notificationsController', ['$scope','ModalService','swarmHubService',
    function ($scope,ModalService,swarmHubService) {

        var swarmHub = swarmHubService.hub;

        $scope.notification = {};
        $scope.notificationWasSent = false;
        $scope.errorOccured = false;


        swarmHub.startSwarm("zones.js","getAllZones");


        $scope.add = function() {
            var f = document.getElementById('file').files[0];
            var r = new FileReader();

            r.onloadend = function(e) {
                $scope.notification.users = e.target.result.split(new RegExp("\",\ ")).filter(function (user) {
                    return user.length>1;
                });
                delete $scope.notification.zone;
            }
            r.readAsText(f);
        };


        $scope.sendNotification = function(){
            if($scope.notification.actionType !==undefined){
                $scope.notification.action = $scope.notification.actionType;
                if($scope.notification.actionArgument !==undefined){
                    $scope.notification.action+=" with argument: "+$scope.notification.actionArgument
                }
            }

            if($scope.notification.zone){
                delete $scope.notification.users;
            }

            $scope.notificationWasSent = false;
            $scope.errorOccured = false;

            ModalService.showModal({
                templateUrl: "tpl/modals/previewNotification.html",
                controller: "previewNotificationController",
                inputs:{
                    "notification":$scope.notification
                }
            }).then(function(modal) {
                modal.element.modal();
                modal.close.then(function(notification) {
                    swarmHub.startSwarm("notification.js","sendNotification",notification);
                });
            });
        };

        swarmHub.on("notification.js","notificationSent",function(swarm){
            $scope.notificationWasSent = true;
            $scope.notification = {};
            $scope.$apply();
        });

        swarmHub.on("notification.js","failed",function(swarm){
            $scope.errorOccured = true;
            console.log("Error "+swarm.err+" occured")
        });

        swarmHub.on("zones.js","gotAllZones",function(swarm){
            $scope.zones = swarm.zones;
            $scope.$apply();
        });

    }]);

app.controller('previewNotificationController', ['$scope',"notification","$element",'close', function($scope,notification,$element, close) {
    var template={
        "title":"Title: ",
        "zone":"Receivers: ",
        "users":"Receivers: ",
        "type":"Type of notification: ",
        "category":"Category: ",
        "description":"Description: ",
        "action":"Action to take: "
    };

    $scope.notification = notification;


    $scope.previewNotification = {};
    for(var field in template){
        if($scope.notification[field]) {
            $scope.previewNotification[field] = template[field] + notification[field];
            if($scope.previewNotification[field].length>500){
                $scope.previewNotification[field] = $scope.previewNotification[field].slice(0,497)+"...";
            }
        }
    }

    console.log($scope.notification,$scope.previewNotification);

    $scope.send = function(){
        $scope.notification.expirationDate = new Date($scope.notification.expirationDate);
        $element.modal('hide');
        close($scope.notification,500);
    }
}]);
