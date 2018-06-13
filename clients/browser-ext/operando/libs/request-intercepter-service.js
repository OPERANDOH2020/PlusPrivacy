/*
 * Copyright (c) 2018 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var bus = require("bus-service").bus;

var interceptorPools = require("Interceptor").InterceptorPools;

var facebookFirstPOSTInterceptor = function(message, callback){
    var interceptorCallback = function (request) {
        if (request.method == "POST") {
            if (message.template) {
                if (request.url.indexOf("facebook.com/ajax/bz") != -1) {
                    var requestBody = request.requestBody;
                    if (requestBody.formData) {
                        var formData = requestBody.formData;
                        for (var prop in message.template) {
                            if (formData[prop]) {
                                if (formData[prop] instanceof Array) {
                                    message.template[prop] = formData[prop][0];
                                }
                                else {
                                    message.template[prop] = formData[prop];
                                }
                            }
                        }
                    }
                    else if (requestBody.raw) {
                        var rawRequest = String.fromCharCode.apply(null, new Uint8Array(requestBody.raw[0].bytes));
                        var requestArray = rawRequest.split("&");
                        var formDataObjects = {};
                        requestArray.forEach(function (pair) {
                            var splitedPair = pair.split("=");
                            formDataObjects[splitedPair[0]] = splitedPair[1];
                        });
                        for (var prop in message.template) {
                            if (formDataObjects[prop]) {
                                message.template[prop] = decodeURIComponent(formDataObjects[prop]);
                            }
                        }
                    }

                    webRequest.onBeforeRequest.removeListener(interceptorCallback);
                    callback({template: message.template});
                }
            }
        }
    };
    return interceptorCallback;
};

var twitterAppsRequestInterceptor = function(message, callback){

    var twiterAppsInterceptorCallback = function (request) {

        var headers = request.requestHeaders;

        var getTwitterAppsHeader = headers.find(function(header){
            return header.name.toLowerCase() === "get-twitter-apps";
        });

        if(getTwitterAppsHeader){
            var insecureHeader = headers.find(function(header){
                return header.name.toLowerCase() === "upgrade-insecure-requests";
            });

            if(!insecureHeader){
                request.requestHeaders.push({name:"upgrade-insecure-requests", value:"1"});
                request.requestHeaders.push({name:"referer", value:"https://twitter.com/"});
                request.requestHeaders.push({name:"cache-control", value:"max-age=0"});
            }

            var cookieHeader = headers.find(function(header){
                return header.name.toLowerCase() === "cookie";
            });

            if(!cookieHeader){
                cookieHeader = {
                    name:"cookie"
                }
            }
            else{
                cookieHeader.value +="; csrf_same_site=1";
            }

            setTimeout(function () {
                webRequest.onBeforeSendHeaders.removeListener(twiterAppsInterceptorCallback)
            }, 1000);


            for (var i = 0; i < request.requestHeaders.length; ++i) {
                var header = request.requestHeaders[i];
                if (header.name === "get-twitter-apps") {
                    request.requestHeaders.splice(i, 1);
                    break;
                }
            }
        }

       return {requestHeaders: request.requestHeaders};

    };
    return twiterAppsInterceptorCallback;
}

var twitterHeadersRequestInterceptor = function (message, callback) {

    var interceptorCallback = function (request) {
        var headers = [];

        var copyHeadersIfAvailable = function (requestHeader) {
            if (message.headers.indexOf(requestHeader['name']) > -1) {
                headers.push({
                    name: requestHeader.name,
                    value: requestHeader.value
                })
            }
        };

        if (request.method == "POST") {
            if (request.url.indexOf("api.twitter.com/1.1/jot/client_event.json") != -1) {
                var requestHeaders = request.requestHeaders;
                requestHeaders.forEach(copyHeadersIfAvailable);

                callback({headers: headers});
                webRequest.onBeforeSendHeaders.removeListener(interceptorCallback);
            }
        }
    };
    return interceptorCallback;

};

var dropboxHeadersRequestInterceptor = function (message, callback) {
    var interceptorCallback = function (details) {
        var requestedHeaders = details.requestHeaders;

        var plusPrivacyCustomData;
        var plusPrivacyCustomDataIndex;
        requestedHeaders.some(function (rHeader, index) {
            if (rHeader.name === "PlusPrivacyCustomData") {
                plusPrivacyCustomData = rHeader;
                plusPrivacyCustomDataIndex = index;
                return true;
            }
            return false;
        });

        if (plusPrivacyCustomData) {
            var cookieHeader = requestedHeaders.find(function (rHeader) {
                return rHeader.name.toLowerCase() === "cookie";
            });

            var customData = JSON.parse(plusPrivacyCustomData.value);
            if (customData.custom_headers) {
                var customHeaders = customData.custom_headers;
                if (customHeaders instanceof Array) {
                    customHeaders.forEach(function (header) {
                        details.requestHeaders.push(header);
                    })
                }
            }

            if (customData.custom_cookies) {
                var customCookies = customData.custom_cookies;
                if (customCookies instanceof Array) {
                    customCookies.forEach(function (cookie) {
                        cookieHeader.value += "; " + cookie.name + "=" + cookie.value;
                    })
                }
            }

            if (plusPrivacyCustomDataIndex) {
                details.requestHeaders.splice(plusPrivacyCustomDataIndex, 1);
            }
        }

        return {requestHeaders: details.requestHeaders};
    };
    return interceptorCallback;
};

var removeXFrameOptionsHeaders = function(message, callback){
    var HEADERS_TO_STRIP_LOWERCASE = [
        'content-security-policy',
        'x-frame-options'
    ];
    return function(details){
        return {
            responseHeaders: details.responseHeaders.filter(function (header) {
                return HEADERS_TO_STRIP_LOWERCASE.indexOf(header.name.toLowerCase()) < 0;
            })
        };
    }
};

var changeReferer = function(message, callback){
    return function (details) {
        var referer = "";
        for (var i = 0; i < details.requestHeaders.length; ++i) {
            var header = details.requestHeaders[i];
            if (header.name === "X-Alt-Referer") {
                referer = header.value;
                details.requestHeaders.splice(i, 1);
                break;
            }
        }

        if (referer !== "") {
            for (var i = 0; i < details.requestHeaders.length; ++i) {
                var header = details.requestHeaders[i];
                if (header.name === "Referer") {
                    details.requestHeaders[i].value = referer;
                    break;
                }
            }
        }

    }
};

var facebookOriginHeader = function(message, callback){
    return function (details) {
        if (details['url'].indexOf("https://www.facebook.com/ajax/settings/apps/delete_app.php") >= 0) {

            for (var i = 0; i < details.requestHeaders.length; ++i) {
                if (details.requestHeaders[i].name === "Origin") {
                    details.requestHeaders[i].value = "https://www.facebook.com";
                    break;
                }
            }
            details.requestHeaders.push({
                name: "referer",
                value: "https://www.facebook.com/settings?tab=applications"
            });
        }

        return {requestHeaders: details.requestHeaders};
    }
};

interceptorPools.addBodyRequestInterceptor("facebook", ["*://www.facebook.com/*"],facebookFirstPOSTInterceptor);
interceptorPools.addHeadersRequestsPoolInterceptor("twitter",["*://api.twitter.com/*"],twitterHeadersRequestInterceptor);
interceptorPools.addHeadersRequestsPoolInterceptor("twitter-apps",["*://twitter.com/*"],twitterAppsRequestInterceptor);
interceptorPools.addHeadersRequestsPoolInterceptor("dropbox",["*://www.dropbox.com/*"],dropboxHeadersRequestInterceptor);
interceptorPools.addHeadersRequestsPoolInterceptor("change-referer",["<all_urls>"], changeReferer);
interceptorPools.addHeadersRequestsPoolInterceptor("delete-fb-app",["<all_urls>"], facebookOriginHeader);
interceptorPools.addHeadersResponsesPoolInterceptor("all-header-responses",["<all_urls>"], removeXFrameOptionsHeaders);


var requestInterceptorService = exports.requestInterceptor = {

    interceptSingleRequest: function (target, message, callback) {
        var interceptorsCallback = interceptorPools.getBodyRequestInterceptor(target);
        interceptorsCallback.forEach(function (interceptor) {
            webRequest.onBeforeRequest.addListener(interceptor.callback(message, callback), {urls: interceptor.pattern}, ["blocking", "requestBody"]);
        });
    },

    interceptHeadersBeforeRequest: function (target, message, callback) {
        var interceptorsCallback = interceptorPools.getHeadersRequestInterceptor(target);
        interceptorsCallback.forEach(function (interceptor) {
            webRequest.onBeforeSendHeaders.addListener(interceptor.callback(message,callback), {urls: interceptor.pattern}, ["blocking", "requestHeaders"]);
        });
    },

    interceptHeadersResponse: function (target, message, callback) {
        var interceptorsCallback = interceptorPools.getHeadersResponseInterceptor(target);
        interceptorsCallback.forEach(function (interceptor) {
            webRequest.onHeadersReceived.addListener(interceptor.callback(message,callback), {urls: interceptor.pattern}, ["blocking", "responseHeaders"]);
        });
    }
};

bus.registerService(requestInterceptorService);
