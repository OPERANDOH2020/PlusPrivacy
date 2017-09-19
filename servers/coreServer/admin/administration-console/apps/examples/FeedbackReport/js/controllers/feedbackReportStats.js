'use strict';
app.controller('feedbackReportStatsController', ['$scope','ModalService','swarmHubService',function($scope,ModalService,swarmHubService){

    var swarmHub = swarmHubService.hub;

    var getAllFeedbackHandler = swarmHub.startSwarm("feedback.js","getAllFeedback");
    getAllFeedbackHandler.onResponse("success",function(swarm){
        console.log(swarm.feedbackResponses);
    });


    var getAllQuestionsHandler = swarmHub.startSwarm("feedback.js","getFeedbackQuestions");
    getAllQuestionsHandler.onResponse("success",function(swarm){
        console.log(swarm.feedbackQuestions);
    });




    function prepareResponses(){

    }


    $scope.labels = ["January", "February", "March", "April", "May", "June", "July"];
    $scope.series = ['Series A', 'Series B'];
    $scope.data = [
        [65, 59, 80, 81, 56, 55, 40],
        [28, 48, 40, 19, 86, 27, 90]
    ];
    $scope.onClick = function (points, evt) {
        console.log(points, evt);
    };
    $scope.datasetOverride = [{ yAxisID: 'y-axis-1' }, { yAxisID: 'y-axis-2' }];
    $scope.options = {
        scales: {
            yAxes: [
                {
                    id: 'y-axis-1',
                    type: 'linear',
                    display: true,
                    position: 'left'
                },
                {
                    id: 'y-axis-2',
                    type: 'linear',
                    display: true,
                    position: 'right'
                }
            ]
        }
    };


}]);
