angular.module("operando").
controller("appLoginController", ["$scope", "ModalService","$state", function ($scope, ModalService, $state) {

    $scope.featureMessages = {
        "identityManagement":"To use Identity management feature, you need to log in with your email address.",
        "deals":"To use the deals feature, you need to log in with your email address.",
        "contact":"To use the contact feature, you need to log in with your email address. If you don't want to authenticate or to reveal your real address to us, you can send your request via the <a href='operando.html#/feedback'>feedback</a> form or send an email at <a href='mailto:contact@plusprivacy.com'>contact@plusprivacy.com</a>."
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
