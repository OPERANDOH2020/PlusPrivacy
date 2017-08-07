angular.module("operando").
controller("contactController", ["$scope", "messengerService","$window","$state", function ($scope, messengerService, $window, $state) {


    $scope.sendMessage = function(){
        $scope.sendingMessage = true;
        messengerService.send("contactMessage", {subject: $scope.subject, message: $scope.message}, function(response){
            $scope.sendingMessage = false;
        });
    }

}]);
