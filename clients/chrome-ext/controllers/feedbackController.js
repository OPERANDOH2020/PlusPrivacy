angular.module("operando").
controller("FeedbackController", ["$scope","$sce", "messengerService", function ($scope, $sce, messengerService) {

    messengerService.send("provideFeedbackUrl", function(response){
        $scope.feedbackUrl = $sce.trustAsResourceUrl(response.data+"/viewform?embedded=true");
        $scope.$apply();
    });
}]);
