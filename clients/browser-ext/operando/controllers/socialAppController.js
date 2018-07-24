angular.module("operando").
controller("socialAppController",["$scope", "$stateParams", "messengerService","ospService", "i18nService", function ($scope, $stateParams, messengerService,ospService, i18nService) {

    var socialNetworks = {
        facebook: "Facebook",
        linkedin: "LinkedIn",
        twitter: "Twitter",
        google: "Google",
        dropbox: "Dropbox"
    };

    $scope.sn = $stateParams.sn;

    $scope.appsConnectedToAccountLabel = i18nService._("appsConnectedToAccount",{sn:socialNetworks[$scope.sn]});
    ospService.getOSPSettings(function(settings){
        if (!$stateParams.sn) {
            $scope.osp = {
                key: 'facebook',
                title: socialNetworks['facebook'],
                settings: settings['facebook']
            }

        }
        else {
            $scope.osp = {
                key: $stateParams.sn,
                title: socialNetworks[$stateParams.sn.toLowerCase()],
                settings: settings[$stateParams.sn]
            }
        }

    });

    function retrieveUserLoggedInAccount(socialNetwork) {
        messengerService.send("getMyLoggedinEmail", socialNetwork, function (response) {
            if (response.status === "success") {

                var encodedStr = response.data.account;
                var parser = new DOMParser();
                var dom = parser.parseFromString(
                    '<!doctype html><body>' + encodedStr,
                    'text/html');
                var decodedString = dom.body.textContent;

                $scope.socialNetworkEmail = {
                    account: decodedString,
                    type: response.data.type
                };
                $scope.authenticated = true;
            } else{
                $scope.authenticated = false;
            }
            $scope.$apply();
        });
    }

    var socialNetworkReadyHandler  =  function (event, socialNetwork) {
            retrieveUserLoggedInAccount(socialNetwork);
    };

    $scope.$on("socialNetworkReady", socialNetworkReadyHandler);


}]);
