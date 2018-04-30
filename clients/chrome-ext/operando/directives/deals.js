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

angular.module('pfbdeals', [])
    .directive('pfbdeals', ["messengerService", function (messengerService) {
            var templateContent;
            return {
                restrict: 'E',
                replace: true,
                link: function ($scope, element, attrs) {

                    if ($scope.dealsType == "available-deals") {
                        templateContent = '/operando/tpl/deals/pfb-available-deals.html';
                    }
                    else {
                        templateContent = '/operando/tpl/deals/pfb-my-deals.html';
                    }
                },
                controller: function ($scope) {
                    $scope.deals = [];
                        messengerService.send("getAllPfbDeals", function (response) {
                            $scope.deals = response.data;
                            $scope.$apply();
                        });
                },
                templateUrl: "/operando/tpl/deals/all-deals.html"
            }
        }]
    )
    .directive('pfbdealRow', function () {
            return {
                require: "^pfbdeals",
                restrict: 'A',
                replace: true,
                scope: {deal: "="},
                controller: ["$scope","messengerService","Notification","$state",function ($scope, messengerService, Notification) {
                    $scope.showVoucher = false;

                    $scope.showVoucherFn=function(){
                        $scope.showVoucher = true;
                    }

                    $scope.hideVoucherFn=function(){
                        $scope.showVoucher = false;
                    }
                    $scope.toggleDeal = function(){
                        if($scope.deal.subscribed == false){
                            $scope.acceptDeal();
                        }
                        else
                        {
                            $scope.unsubscribeDeal();
                        }
                    }

                    $scope.acceptDeal = function(){
                         messengerService.send("acceptPfbDeal", $scope.deal.offerId, function(response){
                             var deal = response.data;
                             $scope.deal.subscribed = true;
                             $scope.deal.voucher = deal.voucher;
                             $scope.$apply();
                             Notification.success({message: "Deal activated! See email for details.", positionY: 'bottom', positionX: 'center', delay: 5000});
                         })

                    }

                    $scope.unsubscribeDeal = function(){
                        messengerService.send("unsubscribePfbDeal", $scope.deal.offerId, function(response){
                            var deal = response.data;
                            $scope.deal.subscribed = false;
                            $scope.$apply();
                        })
                    }
                }],
                templateUrl: '/operando/tpl/deals/pfbdealRow.html'
            }
        }
    )
    .directive('voucher', function(){
        return {
            require:"^pfbdealRow",
            restrict:"E",
            replace:true,
            scope:{
                voucherCode:"=",
                logo:"=",
                website:"=",
                benefit:"="
            },
            link:function(){

            },
            templateUrl:'/operando/tpl/deals/voucher.html'
        }
    });
