ospApp.requires.push('ngIntlTelInput');

ospApp
    .config(function (ngIntlTelInputProvider) {
        ngIntlTelInputProvider.set({
            initialCountry: 'gb',
            customPlaceholder: function(selectedCountryPlaceholder, selectedCountryData) {
                return "Phone e.g. " + selectedCountryPlaceholder;
            }
        });
    });
ospApp.controller("OSPSignupController", function ($scope, connectionService, SharedService) {

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

    SharedService.setLocation("ospRegister");
});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('osp_register'), ['plusprivacy']);
});