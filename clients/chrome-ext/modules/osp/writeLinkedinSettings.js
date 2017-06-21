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
            doGET(settings.page, function (response) {

                var headers = extractHeaders(response);

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
                    console.log(data);
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
                            }

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
                                  console.log("Sunt in 500");
                              }
                            },
                            error: function (a, b, c) {
                                console.log(a, b, c);
                                reject(b);
                            },
                            complete: function (request, status) {
                                console.log("Request completed...");
                            }

                        });
                    }
                });

            })
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


/*function doGET(page, callback) {

    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", page, true);
    try{
        xmlHttp.send(null);
    }
    catch (e){
        console.log(e);

        setTimeout(function(){
            doGET(page, callback);
        },1000);
    }

}
*/
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
    return data;

}
