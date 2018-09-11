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

var privacySettings = [];
var port = chrome.runtime.connect({name: "applyLinkedinSettings"});
var extractedData = {};
port.postMessage({action: "waitingLinkedinCommand", data: {status:"waitingLinkedinCommand"}});

port.onMessage.addListener(function (msg) {
    if (msg.command == "applySettings") {
        privacySettings = msg.settings;
        secureAccount(function () {
            port.postMessage({action: "waitingLinkedinCommand", data:{status:"settings_applied"}});
        });
    }
});

function postToLinkedIn(settings, item, total) {
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
                    resolve(b);
                },
                complete: function (request, status) {
                    console.log("Request completed...");
                },
                timeout:3000

            });
        }
        else {

            var formData = new FormData();
            for (var p in headers) {
                formData.append(p, headers[p]);
            }

            for (var prop in data) {
                formData.append(prop, data[prop]);
            }
            $.ajax({
                type: "POST",
                url: settings.url,
                data: formData,
                contentType: false,
                processData: false,

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
                    resolve(b);
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
            return postToLinkedIn(settings, index, total);
        }).then(function (result) {
            port.postMessage({action: "waitingLinkedinCommand", data:{status:"progress", progress:(index+1)}});
        }).catch(function (err) {
            console.log(err)
        });
    });

    sequence = sequence.then(function (result) {
        FeedbackProgress.clearFeedback("LinkedIn is now secured!");
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
    var csrfToken = /<meta name="lnkd-track-error" content\=\"\/lite\/ua\/error\?csrfToken=(ajax%3A[0-9]*)\">/;
    var data = {};
    var match;

    if ((match = csrfToken.exec(content)) !== null) {
        if (match.index === csrfToken.lastIndex) {
            csrfToken.lastIndex++;
        }
    }
    data['csrfToken'] = decodeURIComponent(match[1]);
    extractedData = data;
    return data;
}
