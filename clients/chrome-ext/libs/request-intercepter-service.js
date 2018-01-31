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


var interceptors = {
    "facebook":{
        code: function(message, callback){
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
            }
            return interceptorCallback;
        },
        urlPattern:["*://www.facebook.com/*"]
    },
    "twitter":{
        code:function(message, callback){

            var interceptorCallback = function(request){
                var headers = [];

                var copyHeadersIfAvailable = function(requestHeader){
                    if(message.headers.indexOf(requestHeader['name'])>-1){
                        headers.push({
                            name:requestHeader.name,
                            value:requestHeader.value
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

        },
        urlPattern:["*://api.twitter.com/*"]
    },
    "dropbox": {

        code: function (message, callback) {
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
        },
        urlPattern: ["*://www.dropbox.com/*"]
    }

};


var requestInterceptorService = exports.requestInterceptor = {

interceptSingleRequest:function(target, message, callback){

    if(interceptors[target]){
        var interceptorCallback = interceptors[target].code(message, callback);
        var patterns = interceptors[target].urlPattern;
        webRequest.onBeforeRequest.addListener(interceptorCallback, {urls:patterns}, ["blocking", "requestBody"]);
    }
},

interceptHeadersBeforeRequest:function(target, message, callback){
    if(interceptors[target]){
        var interceptorCallback = interceptors[target].code(message, callback);
        var patterns = interceptors[target].urlPattern;
        webRequest.onBeforeSendHeaders.addListener(interceptorCallback, {urls:patterns}, ["blocking", "requestHeaders"]);
    }
}

};

bus.registerService(requestInterceptorService);
