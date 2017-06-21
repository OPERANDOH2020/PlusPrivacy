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

angular.module('op-popup', ['operandoCore', 'popupMenu', 'validation', 'validation.rule'])
    .config([
        '$compileProvider',
        function ($compileProvider) {   //to accept chrome protocol
            $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension|chrome-extension-resource):/);
            $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension|chrome-extension-resource):/);

        }
    ])
    .config(['$validationProvider', function ($validationProvider) {
        $validationProvider.setValidMethod('blur', 'submit-only');
        $validationProvider.showSuccessMessage = false;
        $validationProvider.showErrorMessage = false;
    }])
    .config(function ($stateProvider,$urlRouterProvider) {
        $stateProvider
            .state('popup', {
                url: "/",
                resolve: {
                    i18n: ['i18nService', function (i18nService) {
                        return i18nService.load();
                    }]
                },
                templateUrl:"/operando/views/popup_view.html"
            });
        $urlRouterProvider.otherwise('/');
    });
