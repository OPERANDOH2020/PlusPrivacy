pspApp.directive("navigationMenu", function (userService, $location,$window) {
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl: '/assets/templates/navigation-menu.html',
        controller: function ($scope) {

            $scope.menuItems = [];
            $scope.user = {};
            $scope.authenticated = false;

                    $scope.menuItems.push({
                        name: "Login",
                        path: "#/login",
                        glyph: "glyphicon-user",
                        isAuthenticated:false
                    });


                    $scope.menuItems.push({
                        name: "OSP Requests",
                            path: "#/osp-requests",
                            glyph: "glyphicon-transfer",
                        isAuthenticated:true
                    });

                    $scope.menuItems.push({
                        name: "OSP Members",
                        path: "#/osp-members",
                        glyph: "glyphicon-th-large",
                        isAuthenticated:true
                    });



                    userService.getUser(function(user){
                       $scope.user = user;
                       $scope.authenticated = true;
                       $scope.$apply();

                    });


            $scope.logout = function(){
                userService.logout(function(){
                    $scope.authenticated = false;
                    $scope.$apply();
                    window.location.assign("/")
                })
            }
        }
    }

}).directive('activeLink', ['$location', function (location) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs, controller) {
            var clazz = attrs.activeLink;
            var path = attrs.path;
            path = path.substring(1);
            scope.location = location;
            scope.$watch('location.path()', function (newPath) {
                if (path === newPath) {
                    element.addClass(clazz);
                } else {
                    element.removeClass(clazz);
                }
            });
        }
    }}]);