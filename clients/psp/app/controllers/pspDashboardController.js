
function TableController ($scope, DTColumnDefBuilder,$q){

    function getOSPTitle(){
        var deferred = $q.defer();
        $scope.$parent.$watch("ospTitleOffer", function(value){
            deferred.resolve(value);
        });
        return deferred.promise;
    }

    $scope.offerStatsInstance = {};
    $scope.offerStatsColumnDefs = [
        DTColumnDefBuilder.newColumnDef(0).notSortable(),
        DTColumnDefBuilder.newColumnDef(1),
        DTColumnDefBuilder.newColumnDef(2).notSortable(),
        DTColumnDefBuilder.newColumnDef(3),
        DTColumnDefBuilder.newColumnDef(4),
        DTColumnDefBuilder.newColumnDef(5)
    ];

    $scope.offerStatsOptions = {
        "paging": false,
        "searching": true,
        "info": false,
        "order": [[0, "asc"]],
        "columnDefs": [{
            "targets": 'no-sort',
            "orderable": false
        }],
        dom: 'frtipB',
        buttons: [
            {
                extend:'excelHtml5',
                title: getOSPTitle(),
                exportOptions: {
                    columns: [ 1, 2, 3, 4, 5 ]
                }
            },
            {
                extend: 'csvHtml5',
                title: getOSPTitle(),
                exportOptions: {
                    columns: [ 1, 2, 3, 4, 5 ]
                }
            },
            {
                extend : 'pdfHtml5',
                title: getOSPTitle(),
                pageSize: 'A4',
                exportOptions : {
                    stripHtml: false
                },
                customize: function(doc) {
                    doc.info = {
                        title: getOSPTitle(),
                        subject: 'OSP statistics',
                        keywords: 'osp statistics'
                    };
                    doc.content[1].table.widths = [ 'auto', '*', '*', 'auto', "auto", "auto" ];
                    var regex = /<img.*?data-ng-src="(.*?)"/;
                    for (var i=1;i<doc.content[1].table.body.length;i++) {
                        var src = regex.exec(doc.content[1].table.body[i][0].text)[1];
                        delete doc.content[1].table.body[i][0].text;
                        doc.content[1].table.body[i][0].image = src;
                        doc.content[1].table.body[i][0].width = 16;
                    }
                }
            }
        ]
    };



}

pspApp.controller("TableController",TableController);


function ViewOSPOffersDetailsController($scope, ospTitleOffer,offersStats){

    $scope.ospTitleOffer = ospTitleOffer;
    $scope.offersStats = offersStats;
}


pspApp.controller("pspDashboardController", ["$scope", "connectionService", "messengerService", "$window", "DTColumnDefBuilder", "ModalService", "Notification",
    function ($scope, connectionService, messengerService, $window, DTColumnDefBuilder, ModalService, Notification) {

        $scope.dtInstance={};

        $scope.dtOptions = {
            "paging": false,
            "searching": false,
            "info":false,
            "order": [[ 0, "asc" ]],
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false
            }]
        };

        $scope.dtColumnDefs = [
            DTColumnDefBuilder.newColumnDef(0),
            DTColumnDefBuilder.newColumnDef(1),
            DTColumnDefBuilder.newColumnDef(2).notSortable(),
            DTColumnDefBuilder.newColumnDef(3).notSortable(),
            DTColumnDefBuilder.newColumnDef(4),
            DTColumnDefBuilder.newColumnDef(5).notSortable()
        ];

        var removeOspRequestFromList = function(userId){
            $scope.ospRequests = $scope.ospRequests.filter(function(ospRequest){
                return ospRequest.userId!==userId;
            });
            $scope.$apply();
        };



        $scope.getOspRequests = function(){
            connectionService.getOspRequests(function (ospRequests) {

                $scope.ospRequests = ospRequests;
                $scope.$apply();

            }, function (error) {
                $scope.error = error;
                $scope.$apply();
            });
        };

        $scope.deleteOSPRequest = function(userId){

            (function(userId){
                ModalService.showModal({
                    templateUrl: "/assets/templates/modals/denyOspRequest.html",

                    controller: function ($scope, close) {
                        $scope.dismissFeedback="";
                        $scope.deleteOspRequest = function(){

                            connectionService.deleteOSPRequest(userId, $scope.dismissFeedback, function () {
                                removeOspRequestFromList(userId);
                                Notification.success({message: 'OSP request successfully removed!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            }, function (error) {
                                Notification.error({message: 'An error occurred! Please try again or refresh this page!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            });
                        };

                        $scope.close = function (result) {
                            close(result, 500);
                        };
                    }
                }).then(function (modal) {
                    modal.element.modal();
                });

            })(userId);
        };

        $scope.acceptOSPRequest = function(userId){
            (function(userId){
                ModalService.showModal({
                    templateUrl: "/assets/templates/modals/acceptOspRequest.html",

                    controller: function ($scope, close) {
                        $scope.acceptOspRequest = function(){

                            connectionService.acceptOSPRequest(userId, function () {
                                removeOspRequestFromList(userId);
                                Notification.success({message: 'OSP request approved!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            }, function (error) {
                                Notification.error({message: 'An error occurred! Please try again or refresh this page!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            });
                        };

                        $scope.close = function (result) {
                            close(result, 500);
                        };
                    }
                }).then(function (modal) {
                    modal.element.modal();
                });

            })(userId);
        };

        $scope.viewOffersStats = function(ospUserId){
            connectionService.getOffersStats(ospUserId, function(offersStats){

                    var selectedOsp = $scope.ospList.find(function(osp){
                       return osp.userId === ospUserId;
                    });

                    ModalService.showModal({
                        templateUrl:"/assets/templates/modals/viewOffersStats.html",
                        controller: ViewOSPOffersDetailsController,
                        inputs: {
                            ospTitleOffer: selectedOsp.name,
                            offersStats: offersStats
                        }
                    }).then(function (modal) {
                        modal.element.modal({backdrop: 'static', keyboard: false});
                    });

            },
            function(errorMessage){
                console.log(errorMessage);
            });
        };

        $scope.listOSPs = function(){
            connectionService.listOSPs(function(ospList){
                $scope.ospList = ospList;
                $scope.$apply();
            }, function(error){
                $scope.error = error;
                $scope.$apply();
            });
        };

    }]);


