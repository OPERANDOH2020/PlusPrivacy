pspApp.controller("pspLoginController", function ($scope, connectionService, messengerService, userService,Notification) {
    $scope.authenticationError = false;
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    $scope.submitLoginForm = function () {
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user,  function (user) {

                userService.setUser(user);
                Notification.success({
                    message: 'Logged in!',
                    positionY: 'bottom',
                    positionX: 'center',
                    delay: 2000
                });

                window.location.assign("/#/osp-requests");

            },
            function (error) {

                if(error == "account_not_activated"){
                    $scope.errorResponse = "Account not activated!";
                }
                else{
                    $scope.errorResponse = "Invalid credentials!";
                }

                $scope.requestProcessed = false;
                $scope.authenticationError = true;
                $scope.$apply();
            });
    };


});
