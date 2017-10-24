angular.module("app").
controller("eulaController", ["$scope","$stateParams","connectionService","Notification","ModalService", function($scope, $stateParams, connectionService, Notification,ModalService) {

    $scope.eulaName = $stateParams.eula;
    $scope.osp = $stateParams.osp;

    connectionService.getEulaChanges($scope.eulaName, function(pages){
        $scope.images = pages;
        console.log($scope.images);
        $scope.$apply();
    });

    $scope.runCrawler = function(){


        ModalService.showModal({
            templateUrl: '/templates/modals/crawler.html',
            controller: function ($scope, close) {
                $scope.crawledEulas = [];

                $scope.runCrawler = function(){

                    connectionService.getEulas(function(eulas){
                        $scope.eulas = eulas;
                        $scope.$apply();
                        connectionService.runCrawler(function(data){
                            $scope.crawledEulas.push(data);
                            $scope.$apply();
                        });

                    });
                };
                $scope.close = function (result) {
                    close(result, 500);
                };
            }
        }).then(function (modal) {
            modal.element.modal();
        });






    }

}]);
