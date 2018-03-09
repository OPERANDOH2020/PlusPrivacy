angular.module("operando").
controller("appLoginController", ["$scope", "ModalService", function ($scope, ModalService) {


    setTimeout(function(){
        ModalService.showModal({

            templateUrl: '/operando/tpl/modals/not_logged_in.html',
            controller: ["$scope", "close", "messengerService", function ($scope, close, messengerService) {

                $scope.close = function (result) {
                    close(result, 500);
                };
            }
            ]
        }).then(function (modal) {
            modal.element.modal();
        })
    },200);



}]);
