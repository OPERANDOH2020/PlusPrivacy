angular.module("app").controller("loginController", function($scope, connectionService, userService, Notification,$state){
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };


    $scope.submitLoginForm = function () {
        $scope.successMessage = false;
        $scope.requestProcessed = true;
        $scope.accountNotActivated = false;
        delete $scope.errorResponse;
        connectionService.loginUser($scope.user, function (user) {

                userService.setUser(user);
                Notification.success({
                    message: 'Logged in!',
                    positionY: 'bottom',
                    positionX: 'center',
                    delay: 2000
                });

                $state.go("dashboard.socialNetworks");

            },
            function (error) {

                if(error == "accountNotActivated"){
                    $scope.errorResponse = "Account not activated!";
                    $scope.accountNotActivated = true;
                }
                else
                if(error == "accessDenied"){
                    $scope.errorResponse = "Access denied! Your OSP account wasn't activated yet!";
                }else{
                    $scope.errorResponse = "Invalid credentials!";
                }
                $scope.requestProcessed = false;
                $scope.$apply();
            });
    };


});