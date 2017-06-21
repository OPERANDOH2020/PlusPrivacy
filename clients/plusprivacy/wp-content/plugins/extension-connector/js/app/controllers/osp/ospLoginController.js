privacyPlusApp.controller("ospLoginController", function ($scope, connectionService, messengerService, userService,SharedService,$window) {

    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    $scope.submitLoginForm = function () {
        $scope.successMessage = false;
        $scope.requestProcessed = true;
        $scope.accountNotActivated = false;
        connectionService.loginUser($scope.user, "OSP", function (user) {

                $window.location="/osp-offers";

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

    SharedService.setLocation("ospLogin");

});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('osp_login'), ['plusprivacy']);
});