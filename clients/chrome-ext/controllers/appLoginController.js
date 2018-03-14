angular.module("operando").
controller("appLoginController", ["$scope", "ModalService", function ($scope, ModalService) {

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
