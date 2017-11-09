/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

console.log(window.GOOGLE_PARAMS);

var googleParams = window.GOOGLE_PARAMS;

var privacySettings = [];
var port = chrome.runtime.connect({name: "applyGoogleSettings"});
var extractedData = {};
port.postMessage({action: "waitingGoogleCommand", data: {status:"waitingGoogleCommand"}});

port.onMessage.addListener(function (msg) {
    if (msg.command == "applySettings") {
        privacySettings = msg.settings;
        secureAccount(function () {
            port.postMessage({action: "waitingGoogleCommand", data:{status:"settings_applied"}});
        });
    }
});

function postToGoogle(settings, item, total) {
    return new Promise(function (resolve, reject) {
        if (settings.page) {
            FeedbackProgress.sendFeedback(settings.name, item, total);

            if(Object.keys(extractedData).length === 0){
                doGET(settings.page, function (response) {
                    var additionalData = extractHeaders(response);
                    sendPostRequest(settings,additionalData,resolve,reject);
                });
            }
            else{
                sendPostRequest(settings,extractedData,resolve,reject);
            }
        }
    });
}

function sendPostRequest(settings, headers, resolve, reject){

    var data = {};
    chrome.runtime.sendMessage({
        message: "getCookies",
        url: settings.page
    }, function (response) {
        var cookies = "";
        for (var i = 0; i < response.length; i++) {
            cookies += response[i].name + "=" + response[i].value + "; ";
        }

        for (var prop in settings.data) {
            data[prop] = settings.data[prop];
        }


        for (var param in settings.params) {
            if (settings.params[param].type && settings.params[param].type === "dynamic") {
                if (headers[param]) {
                    settings.url = settings.url.replace("{" + settings.params[param].placeholder + "}", headers[param]);
                }
            }
        }
        if (settings.type == "application/json") {
            $.ajax({
                type: "POST",
                url: settings.url,
                data: JSON.stringify(data),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                beforeSend: function (request) {
                    if (settings.headers) {
                        for (var i = 0; i < settings.headers.length; i++) {
                            var header = settings.headers[i];
                            request.setRequestHeader(header.name, header.value);
                        }
                    }

                    request.setRequestHeader("accept", "application/json, text/javascript, */*; q=0.01");
                    request.setRequestHeader("accept-language", "en-US,en;q=0.8");
                    request.setRequestHeader("X-Alt-Referer", settings.page);

                },
                success: function (result) {
                    resolve(result);
                },
                error: function (a, b, c) {
                    console.log(a, b, c);
                    reject(b);
                },
                complete: function (request, status) {
                    console.log("Request completed...");
                },
                timeout:3000

            });
        }
        else {

            console.log(settings);
            var _body ="";



                Object.keys(settings.data).forEach(function(item, index){
                    if(index !== 0){
                        _body+="&";
                    }
                    _body+=item+"="+settings.data[item];
                });

            _body+="&at="+googleParams['at'];
            console.log(_body);

            var now = new Date();
            var req_id =  3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 1E5;
            settings.url = settings.url.replace("{SID}",googleParams['f_sid']);
            settings.url = settings.url.replace("{REQID}",req_id);

            $.ajax({
                type: "POST",
                url: settings.url,
                data: _body,

                beforeSend: function (request) {

                    if (settings.headers) {
                        for (var i = 0; i < settings.headers.length; i++) {
                            var header = settings.headers[i];
                            request.setRequestHeader(header.name, header.value);
                        }
                    }
                    request.setRequestHeader("accept", "*/*");
                    request.setRequestHeader("accept-language", "en-US,en;q=0.8");
                    request.setRequestHeader("X-Alt-Referer", settings.page);
                },
                success: function (result) {
                    setTimeout(function(){
                        resolve(result);
                    },0);
                },
                statusCode:{
                    500: function(){
                        console.log("500 error");
                        reject();
                    }
                },
                error: function (a, b, c) {
                    console.log(a, b, c);
                    reject(b);
                },
                complete: function (request, status) {
                    console.log("Request completed...");
                },
                timeout:3000

            });
        }
    });
}

function secureAccount(callback) {
    var total = privacySettings.length;
    var sequence = Promise.resolve();
    privacySettings.forEach(function (settings, index) {
        sequence = sequence.then(function () {
            return postToGoogle(settings, index, total);
        }).then(function (result) {
            port.postMessage({action: "waitingGoogleCommand", data:{status:"progress", progress:(index+1)}});
        }).catch(function (err) {
            console.log(err)
        });
    });

    sequence = sequence.then(function (result) {
        FeedbackProgress.clearFeedback("Google is now secured!");
    });

    sequence = sequence.then(function (result) {
        callback();
    });


}

function doGET(page, callback){
    $.ajax({
        url: page,
        success: callback,
        dataType: 'html'
    });
}


function extractHeaders(content) {

    var data = {};
    return data;
}


function fireEvent(node, eventName) {
    // Make sure we use the ownerDocument from the provided node to avoid cross-window problems
    var doc;
    if (node.ownerDocument) {
        doc = node.ownerDocument;
    } else if (node.nodeType == 9){
        // the node may be the document itself, nodeType 9 = DOCUMENT_NODE
        doc = node;
    } else {
        throw new Error("Invalid node passed to fireEvent: " + node.id);
    }

    console.log(node.dispatchEvent);
    if (node.dispatchEvent) {
        // Gecko-style approach (now the standard) takes more work
        var eventClass = "";

        // Different events have different event classes.
        // If this switch statement can't map an eventName to an eventClass,
        // the event firing is going to fail.
        switch (eventName) {
            case "click": // Dispatching of 'click' appears to not work correctly in Safari. Use 'mousedown' or 'mouseup' instead.
            case "mousedown":
            case "mouseup":
                eventClass = "MouseEvents";
                break;

            case "focus":
            case "change":
            case "blur":
            case "select":
                eventClass = "HTMLEvents";
                break;

            default:
                throw "fireEvent: Couldn't find an event class for event '" + eventName + "'.";
                break;
        }
        var event = doc.createEvent(eventClass);

        var bubbles = eventName == "change" ? false : true;
        event.initEvent(eventName, bubbles, true); // All events created as bubbling and cancelable.

        event.synthetic = true; // allow detection of synthetic events
        node.dispatchEvent(event, true);
    } else  if (node.fireEvent) {
        // IE-old school style
        var event = doc.createEventObject();
        event.synthetic = true; // allow detection of synthetic events
        node.fireEvent("on" + eventName, event);
    }
};