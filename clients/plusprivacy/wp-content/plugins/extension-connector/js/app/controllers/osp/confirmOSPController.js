function getParameterByName(name, url) {
    if (!url) {
        url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

privacyPlusApp.controller("confirmOSPController", function ($scope, $location, connectionService,$window) {

    $scope.loadingData = true;
    var confirmationCode = getParameterByName("confirmation_code");

    if(confirmationCode){
        connectionService.activateUser(confirmationCode, function (validatedUserSession) {
                $scope.verifyUserStatus = "Email verification successful. Please wait for the OSP membership confirmation email";
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
    angular.bootstrap(document.getElementById('confirm-osp-account'), ['plusprivacy']);
});

