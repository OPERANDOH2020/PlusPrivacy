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

        function treatPushNotification (notification) {
            Notification(
                {
                    title: notification.data.title,
                    message: notification.data.description,
                    positionY: "top",
                    positionX: "right",
                    delay: "60000",
                    templateUrl: "tpl/notifications/user-notification.html"
                }, 'warning');
        };

         function loadUserNotifications(callback) {
                 var deferred = $q.defer();
                 messengerService.send("getNotifications", function (response) {
                     notifications = response.data;
                     deferred.resolve(notifications);
                     callback(notifications);
                 });
                 return deferred.promise;
        }

        var getUserNotifications = function(callback){
            loadUserNotifications(callback);
        };

        if(chrome.gcm){
            chrome.gcm.onMessage.addListener(treatPushNotification);
        }
        else{
            //TODO implement it for other browsers.

        }



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
                    $scope.notifications.counter = notifications.length;
                    $scope.$apply();
                });
            },
            templateUrl: '/tpl/notifications/notification-counter.html'
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
            templateUrl: '/tpl/notifications/notifications.html'
        }
    })
    .directive('notification', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {notification: "="},
            controller: function ($scope, notificationService, $state, $window ) {
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
                        case "feedback": $state.go('feedback'); break;
                        case "openUrl": $window.open($scope.notification['action_argument']); break;
                        case "social-network-privacy":
                            notificationService.dismissNotification($scope.notification.notificationId, function(){
                                $state.go('socialNetworks');
                            });
                            break;
                    }
                }
            },
            templateUrl: '/tpl/notifications/notification.html'
        }
    });



