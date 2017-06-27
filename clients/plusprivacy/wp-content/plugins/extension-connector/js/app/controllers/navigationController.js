menuApp.controller("navigationController", function ($scope, SharedService, userService, accessService, $window) {


    $scope.menuItems = [

        {
            key: "userLogin",
            title: "Login",
            glyphicon:"user",
            zone: "guestZone",
            path: "/login"
        },

        {
            key: "userRegister",
            title: "Register",
            zone: "guestZone",
            glyphicon:"edit",
            path: "/register"
        },
        {
            key: "userDashboard",
            title: "Dashboard",
            zone: "userZone",
            glyphicon:"dashboard",
            path: "/user-dashboard"

        }
    ];


    var guestAccessZones = ["userLogin", "userRegister"];

    SharedService.getLocation(function (location) {
        $scope.location = location;

        if (guestAccessZones.indexOf(location) === -1) {
            accessService.hasAccess(location, function (accessGranted) {
                if (accessGranted === false) {
                    $window.location.href = "/";

                }
            });
        }
        else {
            $scope.$apply();
        }

    });

});



