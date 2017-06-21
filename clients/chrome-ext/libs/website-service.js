var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;
var portObserversPool = require("observers-pool").portObserversPool;

var websiteService = exports.websiteService = {

    authenticateUserInExtension: function (data) {
        authenticationService.authenticateWithToken(data.userId, data.authenticationToken, function () {
            chrome.runtime.openOptionsPage();
        }, function () {
            //status.fail = "fail";

        }, function () {
            //status.error = "error";

        }, function () {
            //status.reconnect = "reconnect";

        });
    },

    getCurrentUserLoggedInInExtension:function(){
        portObserversPool.trigger("getCurrentUserLoggedInInExtension", authenticationService.getUser());
    },

    goToDashboard:function(){
        if(authenticationService.isLoggedIn()){
            chrome.runtime.openOptionsPage();
        }
        else{
            portObserversPool.trigger("goToDashboard","sendMeAuthenticationToken");
        }

    },

    logout:function(){
        authenticationService.disconnectUser(function(message){
            portObserversPool.trigger("logout",message);
        });
    },

    loggedIn: function(){
        authenticationService.getCurrentUser(
            function(message){
                portObserversPool.trigger("loggedIn",message);
            }

        );
    },

    getFacebookApps:function(callback){

        var snApps = [];

       function doGetRequest(url,callback){
           var oReq = new XMLHttpRequest();
           oReq.onreadystatechange = function() {
               if (oReq.readyState == XMLHttpRequest.DONE) {
                   callback(oReq.responseText);
               }
           };
           oReq.open("GET", url);
           oReq.send();
       }


        function getAppData(url){
            console.log(url);
            return new Promise(function (resolve, reject){
                doGetRequest(url, function(data){
                    resolve(data);
                })
            })
        }

        var handleDataForSingleApp = function crawlExtraDataForSingleApp(crawledPage) {
            console.log(crawledPage);
            var appNameRegex;
            var appIconRegex;
            var permissionsRegex;

            appNameRegex = '<div\\sclass="_5xu4">\\s*<header>\\s*<h3.*?>(.*?)</h3>';
            appIconRegex = /<div\s+class="_5xu4"><i\s+class="img img"\s+style="background-image: url\(&quot;(.+?)&quot;\);/;
            permissionsRegex = '<span\\sclass="_5ovn">(.*?)</span>';

            var name = RegexUtis.findValueByRegex_CleanAndPretty(self.key, 'App Name', appNameRegex, 1, crawledPage, true);
            var iconUrl = RegexUtis.findValueByRegex(self.key, 'App Icon', appIconRegex, 1, crawledPage, true);
            var permissions = RegexUtis.findAllOccurrencesByRegex(self.key, "Permissions Title", permissionsRegex, 1, crawledPage, RegexUtis.cleanAndPretty);

            var app = {
                iconUrl: iconUrl,
                name: name,
                permissions: permissions
            };

            snApps.push(app)
        };

       var getApps = function (res) {
           var parser = new DOMParser();
           var doc = parser.parseFromString(res, "text/html");
           var sequence = Promise.resolve();
           var apps = doc.getElementsByClassName("_5b6s");

           for (var i = 0; i < apps.length; i++) {
               (function(i){
                   sequence = sequence.then(function () {
                           return getAppData("https://m.facebook.com/"+apps[i].getAttribute('href'));
                       })
                       .then(handleDataForSingleApp);
               })(i);

           }

           sequence.then(function(){
               callback(snApps);
           });

        };

        doGetRequest("https://m.facebook.com/privacy/touch/apps/list/?tab=all", getApps)

    }


};





bus.registerService(websiteService);
