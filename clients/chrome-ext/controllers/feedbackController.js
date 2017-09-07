angular.module("operando").
controller("FeedbackController", ["$scope","$sce", "messengerService", function ($scope, $sce, messengerService) {

    messengerService.send("provideFeedbackQuestions", function(response){
        $scope.feedbackQuestions = response.data;
        console.log($scope.feedbackQuestions);
    });
}]);
