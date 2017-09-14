angular.module("operando").
controller("FeedbackController", ["$scope","$sce", "messengerService", function ($scope, $sce, messengerService) {

    $scope.answers = {};

    messengerService.send("provideFeedbackQuestions", function(response){
        $scope.feedbackQuestions = response.data;
        prepareResponses($scope.feedbackQuestions);
        $scope.$apply();
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
        console.log($scope.answers);
        messengerService.send("sendFeedback",$scope.answers, function(response){
            if(response.status === "success"){
                $scope.feedbackSubmitted = true;
                $scope.$apply();
            }
        })
    }

}]);
