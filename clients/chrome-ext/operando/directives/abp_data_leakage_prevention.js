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
angular.module("adblocker", [])
    .controller('adBlockingController', ['$scope',"$rootScope", "messengerService", function ($scope, $rootScope, messengerService) {

        var knwoAdblockersList = ["cjpalhdlnbpafiamejdnhcphjbkeiagm","epcnnfbjfcgphgdmggkamkmgojdagdnn","oofnbdifeelbaidfgpikinijekkjcicg",
            "pnhflmgomffaphmnbcogleagmloijbkd","pgdnlhfefecpicbbihgmbmffkjpaplco","ddhlopmjhbeaoocojinfhpmlfmikjkln","dmgjckeibmdfndlflobjhddhmemajjld",
            "bgnkhhnnamicmpeenaelnjfhikgbkllg","jacihiikpacjaggdldhcdfjpbibbfjmh","lgblnfidahcdcjddiepkckcfdhpknnjh","ohahllgiabjaoigichmmfljhkcfikeof",
            "pgbllmbdjgcalkoimdfcpknbjgnhjclg","gighmmpiobklfepjocnamgkkbiglidom","cfhdojbkjhnklbpkdaibdccddilifddb"]
        $scope.adblockers = [];





        var filterExtensionsData = function(extensions){
            var filteredExtensions = [];
            extensions.forEach(function(extension){

                if (extension.icons && extension.icons instanceof Array) {
                    extension['icon'] = extension.icons.pop();
                    delete extension['icons'];
                }

               filteredExtensions.push({
                   id:extension.id,
                   name:extension.name,
                   icons:extension.icon
               })
            });
            console.log(filteredExtensions);
            return filteredExtensions;
        }


        chrome.management.getAll(function (results) {

            results = results.filter(function(result){
                return knwoAdblockersList.indexOf(result.id)!=-1;
            });

          $scope.adblockers = filterExtensionsData(results);
        });





}]);

