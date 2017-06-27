privacyPlusApp.controller("loginController", function ($scope, connectionService, messengerService, userService, SharedService, $window) {

    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    /*userService.isAuthenticated(function (isAuthenticated) {
        $scope.userIsLoggedIn = isAuthenticated;
        $scope.$apply();
    });*/

    userService.getUser(function (user) {
        $scope.userIsLoggedIn = true;
        $scope.currentUser = user.email;
        $window.location = "/user-dashboard";
    });

    $scope.submitLoginForm = function () {
        $scope.successMessage = false;
        $scope.requestProcessed = true;
        $scope.accountNotActivated = false;
        delete $scope.errorResponse;
        connectionService.loginUser($scope.user, function (user) {
                $window.location = "/user-dashboard";

            },
            function (error) {

                if (error == "accountNotActivated") {
                    $scope.errorResponse = "Account not activated!";
                    $scope.accountNotActivated = true;
                }
                else {
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


    /*setTimeout(function () {
        var relayResponded = messengerService.extensionIsActive();
        if (relayResponded === false) {
            $scope.extension_not_active = true;
            $scope.$apply();
        }
    }, 1000);*/

    SharedService.setLocation("userLogin");
});

angular.element(document).ready(function () {
    angular.bootstrap(document.getElementById('login'), ['plusprivacy']);
});