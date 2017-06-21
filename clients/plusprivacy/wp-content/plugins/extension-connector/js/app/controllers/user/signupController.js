privacyPlusApp.controller("signupController", function ($scope, connectionService,SharedService) {

$scope.requestInProgress = false;
$scope.user = {};
$scope.success = false;
$scope.register = function(){

    $scope.registerError = false;
    $scope.requestInProgress = true;

    connectionService.registerNewUser($scope.user, function (success) {
        console.log(success);
        $scope.requestInProgress = false;
        $scope.success = true;
        $scope.$apply();

    }, function(error){
        $scope.requestInProgress = false;
        $scope.registerErrorMessage = error;
        $scope.registerError = true;
        $scope.$apply();
    });
};
    SharedService.setLocation("userRegister");
});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('user_register'), ['plusprivacy']);
});