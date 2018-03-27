angular.module("login",[]).
    directive("loginForm", function(){
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl:"/operando/tpl/login/login.html",
        controller:["$scope","$rootScope","messengerService","Notification","i18nService", function($scope, $rootScope, messengerService,Notification,i18nService){

            $scope.currentView = "login";
            $scope.user = {remember_me:true};
            $scope.new_user = {};

            $scope.login = function(){
                $scope.submitRequest.button('loading');
                messengerService.send("authenticateUser", {
                        email: $scope.user.email,
                        password: $scope.user.password,
                        remember_me: $scope.user.remember_me
                }, function (response) {
                    if (response.status === "success") {
                        Notification.success({message: 'You have successfully logged in!', positionY: 'bottom', positionX: 'center', delay: 2000});
                    }
                    else if (response.error)
                    {
                        $scope.submitRequest.button('reset');
                        Notification.error({message: i18nService._(response.error), positionY: 'bottom', positionX: 'center', delay: 2000});
                    }
                });
            }

            $scope.recover_password = function(){
                $scope.submitRequest.button('loading');
                messengerService.send("resetPassword", $scope.user['reset_email'], function (response) {
                    $scope.submitRequest.button('reset');
                    if(response.status === "success"){
                        Notification.success({message: "Check your email!", positionY: 'bottom', positionX: 'center', delay: 3000});
                        delete $scope.user['reset_email'];
                        $scope.currentView = "login";

                    }
                    else {
                        Notification.error({message: i18nService._(response.error), positionY: 'bottom', positionX: 'center', delay: 2000});
                    }
                })
            };

            $scope.signup = function(){
                $scope.submitRequest.button('loading');
                messengerService.send("registerUser",$scope.new_user, function(response){
                    $scope.submitRequest.button('reset');
                    if(response.status === "success"){
                        Notification.success({message: "Account successfully created! Check your email to confirm registration!", positionY: 'bottom', positionX: 'center', delay: 3000});
                         $scope.user.email = $scope.new_user.email;
                        $scope.currentView = "login";

                    }
                    else {
                        Notification.error({message: i18nService._(response.error), positionY: 'bottom', positionX: 'center', delay: 2000});
                    }
                });

            };

            $scope.show_signup = function(){
                $scope.currentView = "signup";
            };

            $scope.show_login = function(){
                $scope.currentView = "login";
            };

            $scope.show_forgot_password = function(){
                $scope.currentView = "forgot_password";
            }

            $scope.loading = function($event){
                $scope.submitRequest = $($event.currentTarget);
            }
        }]

    }
});
