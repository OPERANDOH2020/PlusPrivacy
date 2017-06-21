privacyPlusApp.controller("loginController", function ($scope, connectionService, messengerService, userService, SharedService, $window) {

    $scope.authenticationError = false;
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
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user, "Public", function (user) {
                $window.location = "/user-dashboard";

            },
            function (error) {

                if (error == "account_not_activated") {
                    $scope.errorResponse = "Account not activated!";
                }
                else {
                    $scope.errorResponse = "Invalid credentials!";
                }

                $scope.requestProcessed = false;
                $scope.authenticationError = true;
                $scope.$apply();
            });
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