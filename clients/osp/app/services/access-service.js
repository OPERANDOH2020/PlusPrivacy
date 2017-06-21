angular.module('sharedService').factory("accessService", ["userService", function (userService) {

    var accessRules = {
        ospZone: ['OSP'],
        pspZone: ['PSP', 'Admin'],
        userZone: ["OSP", "PSP", "Public", "Admin"],
        guestZone:"notLoggedIn"
    };

    var AccessService = (function () {

        function AccessService() {

        }

        AccessService.prototype.hasAccess = function (zone, callback) {
            if (accessRules[zone]) {
                userService.isAuthenticated(function (authenticated) {
                    if (authenticated === true) {
                        userService.getUser(function (user) {
                            var userZone = user["organisationId"];
                            if (accessRules[zone].indexOf(userZone) > -1) {
                                callback(true);
                            }
                            else {
                                callback(false);
                            }

                        });
                    } else if (zone === "guestZone") {
                        callback(true);
                    }
                    else callback(false);
                });
            }
            else {
                console.error("Zone " + " " + zone + " is unknown.");
                callback(false);
            }
        };
        return AccessService;
    })();

    if (typeof(window.accessService) === 'undefined' || window.accessService === null) {
        window.accessService = new AccessService();
    }

    return window.accessService;
}]);
