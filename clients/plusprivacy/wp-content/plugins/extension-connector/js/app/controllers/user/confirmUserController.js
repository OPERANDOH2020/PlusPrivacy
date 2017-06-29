privacyPlusApp.controller("confirmUserController", function ($scope, $location, connectionService,$window) {

    $scope.loadingData = true;
    var confirmationCode = getParameterByName("confirmation_code");

    if(confirmationCode){
            connectionService.activateUser(confirmationCode, function (validatedUserSession) {
                    $scope.verifyUserStatus = "Email verification successful.";
                    $scope.status="success";
                    $scope.loadingData = false;
                    $scope.$apply();

                    connectionService.restoreUserSession(function(){
                        connectionService.generateAuthenticationToken(function(userId, authenticationToken){
                            messengerService.send("authenticateUserInExtension", {
                                userId: userId,
                                authenticationToken: authenticationToken
                            }, function(){});
                        });
                    },function(){
                        console.log("Could not restore user session!");
                    });
                },
                function(){
                    $scope.verifyUserStatus = "You provided an invalid validation code";
                    $scope.status="danger";
                    $scope.loadingData = false;
                    $scope.$apply();
                });
    }

    $scope.goToDashboard = function(){
        $window.location = "/user-dashboard";
    }

});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('confirm-account'), ['plusprivacy']);
});

