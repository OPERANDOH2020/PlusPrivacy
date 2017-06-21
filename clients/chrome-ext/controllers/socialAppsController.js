angular.module("operando").
controller("socialAppsController", ["$scope", "$state",  function ($scope, $state) {


    $scope.sns = [];

    var readCookieConf = {
        facebook:{
            url:"https://facebook.com",
            cookie_name:"c_user"
        },
        linkedin:{
            url:"https://www.linkedin.com",
            cookie_name:"li_at"
        },
        twitter:{
            url:"https://www.twitter.com",
            cookie_name:"auth_token"
        }
    }


    var readCookie  = function(ospKey,conf){
        return new Promise(function(resolve, reject){
            chrome.cookies.get({url: conf.url, name: conf.cookie_name}, function (cookie) {
                if (cookie) {
                    $scope.sns.push(ospKey);
                    resolve();
                }
                else {
                    resolve("Not logged in "+ospKey);
                }
            });
        });
    }


    var promise = Promise.resolve();
    for (var ospKey in readCookieConf) {
        (function (ospKey) {
            promise = promise.then(function () {
                return readCookie(ospKey, readCookieConf[ospKey]);
            })
        }(ospKey));
    }

    promise.then(function () {
        console.log($scope.sns);
        $scope.$apply();
    });



}]);
