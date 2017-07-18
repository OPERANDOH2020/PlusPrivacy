privacyPlusApp.controller("resetPasswordController", function ($scope, connectionService) {

    var resetId = getParameterByName("reset_id");
    $scope.resetButtonIsDisabled = true;
    $scope.user ={
        password:"",
        repeat_password:""
    };


    $scope.checkPasswords = function () {
        $scope.resetButtonIsDisabled = true;
        var user = $scope.user;

        if (user.password.length >= 4) {
            $scope.strength = {
                text: checkPassStrength(user.password),
                score: scorePassword(user.password)
            }
        }
        else {
            if ($scope.strength) {
                delete $scope.strength;
            }
        }

        if (user.password.length >= 4 && user.repeat_password.length >= 4) {
            if (user.password === user.repeat_password) {
                $scope.resetButtonIsDisabled = false;
                if ($scope.errorMessage) {
                    delete $scope.errorMessage;
                }
            }
            else {
                $scope.errorMessage = "Passwords don't match";
            }
        }
        else {
            if (user.repeat_password.length != 0) {
                $scope.errorMessage = "Password must have at least 4 characters";
            }

        }
    }

    $scope.resetPassword = function () {
        $scope.requestInProgress = true;
        connectionService.resetPassword(resetId, $scope.user.password, function(){
            $scope.requestInProgress = false;
            $scope.passwordChanged = true;
            $scope.$apply();
        },
        function(error){
            $scope.requestInProgress = false;
            $scope.errorMessage = error;
            $scope.$apply();
        })


    }

});

angular.element(document).ready(function () {
    angular.bootstrap(document.getElementById('reset-user-password'), ['plusprivacy']);
});
