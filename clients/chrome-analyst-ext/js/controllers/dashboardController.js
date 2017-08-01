angular.module("app").controller("dashboardController", function($scope, userService, $state){
    userService.getCurrentUser().then(function(user){
      $scope.user = user;
        $scope.$apply();
    });

    $scope.logout = function(){
        userService.logout().then(function(){
            $state.go("login");
        });
    }
});
