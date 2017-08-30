angular.module("app").controller("AppController", function($rootScope,$transitions){

    var vm = this;
    vm.bodyClasses = 'default';

    $transitions.onSuccess({to:'**'}, function ($state) {
        var toState = $state.$to();
        if (angular.isDefined(toState.data.bodyClasses)) {
            vm.bodyClasses = toState.data.bodyClasses;
            return;
        }
    });

});
