angular.module("ospApp").controller("certificationsController", function ($scope,DTColumnDefBuilder) {

    $scope.certificationsInstance = {};
    $scope.certificationsDefs = [
        DTColumnDefBuilder.newColumnDef(0).notSortable(),
        DTColumnDefBuilder.newColumnDef(1),
        DTColumnDefBuilder.newColumnDef(2).notSortable(),
        DTColumnDefBuilder.newColumnDef(3),
        DTColumnDefBuilder.newColumnDef(4),
        DTColumnDefBuilder.newColumnDef(5).notSortable()
    ];

    $scope.certificationsOptions = {
        "paging": false,
        "searching": false,
        "info": false,
        "order": [[1, "asc"]],
        "columnDefs": [{
            "targets": 'no-sort',
            "orderable": false
        }]
    }


    $scope.certifications = [
        {
            name:"O{P}ERNDO Certification",
            took: true,
            passed: true,
            minimumScore:75,
            attempts:1,
            score:85
        },
        {
            name:"PrivacyRainbow Certification",
            took: false,
            passed: false,
            minimumScore:75,
            attempts:0,
            score:0
        },
        {
            name:"Protection of personal data",
            took: true,
            passed: false,
            minimumScore:75,
            attempts:2,
            score:65
        }
    ]


});
