angular.module("operando").
controller("appLoginController", ["$scope", "ModalService","$state", function ($scope, ModalService, $state) {

    switch($state.current.name){
        case "identityManagement": $scope.featureName = "identity management"; break;
        case "deals": $scope.featureName = "deals"; break;
        case "contact": $scope.featureName = "contact"; break;
    }

    $scope.displayLoginModal = function () {

        ModalService.showModal({
            templateUrl: '/operando/tpl/modals/not_logged_in.html',
            controller: ["$scope", "close", "messengerService", function ($scope, close) {

                $scope.close = function (result) {
                    close(result, 100);
                };

                $scope.$on("dismissLoginModal",function(){
                    $scope.close();
                });


            }
            ]
        }).then(function (modal) {
            modal.element.modal({
                    backdrop: 'static'
                }
            );
            modal.close.then(function(){
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            })
        })
    };

}]);
