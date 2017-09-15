'use strict';
app.controller('feedbackReportStatsController', ['$scope','ModalService','swarmHubService',function($scope,ModalService,swarmHubService){

    var swarmHub = swarmHubService.hub;


    swarmHub.startSwarm("feedback.js","getAllFeedback");




}]);
