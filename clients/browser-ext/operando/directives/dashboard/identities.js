/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */


angular.module('identities', [])
    .directive('identities', ["messengerService", function (messengerService) {
            return {
                restrict: 'E',
                replace: true,
                scope: {},

                controller: function ($scope, ModalService) {

                    $scope.max_identities_nr = 20;
                    $scope.identities = [];


                    var refreshIdentities = function () {
                        messengerService.send("listIdentities", function (response) {
                            $scope.identities = response.data;
                            $scope.$apply();
                        });
                    };

                    $scope.$on('refreshIdentities', refreshIdentities);
                    $scope.$on('changedDefaultSID', function (defaultIdentity) {
                        $scope.identities.forEach(function (identity) {

                            if (identity.email != defaultIdentity.email) {
                                identity.isDefault = false;
                            }
                        });
                    });

                    $scope.add_new_sid = function () {
                        var identities = $scope.identities;
                        ModalService.showModal({
                            templateUrl: '/tpl/modals/add_sid.html',
                            controller: ["$scope", "$element", "close", "messengerService", "Notification", function ($scope, $element, close, messengerService, Notification) {

                                $scope.identity = {};
                                $scope.domains = {};

                                messengerService.send("listDomains", {}, function (response) {
                                    $scope.domains.availableDomains = response.data;
                                    $scope.identity.domain = $scope.domains.availableDomains[0];
                                    $scope.generateIdentity();
                                });

                                $scope.saveIdentity = function () {
                                    messengerService.send("addIdentity", $scope.identity, function (response) {

                                        if (response.status == "success") {
                                            identities.push(response.data);
                                            refreshIdentities();
                                            $scope.close(response.data);
                                        }
                                        else {
                                            Notification.error({
                                                message: response.error,
                                                positionY: 'bottom',
                                                positionX: 'center',
                                                delay: 2000
                                            });
                                        }
                                    });
                                };


                                $scope.generateIdentity = function () {
                                    messengerService.send("generateIdentity", function (response) {
                                        if (response.status == "success") {
                                            $scope.identity.alias = response.data.email;
                                            $scope.refreshSID();
                                            $scope.$apply();
                                        }
                                        else {
                                            Notification.error({
                                                message: response.error,
                                                positionY: 'bottom',
                                                positionX: 'center',
                                                delay: 2000
                                            });
                                        }

                                    })
                                };

                                $scope.refreshSID = function () {
                                    $scope.identity.email = $scope.identity.alias + "@" + $scope.identity.domain.name;
                                };

                                $scope.close = function (result) {
                                    $element.modal('hide');
                                    close(result, 500);
                                };

                            }]
                        }).then(function (modal) {
                            modal.element.modal();
                        });
                    };

                    refreshIdentities();
                },
                templateUrl: '/tpl/identities.html'
            }
        }]
    )
    .directive('identityRow', function () {
            return {
                require: "^identities",
                restrict: 'A',
                replace: true,
                scope: {identity: "="},
                controller: function ($scope, ModalService, messengerService, Notification) {


                    $scope.stopEventPropagation = function($event){
                        $event.stopPropagation();
                    };

                    $scope.changeDefaultIdentity = function () {

                        messengerService.send("updateDefaultSubstituteIdentity", $scope.identity, function () {
                            $scope.$parent.$emit("changedDefaultSID", $scope.identity);
                            $scope.identity.isDefault = true;
                            $scope.$apply();

                        });
                    };

                    $scope.removeIdentity = function ($event) {
                        $scope.stopEventPropagation($event);
                        var identity = $scope.identity;
                        var emitToParent = function (event) {
                            $scope.$emit(event);
                        };

                        ModalService.showModal({

                            templateUrl: '/tpl/modals/delete_sid.html?tag='+Math.random(),
                            controller: ["$scope", "close", "messengerService","i18nService", function ($scope, close, messengerService,i18nService) {

                                $scope.identity = identity;
                                $scope.deleteSidQuestion = i18nService._("deleteSid",["sid",$scope.identity.email]);
                                $scope.deleteIdentity = function () {
                                    messengerService.send("removeIdentity", identity, function (response) {

                                        if (response.status == "success") {
                                            var identity = response.data;
                                            Notification.success({
                                                message: "Identity " + identity.email + " was successfully deleted!",
                                                positionY: 'bottom',
                                                positionX: 'center',
                                                delay: 2000
                                            });
                                            emitToParent("refreshIdentities");
                                        }
                                        else {
                                            Notification.error({
                                                message: response.error,
                                                positionY: 'bottom',
                                                positionX: 'center',
                                                delay: 2000
                                            });
                                        }
                                    })
                                };

                                $scope.close = function (result) {
                                    close(result, 500);
                                };
                            }
                            ]
                        }).then(function (modal) {
                            modal.element.modal();
                        })
                    }

                },
                templateUrl: '/tpl/identityRow.html'
            }
        }
    );