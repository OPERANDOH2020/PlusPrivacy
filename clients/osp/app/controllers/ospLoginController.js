angular.module("ospApp").controller("ospLoginController", function ($scope, connectionService, userService, Notification) {

    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    $scope.submitLoginForm = function () {
        $scope.successMessage = false;
        $scope.requestProcessed = true;
        $scope.accountNotActivated = false;
        connectionService.loginUser($scope.user, function (user) {

                userService.setUser(user);
                Notification.success({
                    message: 'Logged in!',
                    positionY: 'bottom',
                    positionX: 'center',
                    delay: 2000
                });

                window.location.assign("/#offers");

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

    $scope.resendActivationCode = function(){
        $scope.requestProcessed = true;
        $scope.accountNotActivated = false;
        delete $scope.errorResponse;

        connectionService.resendActivationCode($scope.user.email, function(){
            $scope.successMessage = "Activation email sent! Check your inbox!";
            $scope.requestProcessed = false;
            $scope.$apply();
        }, function(error){
            delete $scope.successMessage;
            $scope.errorResponse = error;
            $scope.requestProcessed = false;
            $scope.$apply();
        })
    };

});

