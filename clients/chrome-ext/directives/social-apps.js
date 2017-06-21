angular.module('socialApps',[])
    .directive("socialApps", function (messengerService) {
        return {
            restrict: "E",
            replace: true,
            scope: {sn: "="},
            controller: function ($scope) {
                $scope.apps = [];
                messengerService.send("getFacebookApps", function(response){
                    if(response.status == "success"){
                        $scope.apps = response.data;
                        console.log(response.data);
                        $scope.$apply();
                    }

                })
            },
            templateUrl:"/operando/tpl/apps/sn_apps.html"
        }
    });
