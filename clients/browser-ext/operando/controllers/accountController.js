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


angular.module("operando").
controller("accountCtrl", ["$scope","messengerService","Notification","ModalService", function($scope, messengerService,Notification, ModalService){

    $scope.user = {
        password: "",
        confirmPassword: ""
    };

    messengerService.send("getCurrentUser", function(response){
        $scope.email = response.data.email;
        $scope.$apply();
    })

    var alias = this;

    $scope.passwordIsEditMode = false;


    $scope.changePassword = function () {
        $scope.passwordIsEditMode = !$scope.passwordIsEditMode;
    }

    alias.savePassword = function () {

        messengerService.send("changePassword",{currentPassword:$scope.user.currentPassword,newPassword:$scope.user.newPassword}, function(response){

            $scope.submitPasswordBtn.button('reset');

            if(response.status == "success"){
                Notification.success({message: "Password successfully updated!", positionY: 'bottom', positionX: 'center', delay: 5000});
                $scope.passwordIsEditMode = !$scope.passwordIsEditMode;

                $scope.user = {};
                alias.changePasswordForm.$setPristine();
                alias.changePasswordForm.$setUntouched();
            }
            else{
                Notification.error({message: response.error, positionY: 'bottom', positionX: 'center', delay: 5000});


                var  checkValidity = function(model,field){
                    $scope.$watch(model, function(newValue, oldValue){
                        field.$setValidity("invalidPassword",newValue != oldValue );
                    });
                }

                checkValidity("user.currentPassword",alias.changePasswordForm.currentPassword);

            }
        });

    }

    $scope.loading = function($event){
        $scope.submitPasswordBtn = $($event.currentTarget);
        $scope.submitPasswordBtn.button('loading');
    }

    $scope.deleteAccount = function(){
        ModalService.showModal({
            templateUrl: '/tpl/modals/delete_account.html',
            controller: function ($scope, close) {

                $scope.removeAccount = function () {
                    messengerService.send("removeAccount", function (response) {
                        if (response.status === "success") {
                            ModalService.showModal({
                                templateUrl: '/tpl/modals/account_is_deleted.html',
                                controller: function ($scope, close) {
                                    $scope.close = function (result) {
                                        close(result, 500);
                                        messengerService.send("resetExtension");
                                    };
                                }
                            }).then(function (modal) {
                                modal.element.modal();
                            });
                        }
                    });
                };

                $scope.close = function (result) {
                    close(result, 500);
                };
            }
        }).then(function (modal) {
            modal.element.modal();
        });
    }

}]).directive("compareTo", function(){
    return {
        require: "ngModel",
        scope: {
            otherModelValue: "=compareTo"
        },
        link: function(scope, element, attributes, ngModel) {

            ngModel.$validators.compareTo = function(modelValue) {
                return modelValue == scope.otherModelValue;
            };

            scope.$watch("otherModelValue", function() {
                ngModel.$validate();
            });
        }
    };
})
    .directive("differentFrom", function(){
        return {
            require: "ngModel",
            scope: {
                otherModelValue: "=differentFrom"
            },
            link: function(scope, element, attributes, ngModel) {

                ngModel.$validators.differentFrom = function(modelValue) {
                    return modelValue != scope.otherModelValue;
                };

                scope.$watch("otherModelValue", function() {
                    ngModel.$validate();
                });
            }
        };
    });


