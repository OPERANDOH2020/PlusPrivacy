angular.module("app").directive("progressBar", function () {
    return {
        restrict: "E",
        replace: true,
        scope: {
            eulas: "=",
            crawledEulas: "="
        },
        templateUrl: "/templates/directives/progress-bar.html",
        controller: function ($scope, $rootScope) {

            $scope.eulas.splice( 0, 0, {name:"start", completed:true} );
            $scope.$watch("crawledEulas",function(newValue, oldValue){

                    $scope.percentCompleted = 0;
                    $scope.crawledEulas.forEach(function (crawledEula) {

                        for (var i = 0; i < $scope.eulas.length; i++) {
                            if (crawledEula.name === $scope.eulas[i].name) {
                                $scope.eulas[i].status = crawledEula.status;
                                if(crawledEula.status!=="fetching"){
                                    $scope.eulas[i].completed = true;
                                    $scope.percentCompleted += 100 / ($scope.eulas.length - 1);
                                    break;
                                }
                            }
                        }

                    });
            },true);

        }
    }
})
