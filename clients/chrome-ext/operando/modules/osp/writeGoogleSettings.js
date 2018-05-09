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
            port.disconnect();
        });
    }
});

function postToGoogle(settings, item, total) {
    return new Promise(function (resolve, reject) {
        if (settings.page) {
            FeedbackProgress.sendFeedback(settings.name, item, total);

            if(settings.method_type === "GET"){
                sendGetRequest(settings, extractedData,resolve,reject);
            }
            else{
                sendPostRequest(settings,extractedData,resolve,reject);
            }

        }
    });
}


function sendGetRequest(settings, headers, resolve, reject){

    var getSIGValue = function(callback){
        doGET(settings.page,function(htmlContent){
            var sig_regex = /<input value="(.*?)" name="sig" type="hidden">/g;
            var m;
            if((m = sig_regex.exec(htmlContent)) !== null) {
                if (m.index === sig_regex.lastIndex) {
                    sig_regex.lastIndex++;
                }
            }
            if(m && m[1]){
                callback(m[1]);
            }
            else{
                reject("no sig found");
            }
        })
    };

    getSIGValue(function(sigValue){
        var url = settings.url.replace("{SIG}",sigValue);
        doGET(url, resolve);
    })



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

            var _body ="";



                Object.keys(settings.data).forEach(function(item, index){
                    if(index !== 0){
                        _body+="&";
                    }
                    _body+=item+"="+settings.data[item];
                });

            _body+="&at="+googleParams['at'];

            var now = new Date();
            var req_id =  3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 1E5;
            settings.url = settings.url.replace("{SID}",googleParams['f_sid']);
            settings.url = settings.url.replace("{REQID}",req_id);

            $.ajax({
                type: "POST",
                url: settings.url,
                data: _body,
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
                    request.setRequestHeader("X-Alt-Referer", settings.page);
                },
                success: function (result) {
                        resolve(result);
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
                },
                timeout:1000

            });

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
        FeedbackProgress.clearFeedback();

        var modal = $('<div class="modal"></div>');
        var modal_content = $('<div class="modal-content"></div>');

        var header = $('<div class="modal-header"><h2>PlusPrivacy Wizard</h2></header>');


        var closeModal = function(){
            $(modal_content).animate({
                opacity: 0, // animate slideUp
                marginTop: '600px'
            }, 'fast', 'linear', function() {
                $(modal).remove();
            });
        };

        modal_content.append(header);

        var modal_body = $('<div class="modal-body"><p>PlusPrivacy needs you to do some clicks to optimize your Google privacy settings</p></div>');
        var letsDoItBtn = $("<button class='orange'>OK, let's do it</button>");
        letsDoItBtn.click(closeModal);
        modal_body.append(letsDoItBtn);
        modal_content.append(modal_body);


        var modal_footer = $('<div class="modal-footer"></div>');
        modal_content.append(modal_footer);

        modal.append(modal_content);
        $("body").append(modal);

        $(modal).css("display", "block");

        var checkModalClick = function(event){
            if (event.target == modal.get(0)) {

                closeModal();
                window.removeEventListener("click", checkModalClick);
            }
        };
        window.addEventListener("click",checkModalClick);


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