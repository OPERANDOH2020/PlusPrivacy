'use strict';

app.controller('userAnalyticsController', ['$scope', 'ModalService', 'swarmHubService', '$timeout', 'notifyDefaults', function ($scope, ModalService, swarmHubService, $timeout, notifyDefaults) {
	$.notifyDefaults(notifyDefaults);

	var hub = swarmHubService.hub;
	var currentNrOfRegisteredUsers = undefined;

	$scope.fetchingFilters = true;
	$scope.fetchingUsers = true;
	$scope.users = [];
	$scope.conditions = {};
	$scope.existingFilters = [];
	$scope.currentFilterName = {"value":""};
	$scope.filterResult = null;
	$scope.filterResultPercent = null;


	hub.startSwarm("analytics.js", "getUserAnalytics");
	hub.startSwarm("analytics.js","getAllFilters");
	hub.startSwarm("analytics.js","executeAnalyticsFilter",{"conditions":{},"filterName":"Total number of users"});

	hub.on('analytics.js','gotUserAnalytics',function (swarm) {
		$scope.users = swarm.userAnalytics;
		$scope.fetchingUsers = false;
		$scope.$apply()
	});

	hub.on('analytics.js','gotFilters',function(swarm){
		$scope.existingFilters = swarm.filters;
		$scope.fetchingFilters = false;
		$scope.$apply()
	});

	hub.on('analytics.js','filterRegistered',function(swarm){
		$scope.existingFilters.push(swarm.filter);
		$scope.$apply()
	});

	hub.on("analytics.js","gotRecords",function(swarm){
		updateChart(swarm.records);
	});

	hub.on('analytics.js','filterExecuted',function(swarm){
		if(swarm.filter.filterName==='Total number of users'){
			currentNrOfRegisteredUsers = swarm.filterResult;
		}
		$scope.filterResult = swarm.filterResult;
		$scope.filterResultPercent = ($scope.filterResult * 100) / currentNrOfRegisteredUsers;
		$scope.$apply()
	});

	$scope.filterChanged = function(){
		$scope.filterResult = null;
		$scope.existingFilters.forEach(function(filter){
			if(filter.filterName===$scope.currentFilterName.value){
				$scope.conditions = JSON.parse(JSON.stringify(filter.conditions)) //deep copy ...hi hi

				if($scope.conditions.signupDateAfter) {
					$scope.conditions.signupDateAfter = new Date($scope.conditions.signupDateAfter)
				}
				if($scope.conditions.signupDateBefore) {
					$scope.conditions.signupDateBefore = new Date($scope.conditions.signupDateBefore)
				}
			}
			hub.startSwarm("analytics.js","getFilterRecords",$scope.currentFilterName.value);
		});
	}

	$scope.showDetails = function (user) {
		ModalService.showModal({
			templateUrl: "tpl/modals/showDetails.html",
			controller: "showDetailsController",
			inputs: {
				"user": user
			}
		}).then(function (modal) {
			modal.element.modal();
			modal.close.then(function (userData) {
			});
		});
	};

	$scope.executeStatsFilter = function(){
		hub.startSwarm("analytics.js","executeAnalyticsFilter",{"conditions":$scope.conditions,"filterName":"customFilter"})
	};

	$scope.registerFilter = function(){
		ModalService.showModal({
			templateUrl: "tpl/modals/registerFilter.html",
			controller: "registerFilterController",
			inputs: {
				"filter": {"conditions":$scope.conditions}
			}
		}).then(function (modal) {
			modal.element.modal();
			modal.close.then(function (filter) {
				if(filter) {
					hub.startSwarm("analytics.js", "registerNewFilter", filter);
				}
			});
		});
	};

	$scope.startFilter = function () {
		$('.footable').trigger('footable_filter', {
			filter: $('#filter').val()
		});
	};
	function updateChart(newData){
		function zoomChart() {
			$scope.chart.zoomToIndexes($scope.chart.dataProvider.length - 40, $scope.chart.dataProvider.length - 1);
		}
		if(!$scope.chart){
			$scope.chart = AmCharts.makeChart("chartdiv", {
				"type": "serial",
				"theme": "light",
				"marginRight": 10,
				"marginLeft": 10,
				"autoMarginOffset": 20,
				"mouseWheelZoomEnabled":true,
				"dataDateFormat": "YYYY-MM-DD",
				"valueAxes": [{
					"id": "v1",
					"axisAlpha": 0,
					"position": "left",
					"ignoreAxisWidth":true
				}],
				"balloon": {
					"borderThickness": 1,
					"shadowAlpha": 0
				},
				"graphs": [{
					"id": "g1",
					"balloon":{
						"drop":true,
						"adjustBorderColor":false,
						"color":"#ffffff"
					},
					"bullet": "round",
					"bulletBorderAlpha": 1,
					"bulletColor": "#FFFFFF",
					"bulletSize": 5,
					"hideBulletsCount": 50,
					"lineThickness": 2,
					"title": "red line",
					"useLineColorForBulletBorder": true,
					"valueField": "value",
					"balloonText": "<span style='font-size:18px;'>[[value]]</span>"
				}],
				"chartScrollbar": {
					"graph": "g1",
					"oppositeAxis":false,
					"offset":10,
					"scrollbarHeight": 80,
					"backgroundAlpha": 0,
					"selectedBackgroundAlpha": 0.1,
					"selectedBackgroundColor": "#888888",
					"graphFillAlpha": 0,
					"graphLineAlpha": 0.5,
					"selectedGraphFillAlpha": 0,
					"selectedGraphLineAlpha": 1,
					"autoGridCount":true,
					"color":"#AAAAAA"
				},
				"chartCursor": {
					"pan": true,
					"valueLineEnabled": true,
					"valueLineBalloonEnabled": true,
					"cursorAlpha":1,
					"cursorColor":"#258cbb",
					"limitToGraph":"g1",
					"valueLineAlpha":0.2,
					"valueZoomable":true
				},
				"valueScrollbar":{
					"oppositeAxis":false,
					"offset":50,
					"scrollbarHeight":10
				},
				"categoryField": "date",
				"categoryAxis": {
					"parseDates": true,
					"dashLength": 1,
					"minorGridEnabled": true
				},
				"export": {
					"enabled": true
				},
				"dataProvider": newData
			});
			zoomChart();
			$scope.chart.addListener("rendered", zoomChart);
		}else {
			$scope.chart.dataProvider = newData;
			$scope.chart.validateData();
		}
	}
}]);

app.controller('showDetailsController', ['$scope', 'user', '$element', 'close', function ($scope, user, $element, close) {
	var devices = {
		"usesiOS":"iOS",
		"usesAndroid":"Android",
		"usesChrome":"Chrome"
	}
	$scope.listOfDevices = "";
	for(var field in devices){
		if(user[field]){
			$scope.listOfDevices+=devices[field]+",";
		}
	}
	if($scope.listOfDevices.length>0){
		$scope.listOfDevices = $scope.listOfDevices.slice(0,-1);
	}

	$scope.listOfSocialNetworks = "";
	['Facebook','LinkedIn','GooglePlus','Youtube','Twitter'].forEach(function(current){
		if(user[current]){
			$scope.listOfSocialNetworks+=current+",";
		}
	});
	if($scope.listOfSocialNetworks.length>0){
		$scope.listOfSocialNetworks = $scope.listOfSocialNetworks.slice(0,-1);
	}
	$scope.user = user;
}]);

app.controller('registerFilterController', ['$scope', 'filter', '$element', 'close', function ($scope, filter, $element, close) {
	$scope.filter = filter;
	$scope.registerFilter = function () {
		$element.modal('hide');
		close($scope.filter, 500);
	};
}]);
