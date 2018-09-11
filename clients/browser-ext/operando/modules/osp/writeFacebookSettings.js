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

var fbdata = window.FACEBOOK_PARAMS;
fbdata.__req = parseInt(fbdata.__req, 36);
var privacySettings = [];
var extractedData = {};
var port = chrome.runtime.connect({name: "applyFacebookSettings"});
port.postMessage({action: "waitingFacebookCommand", data: {status:"waitingFacebookCommand"}});

port.onMessage.addListener(function (msg) {
    if (msg.command == "applySettings") {
        privacySettings = msg.settings;
        secureAccount(function(){
            port.postMessage({action: "waitingFacebookCommand", data:{status:"settings_applied"}});
            port.disconnect();
        });
    }
});


function postToFacebook(settings, item, total) {

    return new Promise(function (resolve, reject) {

        if (settings.page) {
            FeedbackProgress.sendFeedback(settings.name, item, total);

            if(Object.keys(extractedData).length === 0){
                doGET(settings.page, function (response) {
                    extractHeaders(response, function (response) {
                        sendPostRequest(settings, response, resolve,reject);
                    })
                })
            }
            else{
                sendPostRequest(settings, extractedData, resolve,reject);
            }
        }
    });
}

function sendPostRequest(settings, additionalData, resolve, reject){
    var data = additionalData;

    for(var prop in settings.data){
        data[prop] = settings.data[prop];
    }

    $.ajax({
        type: "POST",
        url: settings.url,
        data: data,
        contentType: "multipart/form-data",
        processData: true,
        dataType:"text",
        beforeSend: function (request) {

            if (settings.headers) {
                for (var i = 0; i < settings.headers.length; i++) {
                    var header = settings.headers[i];
                    request.setRequestHeader(header.name, header.value);
                }
            }
            request.setRequestHeader("accept", "*/*");
            request.setRequestHeader("accept-language", "en-US,en;q=0.8");
            request.setRequestHeader("content-type", "application/x-www-form-urlencoded");
            request.setRequestHeader("X-Alt-Referer", settings.page);

        },
        success: function (result) {
            resolve(result);
        },
        error: function (a, b, c) {
            console.log(a,b,c);
            resolve(b);
        },
        complete: function (request, status) {
            console.log("Request completed...");
        },
        timeout:3000

    });
}

function secureAccount(callback) {
    var total = privacySettings.length;
    var sequence = Promise.resolve();
    privacySettings.forEach(function (settings, index) {
        sequence = sequence.then(function () {
            return postToFacebook(settings, index, total);
        }).then(function (result) {
            port.postMessage({action: "waitingFacebookCommand", data:{status:"progress", progress:(index+1)}});
        }).catch(function (err) {
            if(err == "timeout"){
                //go to next setting
                port.postMessage({action: "waitingFacebookCommand", data:{status:"progress", progress:(index+1)}});
            }
        });
    });

    sequence = sequence.then(function (result) {
        FeedbackProgress.clearFeedback("Facebook is now secured!");
    });

    sequence = sequence.then(function (result) {
        callback();
    });

}


function doGET(page, callback) {

    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    };
    xmlHttp.open("GET", page, true);
    xmlHttp.send(null);
}


function extractHeaders(content, callback) {
    var csrfToken = /\[\"DTSGInitialData\",\[\],\{"token":"([a-zA-Z0-9]*)"\},[0-9]*\]/;
    var revisionReg = /\{\"revision\":([0-9]*),/;
    var userIdReg = /\{\"USER_ID\":\"([0-9]*)\"/;


    var match;
    var data = {};

    if ((match = csrfToken.exec(content)) !== null) {
        if (match.index === csrfToken.lastIndex) {
            csrfToken.lastIndex++;
        }
    }

    if(match && match[1]){
        data['fb_dtsg'] = match[1];

        /**
         * Taken from Facebook
         * @type {string}
         */

        var x = '';
        for (var y = 0; y < data['fb_dtsg'].length; y++) {
            x += data['fb_dtsg'].charCodeAt(y);
        }
        //data["ttstamp"] = '2' + x;
    }
    else{
        data["fb_dtsg"] = fbdata.fb_dtsg;
        //data["ttstamp"] = fbdata.ttstamp;
    }

    //__rev
    if ((match = revisionReg.exec(content)) !== null) {
        if (match.index === revisionReg.lastIndex) {
            revisionReg.lastIndex++;
        }
    }

    if(match && match[1]){
        data['__rev'] = match[1];
    }
    //__user
    if ((match = userIdReg.exec(content)) !== null) {
        if (match.index === userIdReg.lastIndex) {
            userIdReg.lastIndex++;
        }
    }

    if(match && match[1]){
        data['__user'] = match[1];
    }
    data['__a']=1;
    data['__dyn'] = fbdata.__dyn;
    data['__req'] = (++ fbdata.__req).toString(36);
    data['jazoest'] = fbdata.jazoest;
    data['__spin_r'] = fbdata.__spin_r;
    data['__spin_b'] = fbdata.__spin_b;
    data['__spin_t'] = fbdata.__spin_t;
    data['__be'] = fbdata.__be;
    data['__pc'] = fbdata.__pc;
    data['__rev'] = fbdata.__rev;
    extractedData = data;
    callback(data);
}