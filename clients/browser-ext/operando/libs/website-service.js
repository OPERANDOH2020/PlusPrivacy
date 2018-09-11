var bus = require("bus-service").bus;
var chromeUserAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.9 Safari/537.36";
var authenticationService = require("authentication-service").authenticationService;
var portObserversPool = require("observers-pool").portObserversPool;
var socialNetworkService = require("social-network-service").socialNetworkService;
var interceptorService = require("request-intercepter-service").requestInterceptor;
var userService = require("user-service").userService;

function doTwitterAppsRequest(url, callback) {

    var oReq = new XMLHttpRequest();
    oReq.onreadystatechange = function () {
        if (oReq.readyState == XMLHttpRequest.DONE) {
            userService.updateTrackingImplicitValue();
            callback(oReq.responseText, true);
        }
    };

    userService.verifyTrackingIsDown(function(){
        oReq.open("GET", url);
        oReq.withCredentials = true;
        interceptorService.interceptHeadersBeforeRequest("twitter-apps");
        oReq.setRequestHeader("get-twitter-apps","1");
        oReq.send();
    });

}

function doGetRequest(url, data, callback) {

    if(data instanceof Function){
        callback = data;
    }

    var oReq = new XMLHttpRequest();
    oReq.onreadystatechange = function () {
        if (oReq.readyState == XMLHttpRequest.DONE) {
            userService.updateTrackingImplicitValue();
            callback(oReq.responseText, true);
        }
    };
    var args = arguments;
    userService.verifyTrackingIsDown(function(){

        oReq.open("GET", url);
        if (args.length > 2) {
            if (data.headers) {
                oReq.withCredentials = true;
                data.headers.forEach(function (header) {
                    oReq.setRequestHeader(header.name, header.value);
                });
            }
        }
        oReq.send();
    });
}

function doPOSTRequest(url, data, callback) {
    var xhr = new XMLHttpRequest();

    userService.verifyTrackingIsDown(function(){

    xhr.open('POST', url, true);

    if (data.headers) {
        data.headers.forEach(function (header) {
            xhr.setRequestHeader(header.name, header.value);
        });
    }
    else {
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }

    xhr.onload = function () {
        userService.updateTrackingImplicitValue();
        callback(this.responseText);
    };
    xhr.send(data._body ? data._body : data);
    });
}

var websiteService = exports.websiteService = {

    authenticateUserInExtension: function (data) {
        var maxAuthenticationsAllowed = 1;
        authenticationService.authenticateWithToken(data.userId, data.authenticationToken, function (res) {
            console.log("authenticated here");
            if(maxAuthenticationsAllowed >0){
                chrome.runtime.openOptionsPage();
            }
            maxAuthenticationsAllowed--;

        }, function () {


        }, function () {


        }, function () {

        });
    },

    getCurrentUserLoggedInInExtension: function () {
        portObserversPool.trigger("getCurrentUserLoggedInInExtension", authenticationService.getUser());
    },

    goToDashboard: function () {
        if (authenticationService.isLoggedIn()) {
            chrome.tabs.create({url: chrome.runtime.getURL("operando.html#/home"), "active": true});
        }
        else {
            portObserversPool.trigger("goToDashboard", "sendMeAuthenticationToken");
        }
    },

    logout: function () {
        authenticationService.notifyWhenLogout(function (message) {
            portObserversPool.trigger("logout", message);
        });
    },

    loggedIn: function () {
        authenticationService.getCurrentUser(
            function (message) {
                portObserversPool.trigger("loggedIn", message);
            }
        );
    },

    getFacebookApps: function (callback) {

        var snApps = [];

        function getAppData(url) {
            return new Promise(function (resolve, reject) {
                var headers = [{name:"User-Agent",value:chromeUserAgent}];
                doGetRequest(url, {headers:headers}, function (data) {
                    resolve(data);
                })
            })
        }

        var handleDataForSingleApp = function (appId, crawledPage) {
            var appNameRegex;
            var appIconRegex;
            var permissionsRegex;
            var appVisibility;

            appNameRegex = '<div\\sclass="_5xu4">\\s*<header>\\s*<h3.*?>(.*?)</h3>';
            appIconRegex = /<div\s+class="_5xu4"><i\s+class="img img _2sxw"\s+style="background-image: url\(&#039;(.+?)&#039;\);/;
            permissionsRegex = '<span\\sclass="_5ovn">(.*?)</span>';
            appVisibility = '<div\\sclass="_52ja"><span>(.*?)</span></div>';

            var name = RegexUtils.findValueByRegex_CleanAndPretty(self.key, 'App Name', appNameRegex, 1, crawledPage, true);
            var iconUrl = RegexUtils.findValueByRegex(self.key, 'App Icon', appIconRegex, 1, crawledPage, true);
            var permissions = RegexUtils.findAllOccurrencesByRegex(self.key, "Permissions Title", permissionsRegex, 1, crawledPage, RegexUtils.cleanAndPretty);
            var visibility = RegexUtils.findValueByRegex_CleanAndPretty(self.key, 'Visibility', appVisibility, 1, crawledPage, true);
            var app = {
                appId: appId,
                iconUrl: iconUrl,
                name: name,
                permissions: permissions,
                visibility: visibility
            };

            snApps.push(app)
        };

        var getApps = function (res) {
            var parser = new DOMParser();
            var doc = parser.parseFromString(res, "text/html");
            var sequence = Promise.resolve();
            var appsContainer = doc.getElementsByClassName("_xef");

            var apps = [];

            for(var i = 0; i<appsContainer.length; i++){
                apps.push(appsContainer[i].children[0].children[0].children[0].children[0]);
            }

            for (var i = 0; i < apps.length; i++) {
                (function (i) {
                    var appId = apps[i].getAttribute('href').split('appid=')[1];
                    sequence = sequence.then(function () {
                            return getAppData("https://m.facebook.com/" + apps[i].getAttribute('href'));
                        })
                        .then(function (result) {
                            handleDataForSingleApp(appId, result);
                        });
                })(i);
            }

            sequence.then(function () {
                callback(snApps);
            });

        };
        var headers = [{name:"User-Agent",value:chromeUserAgent}];
        doGetRequest("https://m.facebook.com/settings/apps/tabbed/", {headers:headers},getApps)

    },

    getTwitterApps: function (callback) {
        var twitterApps = [];

        function getApps(res) {

            JSON.parse(res).applications.forEach(function (app) {
                twitterApps.push({
                    'appId': app.token,
                    'iconUrl': app.img_url,
                    'name': app.name,
                    'permissions': {
                        can_read_dms: app.can_read_dms,
                        can_write: app.can_write,
                        can_read: app.can_read,
                        email_access: app.email_access
                    }
                })
            });

            callback(twitterApps);

        }

        doTwitterAppsRequest("https://twitter.com/settings/sessions", function (rawAppData) {
            var authenticationScriptRegex = '<link rel="dns-prefetch" href="https:\\/\\/t.co">\\s+<link rel="preload" href="((?:.+))" as="script">';
            var rawAuthenticationScriptUrl = RegexUtils.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', authenticationScriptRegex, 1, rawAppData);
            doTwitterAppsRequest(rawAuthenticationScriptUrl, function (scriptData) {
                var authenticationBearerRegex = '"E\\/\\/N":function\\(e,t,i\\){"use strict";t.a="((?:.+))"},EGZi';
                var authenticationBearer = "Bearer " + RegexUtils.findValueByRegex(self.key, 'List of Raw Apps', authenticationBearerRegex, 1, scriptData);

                chrome.cookies.getAll({url: "https://twitter.com"}, function (cookies) {

                    var csrf_cookie = cookies.find(function (cookie) {
                        return cookie.name === "ct0";
                    });

                    interceptorService.interceptHeadersBeforeRequest("twitter-apps");
                    var headers = [
                        {name: "authorization", value: authenticationBearer},
                        {name: "x-twitter-auth-type", value: "OAuth2Session"},
                        {name: "x-twitter-active-user", value: "yes"},
                        {name: "x-csrf-token", value: csrf_cookie.value},
                        {name: "get-twitter-apps", value: 1}
                    ];
                    doGetRequest("https://api.twitter.com/1.1/oauth/list", {headers: headers}, getApps);

                })
            });


        });

    },

    getLinkedInApps: function (callback) {

        var linkedInApps = [];

        function getApps(res) {
            var rawAppsRegex = '<li\\s+id=\"permitted-service-(?:.|\n)*?</div>(?:.|\n)*?</li>';
            var rawAppsList = RegexUtils.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, res);
            var appIdRegex = 'data-app-id="(.*?)"\\s?data-app-type';
            var appNameRegex = 'p\\s+class="permitted-service-name">(.*?)</p';
            var iconRegex = 'src=\"(.*?)\"';

            linkedInApps = rawAppsList.map(function (rawAppData) {

                return {
                    appId: RegexUtils.findValueByRegex(self.key, 'Revokde-Id', appIdRegex, 1, rawAppData, true),
                    name: RegexUtils.findValueByRegex_Pretty(self.key, 'App Name+Id', appNameRegex, 1, rawAppData, true),
                    iconUrl: RegexUtils.findValueByRegex(self.key, 'App Icon', iconRegex, 1, rawAppData, true)
                        .unescapeHtmlChars()
                }
            });

            callback(linkedInApps);

        }

        doGetRequest("https://www.linkedin.com/psettings/permitted-services", getApps)
    },

    getGoogleApps: function (callback) {
        var googleApps = [];
        var permissionsRegex = /<div[^>]+role="listitem"[^>]*>([^<]+).*?<\/div>/;
        var extractPermissionsFromRawGroup = function (rawData) {
            return RegexUtils.findAllOccurrencesByRegex(self.key, "Permissions in Group", permissionsRegex.source, 1, rawData,
                function (value) {
                    return value.trim().unescapeHtmlChars();
                }
            );
        };

        function getApps(page) {

            var isLearnMoreRegex = /<div[^>]+role="listitem"[^>]*>[^<]*<a/;
            var permissionGroupRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^<]+<span[^<]+<img[^>]+src="([^"]+)"[^<]+<\/span>[^<]*<\/div>[^<]*<div[^>]+>([^<]+)<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
            var permissionGroupIconlessRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^<]+<span[^<]+<\/span>[^<]*<\/div>[^<]*<div[^>]+>([^<]+)<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
            var additionalPermissionGroupRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^>]+>[^<]+<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;

            var rawAppsRegex = 'jscontroller[^<]+data-id[^<]+role="listitem".*?role="row".*?role="rowheader".*?role="gridcell".*?<\/div><\/div><\/div><\/div><\/div><\/content>';
            var rawAppsList = RegexUtils.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, page);
            var appIdRegex = '<div class="CMEZce">([^"]+)</div>';
            var iconUrlRegex = '<div class="ShbWnb" aria-hidden="true"><img src="([^"]+)"';


            googleApps = rawAppsList
                .map(function (rawAppData) {
                    var appId = RegexUtils.findValueByRegex(self.key, 'App Id+Name', appIdRegex, 1, rawAppData, true).trim().unescapeHtmlChars();
                    var name = appId;

                    var iconUrl = RegexUtils.findValueByRegex(self.key, 'App Icon', iconUrlRegex, 1, rawAppData, true).unescapeHtmlChars();

                    /* TODO: This condition is probably not even relevant anymore */
                    if ((iconUrl.indexOf("google.com") > -1 && iconUrl.indexOf("android") > -1) ||
                        (iconUrl.indexOf("gstatic.com") > -1 && iconUrl.indexOf("ios_icon") > -1)) {
                        /* Skip apps for Android and iOS. They have custom names so we can only know by the icon. */
                        return false;
                    }

                    var rawPermissionGroups = RegexUtils.findAllOccurrencesByRegex(self.key, "Permission Groups", permissionGroupRegex.source, 0, rawAppData,
                        function (value) {
                            return value.trim().unescapeHtmlChars();
                        }
                    );
                    permissionGroups = [];
                    var permissionIconGroups = rawPermissionGroups.map(function (rawGroup) {
                        var groupData = RegexUtils.findMultiValuesByRegex(self.key, "Permission Group", permissionGroupRegex, [1, 2, 3], rawGroup, true);

                        var group = {
                            iconUrl: groupData[0].trim().unescapeHtmlChars(),
                            name: groupData[1].trim().unescapeHtmlChars()
                        };

                        var rawGroupContent = groupData[2];

                        if (!rawGroupContent.match(isLearnMoreRegex)) {
                            group.permissions = extractPermissionsFromRawGroup(rawGroupContent);
                        } else {
                            group.permissions = [group.name];
                        }

                        return group;
                    });

                    if (permissionIconGroups) {
                        permissionGroups = permissionGroups.concat(permissionIconGroups);
                    }

                    var rawPermissionIconlessGroups = RegexUtils.findAllOccurrencesByRegex(self.key, "Permission Groups", permissionGroupIconlessRegex.source, 0, rawAppData,
                        function (value) {
                            return value.trim().unescapeHtmlChars();
                        });

                    var permissionIconlessGroups = rawPermissionIconlessGroups.map(function (rawGroup) {
                        var groupData = RegexUtils.findMultiValuesByRegex(self.key, "Permission Group", permissionGroupIconlessRegex, [1, 2], rawGroup, true);


                        var group = {
                            name: groupData[0].trim().unescapeHtmlChars()
                        };

                        var rawGroupContent = groupData[1];

                        if (!rawGroupContent.match(isLearnMoreRegex)) {
                            group.permissions = extractPermissionsFromRawGroup(rawGroupContent);
                        } else {
                            group.permissions = [group.name];
                        }

                        return group;
                    });

                    if (permissionIconlessGroups) {
                        permissionGroups = permissionGroups.concat(permissionIconlessGroups);
                    }


                    /* Additional permissions that don't have a group. See example #3 above */
                    var rawAdditionalPermissionsGroup = RegexUtils.findValueByRegex(self.key, "Permission Group", additionalPermissionGroupRegex, 1, rawAppData, false);

                    if (rawAdditionalPermissionsGroup) {
                        var additionalPermissions = extractPermissionsFromRawGroup(rawAdditionalPermissionsGroup);

                        permissionGroups.push({
                            permissions: additionalPermissions
                        });
                    }

                    return {
                        appId: appId,
                        iconUrl: iconUrl,
                        name: name,
                        permissionGroups: permissionGroups
                    };
                });

            callback(googleApps);

        }

        doGetRequest("https://myaccount.google.com/permissions", getApps);
    },

    getDropBoxApps: function (callback) {


        function getApps(content) {
            var matchRes = '(?:"viewerData"\\:)(?=.*"Personal")(?=.*"userId"\\:\\s+(\\w+))(?=.*"personalName"\\:\\s+\\"([^"]+)\\"[,]\\s+)';
            var userId = RegexUtils.findValueByRegex_CleanAndPretty(self.key, 'Account - UserId', matchRes, 1, content, true);

            chrome.cookies.getAll({url: "https://www.dropbox.com"}, function (cookies) {

                var t_cookie = cookies.find(function (cookie) {
                    return cookie.name === "t";
                })

                var host_ss_cookie = cookies.find(function (cookie) {
                    return cookie.name === "__Host-ss";
                })


                var body = "is_xhr=true" + "&" + "t=" + t_cookie.value + "&" +
                    "_subject_uid=" + userId;


                var customData = {
                    custom_headers: [{
                        name: "Origin",
                        value: "https://www.dropbox.com"
                    },
                        {
                            name: "Referer",
                            value: "https://www.dropbox.com/account/connected_apps"
                        },
                        {
                            name: "Accept",
                            value: "application/json, text/javascript, */*; q=0.01"
                        }
                    ],
                    custom_cookies: [{
                        name: "__Host-ss",
                        value: host_ss_cookie?host_ss_cookie.value:""
                    }]
                }


                var headers = [
                    {
                        name: "X-DROPBOX-UID",
                        value: userId
                    },
                    {
                        name: "X-Requested-With",
                        value: "XMLHttpRequest"
                    },
                    {
                        name: "Content-Type",
                        value: "application/x-www-form-urlencoded; charset=UTF-8"
                    },
                    {
                        name: "PlusPrivacyCustomData",
                        value: JSON.stringify(customData)
                    }
                ];

                var data = {
                    _body: body,
                    headers: headers
                }

                doPOSTRequest("https://www.dropbox.com/account/get_linked_apps", data, function (response) {
                    var rawApps = JSON.parse(response);

                    var apps = [];
                    rawApps.user_apps.forEach(function (app) {
                        apps.push({
                            appId: app.id,
                            name: app.name,
                            iconUrl: app.icon_url.replace("size=16x16", "size=32x32"),
                            permission: {
                                title: app.access_type,
                                description: app.access_type_desc
                            }
                        })
                    });
                    callback(apps);
                })
            });
        }

        doGetRequest("https://www.dropbox.com/account/connected_apps", getApps);

    },

    removeSocialApp: function (data, callback) {

        function extractFBToken(content, callback) {
            var dtsgOption1 = 'DTSGInitialData.*?"token"\\s?:\\s?"(.*?)"';
            var dtsgOption2 = 'name=\\\\?"fb_dtsg\\\\?"\\svalue=\\\\?"(.*?)\\\\?"';
            var dtsgOption3 = 'dtsg"\\s?:\\s?\{"token"\\s?:\\s?"(.*?)';

            var fb_dtsg = RegexUtils.findValueByRegex(self.key, 'fb_dtsg', dtsgOption1, 1, content, false);
            if (!fb_dtsg)
                fb_dtsg = RegexUtils.findValueByRegex(self.key, 'fb_dtsg', dtsgOption2, 1, content, false);
            if (!fb_dtsg)
                fb_dtsg = RegexUtils.findValueByRegex(self.key, 'fb_dtsg', dtsgOption3, 1, content, true);

            var userIdOption1 = '"USER_ID" ?: ?"(.*?)"';
            var userId = RegexUtils.findValueByRegex(self.key, 'USER_ID', userIdOption1, 1, content, true);

            var data = {
                'fb_dtsg': fb_dtsg,
                'userId': userId
            };

            callback(data);
        }

        function extractTwitterToken(content, callback) {
            var authTokenRegex = '<input type="hidden" value="(.*?)" name="authenticity_token"';
            var authenticity_token = RegexUtils.findValueByRegex(self.key, 'authenticity_token', authTokenRegex, 1, content, true);
            callback({authenticity_token: authenticity_token});
        }

        function extractLinkedinToken(content, callback) {
            var tokenRegex = 'name="csrfToken" value="(.*?)"';
            var token = RegexUtils.findValueByRegex(self.key, 'authenticity_token', tokenRegex, 1, content, true);
            callback({csrfToken: token});
        }


        function extractGoogleTokens(content, appId, callback) {
            var now = new Date();
            var paramsOption1 = "\\\[.*,\\\'([\\\w-]+:[\\\w\\\d]+)\\\',.*\\\]\\\s.*(?=(\\\,\\\s*)+\\\].*window\\\.IJ_valuesCb \\\&\\\&)";
            var match = RegexUtils.findMultiValuesByRegex(self.key, 'Revoke Params', paramsOption1, [1], content, true);
            var sidRegex = 'WIZ_global_data.+{[^}]*?:\\\"([-\\\d]+?)\\\"[^:\\\"]+';
            var sid = RegexUtils.findValueByRegex(self.key, 'f.sid', sidRegex, 1, content, true);
            var at = match[0];


            var req_id = 3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 1E5;
            var fReqRegex = 'data-name="' + appId + '".*?data-handle="(.*?)"';
            var f_req = RegexUtils.findValueByRegex(self.key, 'f_req', fReqRegex, 1, content, true);


            callback({
                req_id: req_id,
                f_req: f_req,
                at: at,
                f_sid: sid
            });
        }

        function extractDropBoxTokens(content, callback) {
            var tokens = {};
            var matchRes = '(?:"viewerData"\\:)(?=.*"Personal")(?=.*"userId"\\:\\s+(\\w+))(?=.*"personalName"\\:\\s+\\"([^"]+)\\"[,]\\s+)';
            tokens.userId = RegexUtils.findValueByRegex_CleanAndPretty(self.key, 'Account - UserId', matchRes, 1, content, true);
            chrome.cookies.get({url: "https://www.dropbox.com", name: "t"}, function (cookie) {
                tokens['t'] = cookie.value;
                callback(tokens);
            });
        }

        function removeFbApp(appId) {

            doGetRequest("https://www.facebook.com/settings?tab=applications", function (content) {
                extractFBToken(content, function (data) {

                    var _body = "_asyncDialog=1&__user=" + data['userId'] + "&__a=1&__req=o&__rev=1562552&app_id=" + appId
                        + "&legacy=false&dialog=true&confirmed=true&ban_user=0&fb_dtsg=" + data['fb_dtsg'];

                    doPOSTRequest("https://www.facebook.com/ajax/settings/apps/delete_app.php?app_id=" + encodeURIComponent(appId) + "&legacy=false&dialog=true", _body, function (response) {
                        callback();
                    })

                });
            });
        }

        function removeTwitterApp(appId) {
            doTwitterAppsRequest("https://twitter.com/settings/sessions", function (content) {
                extractTwitterToken(content, function (data) {
                    var _body = "token=" + appId + "&" + encodeURIComponent("scribeContext[component]")
                        + "=oauth_app&twttr=true&authenticity_token=" + data.authenticity_token;
                    doPOSTRequest("https://twitter.com/oauth/revoke", _body, function (response) {
                        callback();
                    })
                });
            })
        }

        function removeLinkedinApp(appId) {
            doGetRequest("https://www.linkedin.com/psettings/permitted-services", function (content) {
                extractLinkedinToken(content, function (data) {
                    var _body = "id=" + appId + "&" + "type=OPEN_API" + "&" + "csrfToken=" + data.csrfToken;
                    doPOSTRequest("https://www.linkedin.com/psettings/permitted-services/remove", _body, callback);
                });
            });
        }

        function removeGoogleApp(appId) {

            doGetRequest("https://myaccount.google.com/permissions?hl=en", function (content) {
                extractGoogleTokens(content, appId, function (tokens) {
                    var body = "at=" + tokens['at'];
                    body += "&f.req=" + '["af.maf",[["af.add",143439692,[{"143439692":["' + tokens['f_req'] + '"]}]]]]';
                    var url = 'https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=143439692';
                    if (tokens['f_sid']) {
                        url += '&f.sid=' + tokens['f_sid'];
                    }
                    url += '&hl=en&_reqid=' + tokens['req_id'] + '&rt=c';
                    doPOSTRequest(url, body, callback);
                });
            });
        }

        function removeDropoxApp(appId) {
            doGetRequest("https://www.dropbox.com/account/connected_apps", function (content) {
                extractDropBoxTokens(content, function (tokens) {
                    var body = {"app_id": appId, "keep_sandbox_files": true};
                    var url = "https://www.dropbox.com/2/security_settings/uninstall_app";
                    var userId = tokens['userId'];


                    chrome.cookies.getAll({url: "https://www.dropbox.com"}, function (cookies) {
                        var host_ss_cookie = cookies.find(function (cookie) {
                            return cookie.name === "__Host-ss";
                        });

                        var customData = {
                            custom_headers: [{
                                name: "Origin",
                                value: "https://www.dropbox.com"
                            },
                                {
                                    name: "Referer",
                                    value: "https://www.dropbox.com/account/connected_apps"
                                },
                                {
                                    name: "Accept",
                                    value: "application/json, text/javascript, */*; q=0.01"
                                }
                            ],
                            custom_cookies: [{
                                name: "__Host-ss",
                                value: host_ss_cookie?host_ss_cookie.value:""
                            }]
                        };

                        var headers = [
                            {
                                name: "X-DROPBOX-UID",
                                value: userId
                            },
                            {
                                name: "X-Requested-With",
                                value: "XMLHttpRequest"
                            },
                            {
                                name: "content-type",
                                value: "application/json"
                            },
                            {
                                name: "x-csrf-token",
                                value: tokens['t']
                            },
                            {
                                name: "PlusPrivacyCustomData",
                                value: JSON.stringify(customData)
                            }
                        ];

                        var data = {
                            _body: JSON.stringify(body),
                            headers: headers
                        };

                        doPOSTRequest(url, data, callback);
                    });
                })
            });
        }

        switch (data.sn) {
            case "facebook" :
                removeFbApp(data.appId);
                break;
            case "twitter" :
                removeTwitterApp(data.appId);
                break;
            case "linkedin":
                removeLinkedinApp(data.appId);
                break;
            case "google":
                removeGoogleApp(data.appId);
                break;
            case "dropbox":
                removeDropoxApp(data.appId);
                break;
        }

    },

    getGoogleData: function (callback) {
        doGetRequest("https://myaccount.google.com/permissions?hl=en", getData);
        function getData(pageData) {
            var match;
            var sid;

            paramsOption1 = "\\\[.*,\\\'([\\\w-]+:[\\\w\\\d]+)\\\',.*\\\]\\\s.*(?=(\\\,\\\s*)+\\\].*window\\\.IJ_valuesCb \\\&\\\&)";
            match = RegexUtils.findMultiValuesByRegex(self.key, 'Revoke Params', paramsOption1, [1], pageData, true);
            var sidRegex = 'WIZ_global_data.+{[^}]*?:\\\"([-\\\d]+?)\\\"[^:\\\"]+';
            sid = RegexUtils.findValueByRegex(self.key, 'f.sid', sidRegex, 1, pageData, true);

            var at = match[0];


            var data = {
                'at': at,
                'f_sid': sid
            };
            callback(data);
        }
    },


    getMyLoggedinEmail: function(socialNetwork, success_callback, error_callback){
        socialNetworkService.getSocialNetworkEmailHandler(socialNetwork, function(data){

            var getDataPromise = function(url){
                return new Promise(function(resolve, reject){

                    switch (socialNetwork) {
                        case "twitter":
                            doTwitterAppsRequest(url,resolve);

                            break;
                        default:
                            doGetRequest(url, resolve);
                            break;
                    }
                })
            };

            var sequence = Promise.resolve();

            sequence = sequence.then(function(){
                return getDataPromise(data.url);
            }).then(function(content){
                var regex = new RegExp(data.regex);
                var match = regex.exec(content);
                if(match && match[1]){
                    success_callback({type:data.type, account: match[1]});
                }
                else{
                    error_callback();
                }

            });

        })
    }

};

bus.registerService(websiteService);
