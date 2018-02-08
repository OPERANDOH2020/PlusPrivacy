$(document).ready(function(){
    var headers = window.TWITTER_HEADERS;
    var privacySettings = [];
    var port = chrome.runtime.connect({name: "applyTwitterSettings"});
    port.postMessage({action: "waitingTwitterCommand", data: {status:"waitingTwitterCommand"}});

    port.onMessage.addListener(function (msg) {
        if (msg.command == "applySettings") {
            privacySettings = msg.settings;
           secureAccount(function () {
                port.postMessage({action: "waitingTwitterCommand", data:{status:"progress", progress:(privacySettings.length)}});
                port.postMessage({action: "waitingTwitterCommand", data:{status:"settings_applied"}});
            });
        }
    });

    function secureAccount(callback){

            var endPoints = privacySettings.reduce(function(pv, cv){
                if(pv.indexOf(cv.url) === -1){
                    pv.push(cv.url);
                }
                return pv;
            },[]);

        var sequence = Promise.resolve();

        endPoints.forEach(function(endpoint){
            var formData = {};
            var dataType = "multipart/form-data";
            if(endpoint === "https://api.twitter.com/1.1/account/personalization/p13n_preferences.json"){
                dataType = "application/json";
            }else{
                 formData = {
                    include_mention_filter:true,
                    include_ranked_timeline:true
                };
            }

            var formSettings = privacySettings.filter(function(setting){
                return setting.url === endpoint;
            });


            formSettings.forEach(function (setting) {
                for (var key in setting["data"]) {
                    formData[key] = setting["data"][key];
                }
            });
            sequence.then(function(){
                return customSubmit(endpoint, formData, dataType);
            });
        });

        sequence.then(function(){
            port.postMessage({action: "waitingTwitterCommand", data:{status:"takeMeBackInExtension"}});
            callback();
        });


        var customSubmit = function(url, data, dataType){
            return new Promise(function(resolve){

            var requestOptions = {
                type: "POST",
                url: url,
                data: data,
                beforeSend: function(xhr){
                    headers.forEach(function(header){
                        xhr.setRequestHeader(header.name, header.value);
                    })

                },
                success: function(data){
                    resolve();
                }
            }

            if(dataType === "application/json"){
                requestOptions['contentType'] = 'application/json; charset=utf-8';
                requestOptions['dataType'] = 'json';
                requestOptions['data'] = JSON.stringify(data);
            }

                $.ajax(requestOptions);
            });

        };

    }

});