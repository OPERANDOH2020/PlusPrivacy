angular.module('sharedService').factory("userService", ["connectionService", function (connectionService){
    var UserService;
    UserService = (function () {

        var user;
        var waitingUserCallbacks = [];
        var restoredCompleted = false;
        var isAuthenticated;
        var couldBeRestoredCallbacks = [];

        function handleRestoredCallbacks(){
            while(couldBeRestoredCallbacks.length>0){
                var restoredCallback = couldBeRestoredCallbacks.pop();
                restoredCallback(isAuthenticated);
            }
        }

        function UserService() {
            var self = this;
            var restoredSessionSuccessfully = function (user) {
                self.setUser(user);
                isAuthenticated = true;
                restoredCompleted = true;
                handleRestoredCallbacks();

            };

            var restoredSessionFailed = function () {
                restoredCompleted = true;
                isAuthenticated = false;
                handleRestoredCallbacks();
            };
            connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);

        }

        UserService.prototype.setUser = function (_user) {

            isAuthenticated = true;
            user = _user;

            while(waitingUserCallbacks.length>0){
                var waitingUserCbk = waitingUserCallbacks.pop();
                waitingUserCbk(user);
            }
        };

        UserService.prototype.getUser = function (callback) {
            if(user){
                callback(user);
            }
            else{
                waitingUserCallbacks.push(callback);
            }
        };

        UserService.prototype.isAuthenticated = function (callback) {
            if(restoredCompleted){
                callback(isAuthenticated);
            }
            else{
                couldBeRestoredCallbacks.push(callback);
            }
        };

        UserService.prototype.logout = function (callback) {
            connectionService.logoutCurrentUser(function(){
                user = undefined;
                waitingUserCallbacks = [];
                if(callback){
                    callback();
                }
            });
        };

        return UserService;
    })();

    if (typeof(window.angularUserService) === 'undefined' || window.angularUserService === null) {
        window.angularUserService = new UserService();
    }
    return window.angularUserService;

}]);
