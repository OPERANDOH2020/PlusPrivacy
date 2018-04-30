angular.module("operando").
controller("contactController", ["$scope", "messengerService", function ($scope, messengerService) {

    $scope.sendMessage = function(){
        $scope.sendingMessage = true;
        messengerService.send("contactMessage", {subject: $scope.subject, message: $scope.message}, function(response){
            $scope.requestWasMade = true;
            $scope.sendingMessage = false;
            if(response.status === "success"){
                $scope.messageSent = true;
            }else{
                $scope.messageSent = false;
            }
            $scope.$apply();
        });
    }

}]);
