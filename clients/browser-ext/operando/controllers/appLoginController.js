angular.module("operando").
controller("appLoginController", ["$scope", "ModalService","i18nService","$state", function ($scope, ModalService, i18nService, $state) {

    $scope.featureMessages = {
        "identityManagement":i18nService._("identityManagementUsage"),
        "deals":i18nService._("dealsUsage"),
        "contact":i18nService._("contactUsage")
    };


    if($scope.featureMessages[$state.current.name]){
        $scope.featureMessage  = $scope.featureMessages[$state.current.name];
    }

    $scope.displayLoginModal = function () {

        ModalService.showModal({
            templateUrl: '/tpl/modals/not_logged_in.html',
            controller: ["$scope", "close", "messengerService", function ($scope, close) {

                $scope.close = function (result) {
                    close(result, 100);
                };

                $scope.$on("dismissLoginModal", function () {
                    $scope.close();
                });
            }
            ]
        }).then(function (modal) {
            modal.element.modal({
                    backdrop: 'static'
                }
            );
            modal.close.then(function () {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            })
        })
    };

}]);
