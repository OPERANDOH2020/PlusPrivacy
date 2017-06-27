angular.module("ospApp").controller("OSPSignupController", function ($scope, connectionService) {

    $scope.requestInProgress = false;
    $scope.user = {};
    $scope.success = false;
    $scope.register = function(){

        $scope.registerError = false;
        $scope.requestInProgress = true;

        connectionService.registerNewOSPOrganisation($scope.user, function (success) {
            console.log(success);
            $scope.requestInProgress = false;
            $scope.success = true;
            $scope.$apply();

        }, function(error){
            $scope.requestInProgress = false;
            $scope.registerErrorMessage = error;
            $scope.registerError = true;
            $scope.$apply();
        })
    };

    $scope.acceptTermsAndConditions = function(){
        $scope.user.accept_conditions = true;
        $scope.$apply();
    };

});

