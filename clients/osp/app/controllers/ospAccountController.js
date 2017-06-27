angular.module("ospApp").controller("accountCtrl", ["$scope","connectionService","Notification","userService","$timeout", function($scope, connectionService, Notification, userService,$timeout){
    $scope.user = {
        password: "",
        confirmPassword: ""
    };
    $timeout(function () {
        userService.getUser(function (user) {
            $scope.email = user.email;
            $scope.$apply();

        })
    }, 50);

    var alias = this;

    $scope.emailIsEditMode = false;
    $scope.passwordIsEditMode = false;

    $scope.changeEmailState = function(){
        $scope.emailIsEditMode = !$scope.emailIsEditMode;
    }

    $scope.changePassword = function () {
        $scope.passwordIsEditMode = !$scope.passwordIsEditMode;
    }

    alias.savePassword = function () {


        connectionService.changePassword({currentPassword:$scope.user.currentPassword,newPassword:$scope.user.newPassword},function(){
            Notification.success({message: "Password successfully updated!", positionY: 'bottom', positionX: 'center', delay: 5000});
            $scope.passwordIsEditMode = !$scope.passwordIsEditMode;

            $scope.user = {};
            alias.changePasswordForm.$setPristine();
            alias.changePasswordForm.$setUntouched();
        },function(err){

            Notification.error({message: error, positionY: 'bottom', positionX: 'center', delay: 5000});
            var  checkValidity = function(model,field){
                $scope.$watch(model, function(newValue, oldValue){
                    field.$setValidity("invalidPassword",newValue != oldValue );
                });
            };

            checkValidity("user.currentPassword",alias.changePasswordForm.currentPassword);
        });
    };
    $scope.updateEmail = function () {
        connectionService.updateUserInfo({email: $scope.email}, function (response) {
            console.log(response);
            $scope.emailIsEditMode = false;
            Notification.success({
                message: "Email successfully updated!",
                positionY: 'bottom',
                positionX: 'center',
                delay: 3000
            });
        }, function (error) {
            Notification.error({message: error, positionY: 'bottom', positionX: 'center', delay: 3000});
        })
    };

    $scope.loading = function($event){
        $scope.submitPasswordBtn = jQuery($event.currentTarget);
        $scope.submitPasswordBtn.button('loading');
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


