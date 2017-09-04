'use strict';
app.controller('analyticsController', ['$scope','swarmHubService',"$window",
	function ($scope,swarmHubService,$window) {

		var swarmHub = swarmHubService.hub;

		$scope.downloadAnalytics = function(){
			swarmHub.startSwarm("analytics.js","getDownloadUrl");
		};

		swarmHub.on("analytics.js","gotDownloadUrl",function(swarm){
			$window.open(swarm.link);
		});
		swarmHub.on("analytics.js","failed",function(swarm){
			console.log("Error "+swarm.err+" occured");
		});
	}
]);

