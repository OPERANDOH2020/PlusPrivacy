angular.module("ospApp").controller("billingController", function ($scope,DTColumnDefBuilder) {

    $scope.billingInstance = {};
    $scope.billingDefs = [
        DTColumnDefBuilder.newColumnDef(0).notSortable(),
        DTColumnDefBuilder.newColumnDef(1),
        DTColumnDefBuilder.newColumnDef(2).notSortable(),
        DTColumnDefBuilder.newColumnDef(3),
        DTColumnDefBuilder.newColumnDef(4),
        DTColumnDefBuilder.newColumnDef(5)
    ];

    $scope.billingOptions = {
        "paging": false,
        "searching": false,
        "info": false,
        "order": [[1, "asc"]],
        "columnDefs": [{
            "targets": 'no-sort',
            "orderable": false
        }]
    }


    $scope.billings = [
        {
            name:"Meetup offer",
            contracts:5,
            price_per_contract:5,
            paid:false,
            vat:19
        }
    ]


});
