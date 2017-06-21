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

angular.module("UIComponent",[])
    .directive('progressBar',function(){
        return{
            restrict: 'E',
            replace: true,
            scope: {
                current:"=",
                total:"=",
                interval:"=",
            },
            controller : function($scope){
                $scope.$watch("current", function(val){
                    $scope.percent = Math.floor(val*100/$scope.total);
                    var nr_steps = Math.round($scope.total/($scope.interval+1));
                    $scope.steps = [];
                    for(i = 0; i<= nr_steps; i++){
                        $scope.steps.push(Math.round(i*100/nr_steps))
                    }
                })


            },
            templateUrl: '/operando/tpl/ui/progress_bar.html'

        }
    });