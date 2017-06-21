privacyPlusApp.requires.push('datatables');
privacyPlusApp.requires.push('chart.js');

var dealsController = function ($scope, connectionService, messengerService, $window, DTColumnDefBuilder, ModalService, Notification, SharedService) {


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
                title: "Stats",
                exportOptions: {
                    columns: [ 1, 2, 3, 4, 5 ]
                }
            },
            {
                extend: 'csvHtml5',
                title: "Stats",
                exportOptions: {
                    columns: [ 1, 2, 3, 4, 5 ]
                }
            },
            {
                extend : 'pdfHtml5',
                title: "Stats",
                pageSize: 'A4',
                exportOptions : {
                    stripHtml: false
                },
                customize: function(doc) {
                    doc.info = {
                        title: "Stats",
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

    connectionService.getMyOffersDetails(function (offersStats) {
        $scope.offersStats = offersStats;
        $scope.$apply();
    }, function (error) {
        console.log(error);
    });

    $scope.viewDetails = function(offer){
        ModalService.showModal({
            templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/deal_impact.html',

            controller: function ($scope, close) {

                $scope.labels = [];
                $scope.data = [];

                connectionService.getOfferStatistics(offer.offerId, function(offerStats){
                    offerStats.forEach(function(stat){
                        $scope.labels.push(stat.time);
                        $scope.data.push(stat.impact);
                    });
                    $scope.$apply();

                }, function(){

                });

                $scope.series = ['Accepted Deals'];

                $scope.options = {
                    scales: {
                        yAxes: [
                            {
                                id: 'y-axis-1',
                                type: 'linear',
                                display: true,
                                position: 'left'
                            }
                        ]
                    }
                };
                $scope.colors = [
                    {
                        backgroundColor: "rgba(255,180,0, 1)",
                        pointBackgroundColor: "rgba(255,180,0, 1)",
                        pointHoverBackgroundColor: "rgba(255,180,0, 0.8)",
                        borderColor: "rgba(159,204,0, 1)",
                        pointBorderColor: '#fff',
                        pointHoverBorderColor: "rgba(159,204,0, 1)"
                    },"rgba(250,109,33,0.5)","#9a9a9a","rgb(233,177,69)"
                ];


                $scope.close = function (result) {
                    close(result, 500);
                };
            }
        }).then(function (modal) {
            modal.element.modal();
        });
    }
};


privacyPlusApp.controller("ospDashboardController", dealsController);


angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('osp_dashboard'), ['plusprivacy']);
});