angular.module("login",[]).
    directive("loginForm", function(){
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl:"/operando/tpl/login/login.html",
        controller:["$scope","messengerService","Notification","$state", function($scope, messengerService,Notification,$state){

            $scope.currentView = "login";

            $scope.user = {remember_me:true};
            $scope.new_user = {};

            $scope.login = function(){
                messengerService.send("login", {
                    login_details: {
                        email: $scope.user.email,
                        password: $scope.user.password,
                        remember_me: $scope.user.remember_me
                    }
                }, function (response) {
                    if (response.success) {
                        Notification.success({message: 'You have successfully logged in!', positionY: 'bottom', positionX: 'center', delay: 2000});
                    }
                    else if (response.error)
                        Notification.error({message: 'Invalid credentials', positionY: 'bottom', positionX: 'center', delay: 2000});
                });
            }

            $scope.recover_password = function(){

            }

            $scope.signup = function(){

                messengerService.send("registerUser",{user:$scope.new_user}, function(response){

                    if(response.status == "success"){
                        Notification.success({message: "Account successfully created!", positionY: 'bottom', positionX: 'center', delay: 3000});
                         $scope.user.email = $scope.new_user.email;
                        $scope.currentView = "login";

                    }
                    else if(response.status == "error"){
                        Notification.error({message: response.message, positionY: 'bottom', positionX: 'center', delay: 2000});
                    }
                });

            }

            $scope.show_signup = function(){
                $scope.currentView = "signup";
            }

            $scope.show_login = function(){
                $scope.currentView = "login";
            }

            $scope.show_forgot_password = function(){
                $scope.currentView = "forgot_password";
            }
        }]

    }
})
