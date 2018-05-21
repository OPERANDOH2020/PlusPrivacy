angular.module("operando").
controller("socialAppsController", ["$scope","ospService","ExtensionService", function ($scope,ospService,ExtensionService) {
    $scope.sns = ['google','facebook', 'linkedin', 'twitter','dropbox'];


    ExtensionService.isBrowserFirefox(function(isFirefox){
        $scope.isFirefox = isFirefox;

        if(isFirefox){
            $scope.browserExtensionsLabel = "Firefox Add-ons"
        }
        else{
            $scope.browserExtensionsLabel = "Chrome Extensions";
        }
    });

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
