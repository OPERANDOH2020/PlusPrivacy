menuApp.directive("navigation", function( userService, $window){

    return{
        restrict: 'E',
        scope: {
            navigationModel:"=",
            location:"="
        },
        link:function(scope, element){
            jQuery("#site-navigation ul.navbar-nav").append(element);
        },
        templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/navigation/navbar.html',
        controller: function ($scope) {

            $scope.logout = function () {
                userService.logout(function () {
                    delete[$scope.authenticated];
                    delete[$scope.user];
                    $window.location="/";
                });
            };

            userService.getUser(function (user) {
                $scope.authenticated = true;
                $scope.user = user;
                $scope.user['authenticated'] = true;
            });

            userService.isAuthenticated(function(authenticated){
               if(authenticated){

                   $scope.navigationModel.forEach(function(i){
                       accessService.hasAccess(i.zone, function(access){
                           i.visible = access;
                       });
                   });
               }
                else{
                   $scope.navigationModel.forEach(function(i){
                       i.visible = true;
                   });
               }
            });

        }
    }

}).directive("menuItem", function(accessService){
    return{
        restrict: 'E',
        replace: true,
        scope: {
            item:"=",
            location:"="
        },
        templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/navigation/menuItem.html',
        controller:function($scope,$timeout){
            accessService.hasAccess($scope.item.zone, function(access){
                $scope.accessGranted = access;
                $timeout(function(){
                    $scope.$apply();
                });

            });

        }
    }
});
