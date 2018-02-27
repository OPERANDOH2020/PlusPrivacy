
secureAccount(Android.getPreferencePrivacySettings());

function secureAccount(privacySettingsJsonString) {
    var privacySettings = JSON.parse(privacySettingsJsonString);
    var total = privacySettings.length;
    privacySettings = privacySettings.reverse();

    var sequence = Promise.resolve();
    privacySettings.forEach(function (settings, index) {
        sequence = sequence.then(function () {

            return postToGoogle(settings, index, total);
        }).then(function (result) {
            console.log("result", result);
            Android.setProgressBar();

        }).catch(function (err) {
            console.log("err", err);
            Android.setProgressBar();
        });
    });

    sequence = sequence.then(function (result) {
        Android.onFinishedLoadingPreferenceSettings();

    });
}

function postToGoogle(settings, item, total) {

    return new Promise(function (resolve, reject) {
        if (settings.page) {
            sendGetRequest(settings, resolve, reject);
        }
    });
}

function sendGetRequest(settings, resolve, reject) {

    var getSIGValue = function (callback) {
//        htmlContent = Android.doGetRequest(settings.page);
//        console.log(htmlContent);
        doGET(settings.page, function (htmlContent) {
            // console.log("settings.page", htmlContent);
            var sig_regex = /<input type="hidden" name="sig" id="sig" value="(.*?)">/g;
            var m;
            if ((m = sig_regex.exec(htmlContent)) !== null) {
                if (m.index === sig_regex.lastIndex) {
                    sig_regex.lastIndex++;
                }
            }

            if (m && m[1]) {

                callback(m[1]);
            } else {
                reject("no sig found");
            }
        })
    };

    getSIGValue(function (sigValue) {

        console.log("sigValue", sigValue);
        var url = settings.url.replace("{SIG}", sigValue);

        doGET(url, resolve, reject);
    })
}

function doGET(page, callback, reject) {

    console.log("page", page);
    $.ajax({
        type: "GET",
        url: page,
        success: callback,
        xhrFields: {
            withCredentials: true
        },
        dataType: 'html',
        error: function (request, textStatus, errorThrown) {

            console.log("textStatus: ", textStatus, "errorThrown", errorThrown);
            console.log("status", request.status);
            reject("reject")
        }
    });
}