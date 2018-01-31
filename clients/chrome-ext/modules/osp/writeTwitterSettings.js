$(document).ready(function(){
    var headers = window.TWITTER_HEADERS;
    var privacySettings = [];
    var port = chrome.runtime.connect({name: "applyTwitterSettings"});
    port.postMessage({action: "waitingTwitterCommand", data: {status:"waitingTwitterCommand"}});

    port.onMessage.addListener(function (msg) {
        if (msg.command == "applySettings") {
            privacySettings = msg.settings;
            console.log("done");
            secureAccount(function () {
                port.postMessage({action: "waitingTwitterCommand", data:{status:"progress", progress:(privacySettings.length)}});
                port.postMessage({action: "waitingTwitterCommand", data:{status:"settings_applied"}});
            });
        }
    });

    function secureAccount(callback){

        var SafetyForm = {
            include_mention_filter:true,
            include_ranked_timeline:true
        };

        privacySettings.forEach(function (setting) {
            for (var key in setting["data"]) {
                SafetyForm[key] = setting["data"][key];
            }
        });

        var customSubmit = function(event){
            $.ajax({
                type: "POST",
                url: "https://api.twitter.com/1.1/account/settings.json",
                data: SafetyForm,
                beforeSend: function(xhr){
                    headers.forEach(function(header){
                        xhr.setRequestHeader(header.name, header.value);
                    })

                },
                success: function(data){
                    port.postMessage({action: "waitingTwitterCommand", data:{status:"takeMeBackInExtension"}});
                    callback();
                }
            });
        };

        setTimeout(customSubmit,2000);

    }


});