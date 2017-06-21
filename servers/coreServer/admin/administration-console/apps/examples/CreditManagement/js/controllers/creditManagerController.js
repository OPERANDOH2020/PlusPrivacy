'use strict';
app.controller('creditManagerController', ['$scope','ModalService','swarmHubService',
	function ($scope,ModalService,swarmHubService) {
		var swarmHub = swarmHubService.hub;

		$scope.allTransactions = [];
		$scope.maxNrOfPages = 0;
		$scope.currentPage = 1;
		$scope.itemsPerPage = 10;
		$scope.maxPages = 5;
		$scope.availableFunds = 0;
		$scope.userInfo = {};

		swarmHub.startSwarm('accounts.js','getFundsForUser');
		swarmHub.startSwarm('accounts.js','getTransactions');
		swarmHub.startSwarm('UserInfo.js','info');

		$scope.sendMoney = function(){
			ModalService.showModal({
				templateUrl: "tpl/modals/sendMoney.html",
				controller: "createTransactionController",
				inputs:{
					"availableFunds":$scope.availableFunds
				}
			}).then(function(modal) {
				modal.element.modal();
				modal.close.then(function(transaction) {
					swarmHub.startSwarm("accounts.js","sendMoney",transaction);
				});
			});
		};

		$scope.changePage = function(currentPage){
			$scope.currentPage = currentPage;
		}


		var timeSorted = true;
		$scope.sortByTime = function(){
			$scope.allTransactions = $scope.allTransactions.sort(function(a,b){
				if(timeSorted){
					return a.transactionTime<b.transactionTime?1:-1
				}else{
					return b.transactionTime<a.transactionTime?1:-1
				}
			});
			timeSorted = !timeSorted
		}


		swarmHub.on("accounts.js","gotTransactions",function(swarm){
			$scope.allTransactions = swarm.transactions;
			$scope.sortByTime(true);
			$scope.$apply();
		});
		swarmHub.on("accounts.js","moneySent",function(swarm){
			swarm.transaction.sourceEmail = $scope.userInfo.email;
			$scope.allTransactions.unshift(swarm.transaction);
			$scope.availableFunds-=swarm.transaction.amount;
			$scope.$apply();
		});
		swarmHub.on("accounts.js","gotFunds",function(swarm){
			$scope.availableFunds = swarm.funds;
			$scope.$apply();
		});
		swarmHub.on("accounts.js","failed",function(swarm){
			console.log("Error "+swarm.err+" occured");
		});
		swarmHub.on("UserInfo.js","result",function(swarm){
			$scope.userInfo = swarm.result
			$scope.$apply()
		});
	}]);


app.controller('createTransactionController', ['$scope',"$element",'availableFunds','close', function($scope,$element,availableFunds, close) {
	$scope.transaction = {};
	$scope.availableFunds = availableFunds;
	$scope.sendMoney = function(){
		$element.modal('hide');
		close($scope.transaction,500);
	}
}]);