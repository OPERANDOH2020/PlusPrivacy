ospApp.directive("navigationMenu", function (userService, $location,$window) {
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
                        name: "Register",
                        path: "#/register",
                        glyph: "glyphicon-edit",
                        isAuthenticated:false
                    });
                    $scope.menuItems.push({
                        name: "Offers",
                            path: "#/offers",
                            glyph: "glyphicon-eur",
                        isAuthenticated:true
                    });
                    $scope.menuItems.push({
                        name: "Deals",
                        path: "#/deals",
                        glyph: "glyphicon-gift",
                        isAuthenticated:true
                    });

                    $scope.menuItems.push({
                        name: "Account",
                        path: "#/account",
                        glyph: "glyphicon-briefcase",
                        isAuthenticated:true
                    });

                    $scope.menuItems.push({
                        name: "Certifications",
                        path: "#/certifications",
                        glyph: "glyphicon-certificate",
                        isAuthenticated:true
                    });
                    $scope.menuItems.push({
                        name: "Billing",
                        path: "#/billing",
                        glyph: "glyphicon-list-alt",
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
            path = path.substring(1); //hack because path does not return including hashbang
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