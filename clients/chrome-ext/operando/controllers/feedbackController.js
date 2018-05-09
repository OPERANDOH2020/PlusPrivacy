angular.module("operando").
controller("FeedbackController", ["$scope","$sce", "messengerService", function ($scope, $sce, messengerService) {

    $scope.answers = {};
    $scope.previousResponses = {};

    function loadFeedback(callback){
        messengerService.send("provideFeedbackQuestions", function(response){
            $scope.feedbackQuestions = response.data;
            prepareResponses($scope.feedbackQuestions);
            if(callback){
                callback();
            }
            $scope.$apply();
        });
    }

    messengerService.send("hasUserSubmittedAFeedback", function(response){
       if(response.status === "success"){
           if(Object.keys(response.data).length === 0){
               $scope.feedbackSubmitted = false;
               loadFeedback();
           }
           else{
               $scope.previousResponses = response.data;
               $scope.feedbackSubmitted = true;
               $scope.$apply();
           }
       }
    });

    function prepareResponses(questions){

        questions.forEach(function(question){
            switch (question.type){
                case "multipleRating" :
                    question.items.forEach(function(item){
                        $scope.answers[question.title+"["+item+"]"] = "";
                    });
                    break;
                case "multipleSelection" :
                    question.items.forEach(function(item){
                        $scope.answers[question.title+"["+item+"]"] = "";
                    });
                    break;
                case "textInput" :
                    $scope.answers[question.title] = "";
                    break;
                case "radio" :
                    $scope.answers[question.title] = "";
                    break;

            }
        });

    }

    $scope.submitFeedback = function(){
        messengerService.send("sendFeedback",$scope.answers, function(response){
            if(response.status === "success"){
                $scope.feedbackSubmitted = true;
                $scope.$apply();
            }
        })
    };

    $scope.editFeedback = function () {
        loadFeedback(function () {
            $scope.feedbackSubmitted = false;

            messengerService.send("hasUserSubmittedAFeedback", function (response) {
                if (Object.keys(response.data).length >= 0) {
                    $scope.previousResponses = response.data;
                    for (var i in $scope.answers) {
                        if ($scope.previousResponses[i]) {
                            $scope.answers[i] = $scope.previousResponses[i];
                        }
                    }
                }
                $scope.$apply();
            });
        });
    }

}]);
