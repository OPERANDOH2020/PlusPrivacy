'use strict';
app.controller('feedbackReportStatsController', ['$scope', 'ModalService', 'swarmHubService', function ($scope, ModalService, swarmHubService) {

    var swarmHub = swarmHubService.hub;
    $scope.statistics = {};
    $scope.textResponses = [];
    $scope.charts = [];

    var getAllFeedbackHandler = swarmHub.startSwarm("feedback.js", "getAllFeedback");
    getAllFeedbackHandler.onResponse("success", function (swarm) {
        $scope.feedbackResponses = swarm.feedbackResponses;
        var getAllQuestionsHandler = swarmHub.startSwarm("feedback.js", "getFeedbackQuestions");
        getAllQuestionsHandler.onResponse("success", function (swarm) {
            $scope.feedbackQuestions = swarm.feedbackQuestions;
            prepareResponses($scope.feedbackQuestions);
        });
    });

    function countMultipleRatingItems(questionTitle, type, item, range) {

        if (!$scope.statistics[questionTitle]) {
            $scope.statistics[questionTitle] = {type: type, items: {}, range: range};
        }

        $scope.statistics[questionTitle]['items'][item] = {};

        range.forEach(function (rangeItem) {
            $scope.statistics[questionTitle]['items'][item][rangeItem] = 0;
            $scope.feedbackResponses.forEach(function (response) {
                var itemResponse = response[questionTitle + "[" + item + "]"];
                if (itemResponse && itemResponse == rangeItem) {
                    $scope.statistics[questionTitle]['items'][item][rangeItem]++;
                }
            });
        });
    }

    function computeMultipleSelectionItems(questionTitle, type, item) {
        if (!$scope.statistics[questionTitle]) {
            $scope.statistics[questionTitle] = {type: type, items: {}};
        }
        $scope.statistics[questionTitle]['items'][item] = 0;
        $scope.feedbackResponses.forEach(function (response) {
            var itemResponse = response[questionTitle + "[" + item + "]"];
            if (itemResponse == true) {
                $scope.statistics[questionTitle]['items'][item]++;
            }
        })
    }

    function computeRadioItems(questionTitle, type, item){
        if (!$scope.statistics[questionTitle]) {
            $scope.statistics[questionTitle] = {type: type, items: {}};
        }
        $scope.statistics[questionTitle]['items'][item] = 0;
        $scope.feedbackResponses.forEach(function (response) {
            var itemResponse = response[questionTitle];
            if (itemResponse == item) {
                $scope.statistics[questionTitle]['items'][item]++;
            }
        })
    }

    function addTextFeedback(questionTitle){
        var questionResponses = {title:questionTitle, responses:[]};
        $scope.feedbackResponses.forEach(function (response) {
            if(response[questionTitle]){
                questionResponses['responses'].push(response[questionTitle]);
            }
        });
        $scope.textResponses.push(questionResponses);
    }

    function prepareResponses(feedbackQuestions) {

        feedbackQuestions.forEach(function (question) {
            if (question.type === "multipleRating") {
                var questionItems = question.items;
                questionItems.forEach(function (item) {
                    countMultipleRatingItems(question.title, question.type, item, question.range);
                });
            }

            if (question.type === "multipleSelection") {
                var questionItems = question.items;
                questionItems.forEach(function (item) {
                    computeMultipleSelectionItems(question.title, question.type, item);
                });
            }

            if(question.type === "radio"){
                var questionItems = question.items;
                questionItems.forEach(function (item) {
                    computeRadioItems(question.title, question.type, item);
                });
            }
            if(question.type === "textInput"){
                addTextFeedback(question.title);
            }

        });
        computeChart($scope.statistics);
    }


    function computeChart(statistics) {

        for (var question in statistics) {
            var statistic = statistics[question];

            switch (statistic.type) {
                case "multipleRating":
                    var data = [];
                    Object.keys(statistic.items).forEach(function (i) {
                        data.push(Object.values(statistic.items[i]));
                    });
                    var translatedMatrix = [];
                    for (var r = 0; r < statistic.range.length; r++) {
                        translatedMatrix[r] = [];
                        for (var i = 0; i < data.length; i++) {
                            translatedMatrix[r].push(data[i][r]);
                        }
                    }

                    var chart = {
                        labels: Object.keys(statistic.items),
                        series: statistic.range,
                        data: translatedMatrix,
                        colors: ["rgba(51,102,204,1)", "rgb(220,57,18)", "rgb(255,153,0)", "rgb(16,150,24)", "rgb(153,0,153)"],
                        options: {
                            title: {
                                display: false,
                                text: question
                            },
                            legend: {display: true}
                        }
                    };
                    $scope.charts.push(chart);
                    break;
                case "multipleSelection":
                    var data = Object.values(statistic.items);
                    var chart = {
                        labels: Object.keys(statistic.items),
                        data: data,
                        colors: ["rgba(51,102,204,1)", "rgb(220,57,18)", "rgb(255,153,0)", "rgb(16,150,24)", "rgb(153,0,153)"],
                        options: {
                            title: {
                                display: false,
                                text: question
                            }
                        }
                    };
                    $scope.charts.push(chart);
                    break;
                case "radio":
                    var data = Object.values(statistic.items);
                    var chart = {
                        labels: Object.keys(statistic.items),
                        data: data,
                        colors: ["rgba(51,102,204,1)", "rgb(220,57,18)", "rgb(255,153,0)", "rgb(16,150,24)", "rgb(153,0,153)"],
                        options: {
                            title: {
                                display: false,
                                text: question
                            }
                        }
                    };
                    $scope.charts.push(chart);
                    break;
            }

        }
        $scope.$apply();
    }

}]);
