angular.module("ospApp").controller("confirmOSPController", function ($scope, $location, connectionService,$stateParams,$window) {

    $scope.loadingData = true;
    var confirmationCode = $stateParams['verifyCode'];

    if(confirmationCode){
        connectionService.activateUser(confirmationCode, function (validatedUserSession) {
                $scope.verifyUserStatus = "Email verification successful. Please wait for the OSP membership confirmation email";
                $scope.status="success";
                $scope.loadingData = false;
                $scope.$apply();
            },
            function(){
                $scope.verifyUserStatus = "You provided an invalid validation code";
                $scope.status="danger";
                $scope.loadingData = false;
                $scope.$apply();
            });
    }

    $scope.goToOffers = function(){
        $window.location = "/#offers";
    }

});
