Android.showToast("works");
//(function(privacySettings) {
//
//
//    var SafetyForm = {
//        "_method": "PUT",
//        "authenticity_token": getAuthenticityToken(),
//        "user[protected]": 1,
//        "user[geo_enabled]": 1,
//        "user[allow_media_tagging]": "following",
//        "user[discoverable_by_email]": 0,
//        "user[discoverable_by_mobile_phone]": 0,
//        "user[allow_contributor_request]": "none",
//        "user[allow_dms_from_anyone]": 0,
//        "user[allow_dm_receipts]": 0,
//        "user[nsfw_view]": 0,
//        "user[nsfw_user]": 0
//    };
//
//    privacySettings.forEach(function(setting) {
//
//        for (var key in setting["data"]) {
//            SafetyForm[key] = setting["data"][key];
//        }
//    });
//
//    var customSubmit = function(event) {
//        event.preventDefault();
//        SafetyForm["auth_password"] = $("#auth_password").val();
//        $.ajax({
//            type: "POST",
//            url: "https://twitter.com/settings/safety/update",
//            data: SafetyForm,
//            success: function(data) {
//                if (data.indexOf("Incorrect password! Please enter your current password to change your settings.") > 0) {
//                    $("#auth_password").val("");
//
//                } else {
//                    callback();
//                }
//
//            },
//            dataType: "html"
//        });
//
//    };
//
//    var abortTwitterSettings = function(event) {
//        event.preventDefault();
//    }
//
//
//    var promptTooltip = function() {
//        setTimeout(function() {
//            $("#settings_save").removeAttr("disabled");
//            $("#settings_save").click();
//
//            setTimeout(function() {
//
//                $("#save_password").attr("type", "button");
//                $("#account-form").on("submit", customSubmit);
//                $("#save_password").on("click", customSubmit);
//                $("#auth_password").on("keypress", function(event) {
//                    if (event.which == 13 || event.keyCode == 13) {
//                        customSubmit(event);
//                        return false;
//                    }
//                });
//
//                $("#auth_password").bind('input propertychange', function() {
//                    $("#save_password").removeAttr("disabled");
//
//                });
//                $("#cancel_password_button").attr("type", "button");
//                $("#cancel_password_button").on("click", abortTwitterSettings);
//            }, 100);
//
//        }, 100);
//        port.postMessage({
//            action: "waitingTwitterCommand",
//            data: {
//                status: "progress",
//                progress: (0)
//            }
//        });
//    }
//
//
//    var personalizationInterval = setInterval(function() {
//        if ($(".personalization-status").text().length !== 0) {
//
//            clearInterval(personalizationInterval);
//            promptTooltip();
//        } else {
//            console.log("loading");
//        }
//
//    }, 50);
//
//})(Android.getPrivacySettings());
//
//function getAuthenticityToken() {
//    return $("#authenticity_token").val();
//}