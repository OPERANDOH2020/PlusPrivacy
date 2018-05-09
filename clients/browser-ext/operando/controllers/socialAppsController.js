angular.module("operando").
controller("socialAppsController", ["$scope","ospService", function ($scope,ospService) {
    $scope.sns = ['google','facebook', 'linkedin', 'twitter','dropbox'];


    var socialNetworks = {
        facebook: "Facebook",
        linkedin: "LinkedIn",
        twitter: "Twitter",
        google: "Google"

    }

    ospService.getOSPs(function (osps) {
        $scope.osps = [];
        osps.forEach(function (osp) {

            ospService.getOSPSettings(function (settings) {
                $scope.osps.push({
                    key: osp.toLowerCase(),
                    title: socialNetworks[osp.toLowerCase()],
                    settings: settings
                });
            }, osp);

        });
    });

}]);
