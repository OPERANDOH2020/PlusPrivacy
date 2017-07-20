angular.module('app').factory("userService", ["connectionService", function (connectionService){
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
            //connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);

        }

        UserService.prototype.setUser = function (_user) {

            isAuthenticated = true;
            user = _user;


            for(var c = 0; c<waitingUserCallbacks.length; c++){
                waitingUserCallbacks[c](user);
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

        UserService.prototype.getCurrentUser = function () {

            var sequence = Promise.resolve();

            if (user) {
                sequence = sequence.then(function () {
                    return new Promise(function (resolve, reject) {
                        resolve(user);
                    })
                });
                return sequence;
            }
            else {


                sequence = sequence.then(function () {
                    return new Promise(function (resolve, reject) {
                        connectionService.restoreUserSession(function (user) {
                            console.log(user);
                            resolve(user);
                        }, function (error) {
                            reject("NO_USER")
                        });
                    })
                });
                return sequence;


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

        UserService.prototype.logout = function () {
            return new Promise(function (resolve, reject) {
                connectionService.logoutCurrentUser(function(){
                    user = undefined;
                    waitingUserCallbacks = [];
                    resolve();
                });
            });

        };

        return UserService;
    })();

    if (typeof(window.angularUserService) === 'undefined' || window.angularUserService === null) {
        window.angularUserService = new UserService();
    }
    return window.angularUserService;

}]);
