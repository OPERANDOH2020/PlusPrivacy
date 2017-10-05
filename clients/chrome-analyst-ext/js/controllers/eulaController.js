angular.module("app").
controller("eulaController", ["$scope","$stateParams","settings","connectionService","Notification","ModalService", function($scope, $stateParams, settings, connectionService, Notification,ModalService) {

    if (!$stateParams.sn) {
        $scope.osp = {
            key: 'facebook',
            title: 'Facebook',
            settings: settings['facebook']
        }
    }

}]);
