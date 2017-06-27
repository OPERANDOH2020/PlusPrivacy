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

angular.module('extensions', [])
    .directive('extensions', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: function ($scope, DTColumnDefBuilder, DTOptionsBuilder,$q,$timeout) {

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
                    DTColumnDefBuilder.newColumnDef(2).notSortable()
                ];

                $scope.extensions = [];
                function orderExtensions(extensions) {
                    extensionsList = Array.prototype.slice.call(extensions).sort(function (a, b) {
                        return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
                    });

                    return extensionsList;
                }

                var prepareExtension = function(extension){
                    if (extension.icons && extension.icons instanceof Array) {
                        extension['icon'] = extension.icons.pop();
                        delete extension['icons'];
                    }
                    return extension;
                }

                var addExtension = function(extension){
                    $scope.extensions.push(prepareExtension(extension));
                    $scope.extensions = orderExtensions($scope.extensions);
                }

                var toggleExtension = function(extension){
                        for(var i = 0; i<$scope.extensions.length; i++){
                            if($scope.extensions[i].id === extension.id){
                                $scope.extensions[i] = prepareExtension(extension);
                            }
                        }
                }

                function getExtensions(callback) {
                    chrome.management.getAll(function (results) {
                        results.forEach(addExtension);

                        $scope.$apply();

                        if(callback){
                            callback();
                        }

                    });
                }

                    getExtensions(function(){


                    });


                chrome.management.onUninstalled.addListener(function (extension_id) {

                    for (var i = 0; i < $scope.extensions.length; i++) {
                        if ($scope.extensions[i].id == extension_id) {
                            $scope.extensions.splice(i, 1);
                            break;
                        }
                    }

                    //$scope.dtInstance.rerender();

                    $timeout(function () {
                        $scope.$apply()
                    }, 10);

                });

                chrome.management.onInstalled.addListener(function(extension){
                    addExtension(extension);
                    $scope.$apply();
                });

                chrome.management.onEnabled.addListener(function(extension){
                    toggleExtension(extension);
                    $scope.$apply();
                });

                chrome.management.onDisabled.addListener(function(extension){
                    toggleExtension(extension);
                    $scope.$apply();
                });

            },
            templateUrl: '/operando/tpl/extensions.html'
        }
    })
    .directive("permissionsRow", function(ModalService){

        return{
            restrict: 'A',
            replace: true,
            transclude: true,
            scope: {extension: "="},
            link: function ($scope, element, attrs, extensionsCtrl) {
                function checkPrivacyPollution(){

                    $scope.extension.privacyPollution = computePrivacyPollution($scope.extension.permissions);
                    $scope.extension.privacyPollutionColor = getPrivacyPollutionColor($scope.extension.privacyPollution);

                }

                $scope.view_permissions = function () {
                    var permissions = $scope.extension.permissions;
                    var extensionName = $scope.extension.name;
                    var showModal = function (permissionWarnings) {
                        ModalService.showModal({
                            templateUrl: '/operando/tpl/modals/view_permissions.html',
                            controller: function ($scope, close) {
                                $scope.permissions = permissions;
                                $scope.permissionWarnings = permissionWarnings;
                                $scope.name = extensionName;
                                $scope.close = function (result) {
                                    close(result, 500);
                                };
                            }
                        }).then(function (modal) {
                            modal.element.modal();
                        });
                    }
                    chrome.management.getPermissionWarningsById($scope.extension.id, showModal);
                }

                checkPrivacyPollution();
            },
            templateUrl: '/operando/tpl/extension_permissions.html'
        }



    })
   .directive('actionsRow', function (ModalService) {
        return {
            restrict: 'A',
            replace: true,
            transclude: true,
            scope: {extension: "="},
            link: function ($scope, element, attrs, extensionsCtrl) {


                function switchState(enabled) {
                    chrome.management.setEnabled($scope.extension.id, enabled, function () {
                        chrome.management.get($scope.extension.id, function (extension) {
                            if (extension.id == $scope.extension.id) {
                                if (extension.icons && extension.icons instanceof Array) {
                                    extension['icon'] = extension.icons.pop();
                                    delete extension['icons'];
                                }
                                $scope.extension = extension;
                                $scope.$apply();
                            }
                        });
                    });
                }

                function uninstall(showConfirmDialog) {
                    if (showConfirmDialog === undefined) {
                        showConfirmDialog = false;
                    }

                    chrome.management.uninstall($scope.extension.id, {showConfirmDialog: showConfirmDialog}, function () {
                        if (chrome.runtime.lastError) {
                            console.log(chrome.runtime.lastError.message);
                        }
                    });
                }

                $scope.toggleEnabled = function () {
                    switchState(!$scope.extension.enabled);
                }

                $scope.uninstall = function () {
                    uninstall();
                }

            },
            controller:function($scope){
                $scope.plusPrivacyExtensionId = chrome.runtime.id;
            },
            templateUrl: '/operando/tpl/extension_actions.html'
        }
    });

