$(document).ready(function(){


    var tooltipTemplate = "<div class='pp_twitter_popup'>"
        + "<div class='pp-twitter-header'>Please enter your password in order to complete the privacy wizard</div><br/>"
        + "</div>";

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

    var SafetyForm = {
        "_method": "PUT",
        "authenticity_token": getAuthenticityToken(),
        "user[protected]": 1,
        "user[geo_enabled]": 1,
        "user[allow_media_tagging]": "following",
        "user[discoverable_by_email]": 0,
        "user[discoverable_by_mobile_phone]": 0,
        "user[allow_contributor_request]": "none",
        "user[allow_dms_from_anyone]": 0,
        "user[allow_dm_receipts]": 0,
        "user[nsfw_view]": 0,
        "user[nsfw_user]": 0
    };

    privacySettings.forEach(function (setting) {

        for (var key in setting["data"]) {
            SafetyForm[key] = setting["data"][key];
        }
    });

    var customSubmit = function(event){
        event.preventDefault();
        SafetyForm["auth_password"] = $("#auth_password").val();
        $.ajax({
            type: "POST",
            url: "https://twitter.com/settings/safety/update",
            data: SafetyForm,
            success: function(data){
                if(data.indexOf("Incorrect password! Please enter your current password to change your settings.")>0){
                    $("#auth_password").val("");
                    alert("Please enter your valid password!");
                }
                else{
                    callback();
                }

            },
            dataType: "html"
        });

        port.postMessage({action: "waitingTwitterCommand", data:{status:"takeMeBackInExtension"}});
    };

    setTimeout(function(){
        $("#settings_save").removeAttr("disabled");
        $("#settings_save").click();
        port.postMessage({action: "waitingTwitterCommand", data:{status:"progress", progress:(1)}});
        port.postMessage({action: "waitingTwitterCommand", data:{status:"giveMeCredentials"}});

        $("#password_dialog-dialog").tooltipster({
            animation: 'fade',
            delay: 200,
            theme: ['tooltipster-plus-privacy'],
            content:jQuery(jQuery.parseHTML(tooltipTemplate)),
            contentAsHTML: true,
            triggerClose: {
                click: true,
                scroll: true
            }
        });
        $("#password_dialog-dialog").tooltipster('open');

        $("#save_password").attr("type","button");
        $("#account-form").on("submit", customSubmit);
        $("#save_password").on("click",customSubmit);
        $("#auth_password").on("keypress", function(event){
            if (event.which == 13 || event.keyCode == 13) {
                customSubmit(event);
                return false;
            }
        })

    },200);
    port.postMessage({action: "waitingTwitterCommand", data:{status:"progress", progress:(0)}});
}

function getAuthenticityToken(){
    return $("#authenticity_token").val();
}
});