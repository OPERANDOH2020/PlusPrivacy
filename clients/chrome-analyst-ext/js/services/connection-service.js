var Config = new Config();
var SERVER_HOST = Config.swarmClient.host;
var SERVER_PORT = Config.swarmClient.port;
var TENANT = Config.swarmClient.tenant;

angular.module("app").factory("connectionService", function(swarmService){

    var ConnectionService;
    ConnectionService = (function () {

        function ConnectionService() {

        }

        ConnectionService.prototype.loginUser = function (user, successCallback, failCallback) {

            var self = this;
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, user.email, user.password,
                TENANT, "userLogin", function (error) {
                });

            var userLoginSuccess = function (swarm) {
                swarmHub.off("login.js", "success", userLoginSuccess);
                if (swarm.authenticated) {

                    var daysUntilCookieExpire = 1;
                    if (user.remember) {
                        daysUntilCookieExpire = 365;
                    }

                    Cookies.set("daysUntilCookieExpire", daysUntilCookieExpire, {expires: 3650});
                    Cookies.set("sessionId", swarm.meta.sessionId, {expires: daysUntilCookieExpire});
                    Cookies.set("userId", swarm.userId, {expires: daysUntilCookieExpire});
                    self.getUser(successCallback);

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


        ConnectionService.prototype.restoreUserSession = function (successCallback, failCallback) {
            var username = Cookies.get("userId");
            var sessionId = Cookies.get("sessionId");
            var self = this;

            /*
             TODO
             I could send the failCallback function, but the SwarmClient should be modified in the future
             */

            var failCallbackPlaceholder = function () {
            };

            if (!username || !sessionId) {
                failCallback();
            }
            else {
                swarmService.restoreConnection(SERVER_HOST, SERVER_PORT, failCallbackPlaceholder, failCallbackPlaceholder, function () {
                    //console.log("reconnected");
                    //self.restoreUserSession(successCallback, failCallback);

                });
                swarmHub.on('login.js', "restoreSucceed", function restoredSuccessfully(swarm) {
                    self.getUser(successCallback);
                    swarmHub.off("login.js", "restoreSucceed", restoredSuccessfully);
                });

                //if server will shutdown
                swarmHub.on('login.js', "restoreSucceed", function (swarm) {
                    var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
                    Cookies.set("sessionId", swarm.meta.sessionId, {expires: cookieValidityDays});
                    Cookies.set("userId", swarm.userId, {expires: cookieValidityDays});
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

        ConnectionService.prototype.getOSPSettings = function(callback){
            var getOSPSettingsHandler = swarmHub.startSwarm('PrivacyWizardSwarm.js', 'getOSPSettings');
            getOSPSettingsHandler.onResponse("gotOSPSettings",function(swarm){
                callback(swarm.ospSettings);
            });
        }

        return ConnectionService;

    })();

    if (typeof(window.angularConnectionService) === 'undefined' || window.angularConnectionService === null) {
        window.angularConnectionService = new ConnectionService();
    }

    return window.angularConnectionService;

});