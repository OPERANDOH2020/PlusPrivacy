'use strict';

app.controller('zoneManagerController', ['$scope','ModalService','notifyDefaults', 'swarmHubService', function ($scope, ModalService,notifyDefaults, swarmHubService) {
	$.notifyDefaults(notifyDefaults);

	var hub = swarmHubService.hub;

	$scope.users = [];
	$scope.zones = [];
	$scope.newZone = {"zoneName":""};

	hub.on("UserManagement.js", "gotFilteredUsers", function(swarm){
		$scope.users = swarm.result.map(function(user){return user.email;});
		$scope.$apply();
	});
	
	hub.on('zones.js','gotAllZones',function(swarm){
		$scope.zones = swarm.zones.map(function(zoneName){
			return {'zoneName':zoneName};
		});

		$scope.zones.forEach(function(zone){
			hub.startSwarm('zones.js','getUsersInZone',zone.zoneName,['email'])
		});

		$scope.$apply();
	});

	hub.on('zones.js','gotUsersInZone',function(swarm) {
		updateZone(swarm.zone,swarm.users.map(function(user){return user.email}));
	});

	hub.on('zones.js','zoneCreated',function(swarm){
		$scope.zones.push({'zoneName':swarm.zoneName,"users":[],"nrUsers":0,"usersPreview":""});
		$scope.$apply();
	});

	hub.on('zones.js','zoneUpdated',function(swarm){
		updateZone(swarm.updatedZone.zoneName,swarm.updatedZone.users);
	})

	function updateZone(zoneName,users){
		$scope.zones.some(function(zone){
			if(zone.zoneName===zoneName){
				var nrOfUsersInPreview = 5;
				zone.users = users;
				zone.nrUsers = users.length;
				zone.usersPreview = zone.users.slice(0,nrOfUsersInPreview).join();
				if(nrOfUsersInPreview<zone.users.length){
					zone.usersPreview+="...";
				}
				return true;
			}else {
				return false;
			}
		});
		$scope.$apply();
	}



	hub.startSwarm("UserManagement.js", "filterUsers", {});
	hub.startSwarm("zones.js",'getAllZones');

	$scope.createNewZone = function(){
		hub.startSwarm('zones.js','createZone',$scope.newZone.zoneName);
		$scope.newZone = {"zoneName":""};
	};


	$scope.updateZone = function(zone){
		ModalService.showModal({
			templateUrl: "tpl/modals/updateZone.html",
			controller: "updateZoneController",
			inputs: {
				"zone": zone,
				"allUsers":$scope.users
			}
		}).then(function (modal) {
			modal.element.modal();
			modal.close.then(function (updatedZone){
				hub.startSwarm("zones.js","updateZone",updatedZone);
			});
		});
	}
}]);


function uniqueElements(array){
	return array.filter(function(element,index){
		return !elementExists(array,element,index);
	})

	function elementExists(array,element,index){
		for(var i=0;i<index;i++){
			if(array[i] === element){
				return true;
			}
		}
		return false;
	}
}


app.controller('updateZoneController', ['$scope', "$element", 'close', 'zone','allUsers', function ($scope, $element, close, zone, allUsers) {
	$scope.allUsers = allUsers;
	$scope.zone = zone;
	$scope.newUser = {"email":""};
	$scope.addNewUser = function(){

		if(!$scope.zone.users.some(function(user){return user===$scope.newUser.email})){   //search the array for the email
			$scope.zone.users = $scope.zone.users.concat([$scope.newUser.email])
		}

		$scope.newUser = {"email":""};
	};
	var r = new FileReader();
	r.addEventListener('loadend', function(e) {
		$scope.zone.users = uniqueElements($scope.zone.users.concat(e.target.result.split(new RegExp("[\",\ ]")).filter(function (user) {return user.length>1;})));
		$scope.$apply();
	});

	$scope.uploadFile = function(){
		var f = document.getElementById('file').files[0];
		r.readAsText(f);
	};

	$scope.updateZone = function(){
		$element.modal('hide');
		close($scope.zone,500);
	}
}]);