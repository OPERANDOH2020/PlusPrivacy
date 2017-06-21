menuApp.controller("navigationController", function ($scope, SharedService, userService, accessService, $window) {


    $scope.menuItems = [
        {
            name: "OSP",
            zone:"ospZone",
            subItems: [{
                key: "ospLogin",
                title: "OSP Login",
                zone: "guestZone",
                path: "/osp-login"
            },
                {
                    key: "ospRegister",
                    title: "OSP Register",
                    zone: "guestZone",
                    path: "/osp-register"
                },
                {
                    key: "ospOffers",
                    title: "OSP Offers",
                    zone: "ospZone",
                    path: "/osp-offers"
                },
                {
                    key: "ospDeals",
                    title: "OSP Deals",
                    zone: "ospZone",
                    path: "/osp-deals"
                },
                {
                    key: "ospCertifications",
                    title: "Certifications",
                    zone: "ospZone",
                    path: "/osp-certifications"
                },
                {
                    key: "ospAccount",
                    title: "Account",
                    zone: "ospZone",
                    path: "/osp-account"
                }
            ]
        },
        {
            name: "PSP",
            zone:"pspZone",
            subItems: [{
                key: "pspLogin",
                title: "PSP Login",
                zone: "guestZone",
                path: "/psp-login"
            },

                {
                    key: "pspDashboard",
                    title: "PSP Dashboard",
                    zone: "pspZone",
                    path: "/psp-dashboard"
                }
            ]
        },
        {
            name: "User",
            zone:"userZone",
            subItems: [
                {
                    key: "userLogin",
                    title: "User Login",
                    zone: "guestZone",
                    path: "/login"
                },

                {
                    key: "userRegister",
                    title: "User Register",
                    zone: "guestZone",
                    path: "/register"
                },
                {
                    key: "userDashboard",
                    title: "Dashboard",
                    zone: "userZone",
                    path: "/user-dashboard"
                }
            ]
        }
    ];


    var guestAccessZones = ["ospLogin", "ospRegister", "userLogin", "userRegister", "pspLogin", "pspRegister"];

    SharedService.getLocation(function (location) {
        $scope.location = location;

        if (guestAccessZones.indexOf(location) === -1) {
            accessService.hasAccess(location, function (accessGranted) {
                console.log(accessGranted);
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



