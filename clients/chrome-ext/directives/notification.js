angular.module('notifications', ['ui-notification'])
    .config(function (NotificationProvider) {
        NotificationProvider.setOptions({
            delay: 10000,
            startTop: 20,
            startRight: 10,
            verticalSpacing: 20,
            horizontalSpacing: 20,
            positionX: 'left',
            positionY: 'bottom'
        })
    })
    .factory("notificationService", function ($rootScope, Notification, messengerService,$q) {

       var notifications = [];

        var dismissNotification = function (notificationId, callback) {
            messengerService.send("dismissNotification", {notificationId:notificationId}, function(data){

                notifications = notifications.filter(function( notification ) {
                    console.log(notification);
                    return notification.notificationId !== notificationId;
                });

                $rootScope.$broadcast('notificationCounterUpdate', notifications);
                callback();
            });
        };
        
        var notifyUserNow = function(){
            var sequence = Promise.resolve();
            notifications.filter(function(notification){
                return notification.type == "info-notification";
                return true;
            }).forEach(function(notification){
                sequence = sequence.then(function () {
                    return new Promise(function (resolve, reject) {

                        Notification(
                            {
                                title: notification.title,
                                message: notification.content,
                                positionY: "top",
                                positionX: "right",
                                delay: "60000",
                                templateUrl: "tpl/notifications/user-notification.html"
                            }, 'warning');

                        setTimeout(function () {
                            resolve();
                        }, 400);
                    })
                })
            });
        };

        function registerForPushNotifications(callback) {
            /*
                This function does the following things:

                1. Generates a device id if the device does not have one.
                2. Performs the association betwen the current user and the device id.
                3. Requests a notification token from gcm.
                4. Registers the notification token with the plusprivacy server.
             */
            messengerService.send("associateUserWithDevice", function (response) {
                messengerService.send("registerForPushNotifications", function (notification) {
                    messengerService.on("notificationReceived",treatPushNotification);
                    messengerService.send("notifyWhenLogout", stopPushNotifications);
                    callback();
                })
            })
        }

        function treatPushNotification (notification) {
            Notification(
                {
                    title: notification.data.data.title,
                    message: notification.data.data.description,
                    positionY: "top",
                    positionX: "right",
                    delay: "60000",
                    templateUrl: "tpl/notifications/user-notification.html"
                }, 'warning');
        }

        function stopPushNotifications(){
            messengerService.off("notificationReceived",treatPushNotification);
            messengerService.send("disassociateUserWithDevice", function () {
                alert("User was disassociated");
            });
        }
        
         function loadUserNotifications(callback) {
             registerForPushNotifications(function(){
                 var deferred = $q.defer();
                 messengerService.send("getNotifications", function (response) {
                     notifications = response.data;
                     deferred.resolve(notifications);
                     callback(notifications);
                 });

                 return deferred.promise;
             })
        }

        var getUserNotifications = function(callback){
            loadUserNotifications(callback);
        };

        return {
            dismissNotification: dismissNotification,
            notifyUserNow:notifyUserNow,
            getUserNotifications:getUserNotifications
        }
    });

angular.module('notifications')
    .directive('notificationCounter', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: function ($scope, notificationService) {
                $scope.notifications = {};
                notificationService.getUserNotifications(function(notifications){
                    $scope.notifications.counter = notifications.length;
                });

                $scope.$on('notificationCounterUpdate', function (event, notifications) {
                    console.log(notifications);
                    $scope.notifications.counter = notifications.length;
                    $scope.$apply();
                });
            },
            templateUrl: '/operando/tpl/notifications/notification-counter.html'
        }
    });

angular.module('notifications').
    directive('notifications', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: function ($scope, notificationService, $rootScope) {
                $scope.notifications = [];

                notificationService.getUserNotifications(function(notifications){
                    $scope.notifications = notifications;
                    $rootScope.$broadcast('notificationCounterUpdate', notifications);
                });
            },
            templateUrl: '/operando/tpl/notifications/notifications.html'
        }
    })
    .directive('notification', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {notification: "="},
            controller: function ($scope, notificationService, $state ) {
                    $scope.dismissed = false;
                    $scope.doNotShowNexTime = function () {

                        notificationService.dismissNotification($scope.notification.notificationId, function(){
                            setTimeout(function(){
                                $scope.dismissed = true;
                                $scope.$apply();
                            },500);

                        });
                };
                $scope.takeAction = function(actionName){

                    switch (actionName){
                        case "identity": $state.go('identityManagement'); break;
                        case "privacy-for-benefits": $state.go('deals'); break;
                        case "social-network-privacy":
                            notificationService.dismissNotification($scope.notification.notificationId, function(){
                                $state.go('socialNetworks');
                            });
                            break;
                    }
                }
            },
            templateUrl: '/operando/tpl/notifications/notification.html'
        }
    });



