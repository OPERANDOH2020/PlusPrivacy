privacyPlusApp.requires.push('ngMaterial');
privacyPlusApp.requires.push('ngMessages');
privacyPlusApp.requires.push('mdPickers');
privacyPlusApp.requires.push('datatables');

function AddOspOfferController($scope, $element, $rootScope, close, connectionService, Notification, offer, modalTitle, saveBtn) {

    $scope.offer = offer;
    $scope.modalTitle = modalTitle;
    $scope.saveBtn = saveBtn;
    if ($scope.offer['start_date']) {
        $scope.offer['start_date'] = new Date($scope.offer['start_date']);
    }

    if ($scope.offer['end_date']) {
        $scope.offer['end_date'] = new Date($scope.offer['end_date']);
    }

    $scope.$watch("offer.start_date", function (newValue, oldValue) {
        if ($scope.offer.end_date < newValue || $scope.offer.end_date === undefined) {
            $scope.offer.end_date = newValue;
        }
    });

    $scope.$watch("offer.end_date", function (newValue, oldValue) {
        if ($scope.offer.start_date > newValue || $scope.offer.start_date === undefined) {
            $scope.offer.start_date = newValue;
        }
    });

    AddOspOfferController.prototype.$scope = $scope;
    AddOspOfferController.prototype.changeInput = function (element) {
        var $scope = this.$scope;
        $scope.$apply(function () {
            $scope.icon_file = element.files[0];
            convertImageToBase64($scope.icon_file, function (base64String) {
                $scope.offer.logo = base64String;
                delete $scope['formError'];
                $scope.$apply();
            }, function (error) {
                delete $scope.offer['logo'];
                $scope.formError = {
                    type: error,
                    message: error
                };
                $scope.$apply();
            });
        });
    };

    $scope.addOspOffer = function () {

        connectionService.addOspOffer($scope.offer, function (offer) {
            $scope.closeModal();
            $rootScope.$broadcast("newOfferAdded", offer);

            Notification.success({
                message: 'OSP request approved!',
                positionY: 'bottom',
                positionX: 'center',
                delay: 2000
            });
        }, function (error) {
            Notification.error({
                message: 'An error occurred! Please try again or refresh this page!',
                positionY: 'bottom',
                positionX: 'center',
                delay: 2000
            });
        });
    };


    $scope.closeModal = function () {
        $element.modal('hide');
        $scope.close();
    };


    $scope.close = function (result) {
        close(result, 500);
    };
}

function OspOffersController($scope, $rootScope, connectionService, DTColumnDefBuilder, ModalService, Notification, userService, SharedService) {

    $scope.$on("newOfferAdded", function (event, offer) {
        if (!$scope.offers) {
            $scope.offers = [];
        }

        var updatedOffer = $scope.offers.find(function (o) {
            return o.offerId === offer.offerId;
        });

        if (updatedOffer === undefined) {
            $scope.offers.push(offer);
        } else {
            for (var i = 0; i < $scope.offers.length; i++) {
                if ($scope.offers[i].offerId === offer.offerId) {
                    $scope.offers[i] = offer;
                    break;
                }
            }
        }

        $scope.$apply();
    });

    $scope.$on("offerDeleted", function (event, offerId) {
        $scope.offers = $scope.offers.filter(function (offer) {
            return offer['offerId'] !== offerId;
        });
        $scope.$apply();
    });

    $scope.dtInstance = {};
    $scope.dtOptions = {
        "paging": false,
        "searching": false,
        "info": false,
        "order": [[0, "asc"]],
        "columnDefs": [{
            "targets": 'no-sort',
            "orderable": false
        }]
    };

    $scope.dtColumnDefs = [
        DTColumnDefBuilder.newColumnDef(0),
        DTColumnDefBuilder.newColumnDef(1),
        DTColumnDefBuilder.newColumnDef(2).notSortable(),
        DTColumnDefBuilder.newColumnDef(3).notSortable(),
        DTColumnDefBuilder.newColumnDef(4).notSortable(),
        DTColumnDefBuilder.newColumnDef(5).notSortable()
    ];
    var listOffers = function () {
        connectionService.listOSPOffers(function (offers) {
            $scope.offers = offers;
            $scope.$apply();
        }, function (error) {
            $scope.error = error;
            $scope.$apply();
        })
    };

    var getOfferById = function (offerId) {
        return $scope.offers.find(function (offer) {
            return offer.offerId === offerId;
        })
    };

    var restoredSessionFailed = function () {
        alert("failed");
    };

    $scope.addNewOfferModal = function () {
        ModalService.showModal({
            templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/addNewOffer.html',
            controller: AddOspOfferController,
            inputs: {
                offer: {},
                modalTitle: "Add offer",
                saveBtn: "Add offer"
            }
        }).then(function (modal) {
            modal.element.modal({backdrop: 'static', keyboard: false});
        });
    };

    $scope.modifyOffer = function (offerId) {
        ModalService.showModal({
            templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/addNewOffer.html',
            controller: AddOspOfferController,
            inputs: {
                offer: angular.copy(getOfferById(offerId)),
                modalTitle: "Edit offer",
                saveBtn: "Update offer"
            }
        }).then(function (modal) {
            modal.element.modal({
                backdrop: 'static',
                keyboard: false
            });
        });
    };

    $scope.deleteOspOffer = function (offerId) {
        ModalService.showModal({
            templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/deleteOffer.html',
            controller: function ($scope, close) {
                $scope.deleteOffer = function () {
                    connectionService.deleteOspOffer(offerId, function () {
                        $rootScope.$broadcast("offerDeleted", offerId);
                        Notification.success({
                            message: 'OSP offer successfully removed!',
                            positionY: 'bottom',
                            positionX: 'center',
                            delay: 2000
                        });
                    }, function (error) {
                        Notification.error({
                            message: 'An error occurred! Please try again or refresh this page!',
                            positionY: 'bottom',
                            positionX: 'center',
                            delay: 2000
                        });
                    });
                };

                $scope.close = function (result) {
                    close(result, 500);
                };
            }
        }).then(function (modal) {
            modal.element.modal();
        });
    };

    userService.getUser(listOffers);
    SharedService.setLocation("ospZone");
};

privacyPlusApp.controller("ospOffersController", OspOffersController);

angular.element(document).ready(function () {
    angular.bootstrap(document.getElementById('osp-offers'), ['plusprivacy']);
});