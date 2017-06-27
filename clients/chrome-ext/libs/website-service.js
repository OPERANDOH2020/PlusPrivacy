var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;
var portObserversPool = require("observers-pool").portObserversPool;

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

function doPOSTRequest(url, _body, callback){
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function () {
        callback();
    };
    xhr.send(_body);
}

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

        function getAppData(url){
            return new Promise(function (resolve, reject){
                doGetRequest(url, function(data){
                    resolve(data);
                })
            })
        }

        var handleDataForSingleApp = function(appId, crawledPage) {
            var appNameRegex;
            var appIconRegex;
            var permissionsRegex;
            var appVisibility;

            appNameRegex = '<div\\sclass="_5xu4">\\s*<header>\\s*<h3.*?>(.*?)</h3>';
            appIconRegex = /<div\s+class="_5xu4"><i\s+class="img img"\s+style="background-image: url\(&quot;(.+?)&quot;\);/;
            permissionsRegex = '<span\\sclass="_5ovn">(.*?)</span>';
            appVisibility = '<div\\sclass="_52ja"><span>(.*?)</span></div>';

            var name = RegexUtis.findValueByRegex_CleanAndPretty(self.key, 'App Name', appNameRegex, 1, crawledPage, true);
            var iconUrl = RegexUtis.findValueByRegex(self.key, 'App Icon', appIconRegex, 1, crawledPage, true);
            var permissions = RegexUtis.findAllOccurrencesByRegex(self.key, "Permissions Title", permissionsRegex, 1, crawledPage, RegexUtis.cleanAndPretty);
            var visibility = RegexUtis.findValueByRegex_CleanAndPretty(self.key, 'Visibility', appVisibility, 1, crawledPage, true);
            var app = {
                appId:appId,
                iconUrl: iconUrl,
                name: name,
                permissions: permissions,
                visibility:visibility
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
                   var appId = apps[i].getAttribute('href').split('appid=')[1];
                   sequence = sequence.then(function () {
                           return getAppData("https://m.facebook.com/"+apps[i].getAttribute('href'));
                       })
                       .then(function(result){
                           handleDataForSingleApp(appId, result);
                       });
               })(i);

           }

           sequence.then(function(){
               callback(snApps);
           });

        };

        doGetRequest("https://m.facebook.com/privacy/touch/apps/list/?tab=all", getApps)

    },

    getTwitterApps:function(callback){
        var twitterApps = [];

        function getApps(res){

            var rawAppsRegex = '<div\\s?id=\"oauth(?:.+)\"(?:.|\n)*?</div>(?:.|\n)*?</div>(?:.|\n)*?</div>(?:.|\n)*?</div>';
            var rawAppsList = RegexUtis.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, res);

            var appNameRegex = 'strong>(.*?)\\s?</strong';
            var appIdRegex = 'id="oauth_application_(.*?)"\\s?class';

            var iconRegex = '<img\\s+class="app-img"\\s+src="(.*?)"';
            var permissionsRegex = '<p\\s+class="description">.+?\\n.+?<small\\s+class="metadata">(?:.+\\:\\s?)?(.+?)</small></p>';

            twitterApps = rawAppsList.map(function(rawAppData) {
                var appName = RegexUtis.findValueByRegex_Pretty(self.key, 'App Name+Id', appNameRegex, 1, rawAppData, true);
                var appId = RegexUtis.findValueByRegex(self.key, 'Revokde-Id', appIdRegex, 1, rawAppData, true);

                var iconURL = RegexUtis.findValueByRegex(self.key, 'App Icon', iconRegex, 1, rawAppData, true)
                    .unescapeHtmlChars();

                var permissions = RegexUtis.findAllOccurrencesByRegex(self.key, "Extracting Permissions", permissionsRegex, 1, rawAppData, function(value) {
                    return value.unescapeHtmlChars();
                });

                return {
                    'appId': appId,
                    'iconUrl': iconURL,
                    'name': appName,
                    'permissions': permissions
                };
            });
            callback(twitterApps);
        }
        doGetRequest("https://twitter.com/settings/applications?lang=en", getApps)
    },

    getLinkedInApps:function(callback){

        var linkedInApps = [];

        function getApps (res){
            var rawAppsRegex = '<li(?:.|\n)*?\\s?class=\"third-party-app-container\"(?:.|\n)*?</div>(?:.|\n)*?</li>';
            var rawAppsList = RegexUtis.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, res);
            var appIdRegex = 'data-app-id="(.*?)"\\s?data-app-type';
            var appNameRegex = 'p\\s+class="third-party-apps-name">(.*?)</p';

            linkedInApps = rawAppsList.map(function(rawAppData){

                return {
                    appId: RegexUtis.findValueByRegex(self.key, 'Revokde-Id', appIdRegex, 1, rawAppData, true),
                    name: RegexUtis.findValueByRegex_Pretty(self.key, 'App Name+Id', appNameRegex, 1, rawAppData, true)
                }
            });

            console.log(linkedInApps);
            callback(linkedInApps);

        }

        doGetRequest("https://www.linkedin.com/psettings/third-party-applications", getApps)
    },

    removeSocialApp:function(data, callback){

        function extractFBToken(content, callback) {
            var dtsgOption1 = 'DTSGInitialData.*?"token"\\s?:\\s?"(.*?)"';
            var dtsgOption2 = 'name=\\\\?"fb_dtsg\\\\?"\\svalue=\\\\?"(.*?)\\\\?"';
            var dtsgOption3 = 'dtsg"\\s?:\\s?\{"token"\\s?:\\s?"(.*?)';

            var fb_dtsg = RegexUtis.findValueByRegex(self.key, 'fb_dtsg', dtsgOption1, 1, content, false);
            if (!fb_dtsg)
                fb_dtsg = RegexUtis.findValueByRegex(self.key, 'fb_dtsg', dtsgOption2, 1, content, false);
            if (!fb_dtsg)
                fb_dtsg = RegexUtis.findValueByRegex(self.key, 'fb_dtsg', dtsgOption3, 1, content, true);

            var userIdOption1 = '"USER_ID" ?: ?"(.*?)"';
            var userId = RegexUtis.findValueByRegex(self.key, 'USER_ID', userIdOption1, 1, content, true);

            var data = {
                'fb_dtsg': fb_dtsg,
                'userId': userId
            };

            callback(data);
        }

        function extractTwitterToken(content, callback){
            var tokenRegex = 'value="(.*?)" name="authenticity_token"';
            var token = RegexUtis.findValueByRegex(self.key, 'authenticity_token', tokenRegex, 1, content, true);
            callback({token:token});
        }

        function extractLinkedinToken(content, callback){
            var tokenRegex = 'name="csrfToken" value="(.*?)"';
            var token = RegexUtis.findValueByRegex(self.key, 'authenticity_token', tokenRegex, 1, content, true);
            callback({csrfToken:token});
        }

        function removeFbApp(appId){

                    doGetRequest("https://www.facebook.com/settings?tab=applications",function(content){
                       extractFBToken(content,function(data){

                           var _body = "_asyncDialog=1&__user=" + data['userId'] + "&__a=1&__req=o&__rev=1562552&app_id=" + appId
                               + "&legacy=false&dialog=true&confirmed=true&ban_user=0&fb_dtsg=" + data['fb_dtsg'];

                           doPOSTRequest("https://www.facebook.com/ajax/settings/apps/delete_app.php?app_id=" + encodeURIComponent(appId) + "&legacy=false&dialog=true",_body, function(response){
                               callback();
                           })

                       });
                    });
        }

        function removeTwitterApp(appId){
            doGetRequest("https://twitter.com/settings/applications?lang=en", function(content){
                extractTwitterToken(content, function(data){
                    var _body = "token=" + appId + "&" + encodeURIComponent("scribeContext[component]")
                        + "=oauth_app&twttr=true&authenticity_token=" + data.token;
                    doPOSTRequest("https://twitter.com/oauth/revoke",_body, function(response){
                        callback();
                    })
                });
            })
        }

        function removeLinkedinApp(appId){
            doGetRequest("https://www.linkedin.com/psettings/third-party-applications", function(content){
             extractLinkedinToken(content, function(data){
                 var _body = "id="+appId + "&" + "type=OPEN_API" + "&" + "csrfToken="+data.csrfToken;
                 doPOSTRequest("https://www.linkedin.com/psettings/third-party-applications/remove",_body, callback);
             });
            });
        }


        switch(data.sn){
            case "facebook" : removeFbApp(data.appId); break;
            case "twitter" : removeTwitterApp(data.appId); break;
            case "linkedin": removeLinkedinApp(data.appId); break;
        }

    }

};

bus.registerService(websiteService);
