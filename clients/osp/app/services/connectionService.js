//var SERVER_HOST = "plusprivacy.com";
var SERVER_HOST = "localhost";
var SERVER_PORT = "8080";
var GUEST_EMAIL = "guest@operando.eu";
var GUEST_PASSWORD = "guest";

angular.module('sharedService').factory("connectionService",function(swarmService, messengerService) {

    var ConnectionService;
    ConnectionService = (function () {

        function ConnectionService() {

        }

        ConnectionService.prototype.activateUser = function (activationCode, successCallback, failCallback) {
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
                swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
                if (swarm.authenticated) {
                    var verifyAccountHandler = swarmHub.startSwarm("register.js", "verifyValidationCode", activationCode);
                    verifyAccountHandler.onResponse("success", function (swarm) {
                        swarmService.removeConnection();

                        var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
                        Cookies.set("sessionId", swarm.validatedUserSession.sessionId,{expires:cookieValidityDays});
                        Cookies.set("userId", swarm.validatedUserSession.userId,{expires:cookieValidityDays});
                        successCallback(swarm.validatedUserSession);

                    });

                    verifyAccountHandler.onResponse("failed", function (swarm) {
                        swarmService.removeConnection();
                        failCallback(swarm.error);
                    });
                }
            });
        };

        ConnectionService.prototype.loginUser = function (user, userType, successCallback, failCallback) {

            var loginCtor;
            switch (userType){
                case "Public" : loginCtor = "userLogin"; break;
                case "OSP": loginCtor = "ospLogin"; break;
                case "PSP": loginCtor ="pspLogin"; break;
            }

            var self = this;

            swarmService.initConnection(SERVER_HOST, SERVER_PORT, user.email, user.password,
                "plusprivacy-website", loginCtor, function (error) {
                });

            var userLoginSuccess = function (swarm) {
                swarmHub.off("login.js", "success", userLoginSuccess);
                if (swarm.authenticated) {

                    var daysUntilCookieExpire = 1;
                    if(user.remember){
                        daysUntilCookieExpire = 365;
                    }

                    Cookies.set("daysUntilCookieExpire",daysUntilCookieExpire,{expires:3650});
                    Cookies.set("sessionId", swarm.meta.sessionId, {expires: daysUntilCookieExpire});
                    Cookies.set("userId", swarm.userId, {expires: daysUntilCookieExpire});

                    self.getUser(successCallback);

                    messengerService.send("authenticateUserInExtension", {
                        userId: swarm.userId,
                        authenticationToken: swarm.authenticationToken,
                     remember: user.remember
                     }, function (status) {
                        successCallback({status: "success"});
                     });
                }
            };

            var loginFailed = function (swarm) {
                failCallback(swarm.error);
                swarmHub.off("login.js", "success", userLoginSuccess);
                swarmHub.off("login.js", "failed", loginFailed);
            };

            swarmHub.on("login.js", "success", userLoginSuccess);
            swarmHub.on('login.js', "failed", loginFailed);
        };


        ConnectionService.prototype.generateAuthenticationToken = function (successCallback, failCallback) {
            var generateAuthenticationTokenHandler =  swarmHub.startSwarm('UserInfo.js', 'generateAnAuthenticationToken');
            generateAuthenticationTokenHandler.onResponse("generateAuthenticationTokenSuccess", function(response){
               successCallback(response.meta.userId,response.authenticationToken);
            });
            generateAuthenticationTokenHandler.onResponse("generateAuthenticationTokenFailed", function(response){
                failCallback(response.error);
            });
        };

        ConnectionService.prototype.getUser = function (callback) {
            var getUserHandler = swarmHub.startSwarm('UserInfo.js', 'info');
            getUserHandler.onResponse("result", function (swarm) {
                authenticated = true;
                user = swarm.result;
                if (callback) {
                    callback(user);
                }
            });
        };

        /*used for getting authenticated user in extension*/
        ConnectionService.prototype.getCurrentUser = function (successCbk) {
            messengerService.send("getCurrentUserLoggedInInExtension", function (data) {
                successCbk(data);
            });
        };

        ConnectionService.prototype.registerNewUser = function (user, successCallback, failCallback) {
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
                swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
                if (swarm.authenticated) {
                    var registerHandler = swarmHub.startSwarm("register.js", "registerNewUser", user);
                    registerHandler.onResponse("success", function (swarm) {
                        successCallback("success");
                        swarmService.removeConnection();
                    });

                    registerHandler.onResponse("error", function (swarm) {
                        failCallback(swarm.error);
                        swarmService.removeConnection();
                    });
                }
            });
        };

        ConnectionService.prototype.resendActivationCode = function(email, successCallback, errorCallback){

            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            var guestLoginForUserRegistration = function(swarm){
                swarmHub.off("login.js", "success_guest",guestLoginForUserRegistration);
                if(swarm.authenticated){
                    var resendActivationCodeHandler = swarmHub.startSwarm("register.js", "sendActivationCode", email);
                    resendActivationCodeHandler.onResponse("success", function(swarm){
                        successCallback();
                        swarmService.removeConnection();
                    });

                    resendActivationCodeHandler.onResponse("failed", function(swarm){
                        errorCallback(swarm.error);
                        swarmService.removeConnection();
                    });
                }
            };

            swarmHub.on("login.js", "success_guest",guestLoginForUserRegistration);

        };

        ConnectionService.prototype.restoreUserSession = function (successCallback, failCallback) {
            var username = Cookies.get("userId");
            var sessionId = Cookies.get("sessionId");
            var self = this;

            /*
            TODO
            I could send the failCallback function, but the SwarmClient should be modified in the future
             */

            var failCallbackPlaceholder = function(){};

            if (!username || !sessionId) {
                failCallback();
            }
            else {
                swarmService.restoreConnection(SERVER_HOST, SERVER_PORT, failCallbackPlaceholder, failCallbackPlaceholder, function () {
                    //console.log("connectionIsDown");
                    //self.restoreUserSession(successCallback, failCallback);

                });
                swarmHub.on('login.js', "restoreSucceed", function restoredSuccessfully(swarm) {
                    self.getUser(successCallback);
                    swarmHub.off("login.js", "restoreSucceed", restoredSuccessfully);
                });

                //if server will shutdown
                swarmHub.on('login.js', "restoreSucceed", function (swarm) {
                    var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
                    Cookies.set("sessionId", swarm.meta.sessionId,{expires: cookieValidityDays});
                    Cookies.set("userId", swarm.userId,{expires: cookieValidityDays});
                });

                swarmHub.on('login.js', "restoreFailed", function restoredSuccessfully(swarm) {
                    //Cookies.remove("userId");
                    //Cookies.remove("sessionId");

                    failCallback();
                    swarmHub.off("login.js", "restoreSucceed", restoredSuccessfully);
                });
            }
        };

        ConnectionService.prototype.logoutCurrentUser = function (callback) {
            swarmHub.startSwarm("login.js", "logout");
            swarmHub.on("login.js", "logoutSucceed", function logoutSucceed(swarm) {
                Cookies.remove("userId");
                Cookies.remove("sessionId");
                swarmHub.off("login.js", "logoutSucceed", logoutSucceed);
                swarmService.removeConnection();
                if (callback) {
                    callback();
                }
            });
        };

        ConnectionService.prototype.registerNewOSPOrganisation = function (user, successCallback, failCallback) {
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
                swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
                if (swarm.authenticated) {

                    var registerOSPHandler = swarmHub.startSwarm("login.js", "registerNewOSPOrganisation", user);
                    registerOSPHandler.onResponse("success", function (swarm) {
                        successCallback("success");
                        swarmService.removeConnection();
                    });

                    registerOSPHandler.onResponse("error", function (swarm) {
                        failCallback(swarm.error);
                        swarmService.removeConnection();
                    });
                }
            });
        };

        ConnectionService.prototype.getOspRequests = function (successCallback, failCallback) {
            var getRequestsHandler = swarmHub.startSwarm("osp.js", "getRequests");
            getRequestsHandler.onResponse("success", function (swarm) {
                successCallback(swarm.ospRequests);
            });

            getRequestsHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.deleteOSPRequest = function (userId, dismissFeedback, successCallback, failCallback) {
            var getDeleteRequestHandler = swarmHub.startSwarm("osp.js", "removeOSPRequest", userId, dismissFeedback);
            getDeleteRequestHandler.onResponse("success", function (swarm) {
                successCallback();
            });

            getDeleteRequestHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.acceptOSPRequest = function (userId, successCallback, failCallback) {
            var acceptRequestHandler = swarmHub.startSwarm("osp.js", "acceptOSPRequest", userId);
            acceptRequestHandler.onResponse("success", function (swarm) {
                successCallback();
            });

            acceptRequestHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.listOSPs = function (successCallback, failCallback) {
            var listOSPsHandler = swarmHub.startSwarm("osp.js", "listOSPs");
            listOSPsHandler.onResponse("success", function (swarm) {
                successCallback(swarm.ospList);
            });

            listOSPsHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };
        ConnectionService.prototype.addOspOffer = function (offerDetails, successCallback, failCallback) {
            var addOspOfferHandler = swarmHub.startSwarm("osp.js", "addOspOffer", offerDetails);
            addOspOfferHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offer);
            });

            addOspOfferHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };
        ConnectionService.prototype.deleteOspOffer = function (offerId, successCallback, failCallback) {
            var deleteOspOfferHandler = swarmHub.startSwarm("osp.js", "deleteOspOffer", offerId);
            deleteOspOfferHandler.onResponse("success", function (swarm) {
                successCallback();
            });

            deleteOspOfferHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.listOSPOffers = function (successCallback, failCallback) {
            var listOspOffersHandler = swarmHub.startSwarm("osp.js", "listOSPOffers");
            listOspOffersHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offers);
            });

            listOspOffersHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.getOffersStats = function(ospId, successCallback, failCallback){
            var listOspOffersHandler = swarmHub.startSwarm("osp.js", "getOffersStats",ospId);
            listOspOffersHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offersStats);
            });

            listOspOffersHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };


        ConnectionService.prototype.getMyOffersDetails = function(successCallback, failCallback){
            var listOspOffersHandler = swarmHub.startSwarm("osp.js", "getCurrentUserOffers");
            listOspOffersHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offersStats);
            });

            listOspOffersHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.getOfferStatistics = function(offerId,successCallback, failCallback){
            var listOspOffersHandler = swarmHub.startSwarm("osp.js", "getOfferStatistics",offerId);
            listOspOffersHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offerStats);
            });

            listOspOffersHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };



        return ConnectionService;

    })();

    if (typeof(window.angularConnectionService) === 'undefined' || window.angularConnectionService === null) {
        window.angularConnectionService = new ConnectionService();
    }

    return window.angularConnectionService;
});

