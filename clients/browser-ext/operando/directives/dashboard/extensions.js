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
    .service("ExtensionService",function(){


        var isBrowserFirefox = null;
        var checked = false;

        var checkIfIsBrowserFirefox = function(callback){
            if(checked){
                callback(isBrowserFirefox);
            }
            else {

                function gotBrowserInfo(info) {
                    if (info.name === "Firefox") {
                        isBrowserFirefox = true;
                        callback(true);
                    }
                    else {
                        isBrowserFirefox = false;
                        callback(false);
                    }
                }

                if (chrome.runtime.getBrowserInfo) {
                    var gettingInfo = browser.runtime.getBrowserInfo();
                    gettingInfo.then(gotBrowserInfo);
                }
                else {
                    isBrowserFirefox = false;
                    callback(false);
                }
                checked = true;
            }
        };


        return {
            isBrowserFirefox: checkIfIsBrowserFirefox
        }
    })
    .directive('extensions', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: function ($scope, DTColumnDefBuilder, DTOptionsBuilder,$q,$timeout,ExtensionService) {



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
                    DTColumnDefBuilder.newColumnDef(1)
                ];

                $scope.extensions = [];





                function orderExtensions(extensions) {
                    extensionsList = Array.prototype.slice.call(extensions).sort(function (a, b) {
                        return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
                    });

                    return extensionsList;
                }

                var prepareExtension = function(extension){

                    console.log(extension);


                    if (extension.icons && extension.icons instanceof Array) {
                        extension['icon'] = extension.icons.pop();
                        delete extension['icons'];
                    }

                    if (extension['icon'].url.indexOf("chrome://") !== 0) {

                        if (extension.optionsUrl && extension.optionsUrl.indexOf("moz-extension") === 0) {
                            var rawId = extension.optionsUrl.split("://")[1];
                            var id = rawId.substr(0, rawId.indexOf("/"));
                            extension['icon'].url = "moz-extension://" + id + "/" + extension['icon'].url;
                        }
                        else {
                            if (extension.hostPermissions.length > 0) {
                                var selfPermission = extension.hostPermissions.filter(function (hostPermission) {
                                    return hostPermission.indexOf("moz-extension://") === 0;
                                });
                                if (selfPermission.length > 0) {
                                    var rawId = selfPermission[0].split("://")[1];
                                    var id = rawId.substr(0, rawId.indexOf("/"));
                                    extension['icon'].url = "moz-extension://" + id + "/" + extension['icon'].url;
                                }
                            }
                        }
                    }

                    console.log(extension['icon'].url);

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

                        results = results.filter(function(extension){
                           return extension.type!=="theme";
                        });

                        if($scope.extensionsTypes == "enabled"){
                            results = results.filter(function(extension){
                                return extension.enabled == true;
                            });
                        }

                        results.forEach(addExtension);

                        $scope.$apply();

                        if(callback){
                            callback();
                        }

                    });
                }

                ExtensionService.isBrowserFirefox(function(isFirefox){
                    $scope.isFirefox =  isFirefox;
                    $scope.extensionsTypes = "all";
                    if(isFirefox == false){
                        $scope.dtColumnDefs.push(DTColumnDefBuilder.newColumnDef(2).notSortable());
                    }
                    else{
                        $scope.extensionsTypes = "enabled";
                    }

                    getExtensions();
                });

                chrome.management.onUninstalled.addListener(function (extension_id) {

                    for (var i = 0; i < $scope.extensions.length; i++) {
                        if ($scope.extensions[i].id == extension_id) {
                            $scope.extensions.splice(i, 1);
                            break;
                        }
                    }


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
            templateUrl: '/tpl/extensions.html'
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

                    if($scope.extension.permissions){
                        $scope.extension.privacyPollution = computePrivacyPollution($scope.extension.permissions);
                    }
                    $scope.extension.privacyPollutionColor = getPrivacyPollutionColor($scope.extension.privacyPollution);

                }

                $scope.view_permissions = function () {
                    var permissions = $scope.extension.permissions;
                    var extensionName = $scope.extension.name;
                    var showModal = function (permissionWarnings) {
                        ModalService.showModal({
                            templateUrl: '/tpl/modals/view_permissions.html',
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
                    if(chrome.management.getPermissionWarningsById){
                        chrome.management.getPermissionWarningsById($scope.extension.id, showModal);
                    }
                    else{
                        showModal();
                    }

                }

                checkPrivacyPollution();
            },
            templateUrl: '/tpl/extension_permissions.html'
        }



    })
   .directive('actionsRow', function (ModalService, messengerService) {
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

                    if(chrome.management.uninstall){
                        chrome.management.uninstall($scope.extension.id, {showConfirmDialog: showConfirmDialog}, function () {
                            if (chrome.runtime.lastError) {
                                console.log(chrome.runtime.lastError.message);
                            }
                        });
                    }
                }

                $scope.toggleEnabled = function () {
                    messengerService.send("sendAnalytics","changedAppsOrExtensions");
                    switchState(!$scope.extension.enabled);
                }

                $scope.uninstall = function () {
                    uninstall();
                }

            },
            controller:function($scope){
                $scope.plusPrivacyExtensionId = chrome.runtime.id;
            },
            templateUrl: '/tpl/extension_actions.html'
        }
    });

