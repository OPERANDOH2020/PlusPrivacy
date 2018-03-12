Android.showToast("usual settings");
console.log("usual settings");


var extractedData = {};
var googleParams = {};


if (!String.prototype.unescapeHtmlChars) {
    String.prototype.unescapeHtmlChars = function () {
        var value = this;

        value = value.replace(/&amp;/g, "&");
        value = value.replace(/&quot;/g, "\"");
        value = value.replace(/&apos;/g, "'");
        value = value.replace(/&nbsp;/g, " ");
        value = value.replace(/&gt;/g, ">");
        value = value.replace(/&lt;/g, "<");
        value = value.replace(/&rlm;/g, "");

        value = value.replace(/&#(\d+);/g, function (match, number) {
            return String.fromCharCode(parseInt(number, 10));
        });

        value = value.replace(/&#x([0-9a-fA-F]+);/g, function (match, hex) {
            return String.fromCharCode(parseInt(hex, 16));
        });
        return value;
    };
}


RegexUtis = {
    findValueByRegex: function findValueByRegex(serviceKey, label, regex, index, data, must) {
        var value = this.findMultiValuesByRegex(serviceKey, label, regex, [index], data, must)[0];
        return RegexUtis.cleanAndPretty(value);
    },

    findMultiValuesByRegex: function findMultiValuesByRegex(serviceKey, label, regex, indices, data) {
        var rawValues = data.match(regex);

        var values = [];

        if (!rawValues) {
            return values;
        }

        for (var i = 0; i < indices.length; i++) {
            values[values.length] = rawValues[indices[i]];
        }


        return values;
    },

    findAllOccurrencesByRegex: function findAllOccurrencesByRegex(serviceKey, label, regex, index, data, processor) {
        var rawValues = data.match(new RegExp(regex, 'g'));

        var values = [];
        if (!rawValues) {

            return values;
        }

        for (var i = 0; i < rawValues.length; i++) {
            var valueToProcess = ('' + rawValues[i]).match(regex)[index];

            if (processor)
                values[values.length] = processor(valueToProcess);
            else
                values[values.length] = valueToProcess;
        }

        return values;
    },

    clean: function (value) {
        if (value) {
            value = value.replace(/<[^>]*>/g, '');
        }
        return value;
    },

    prettify: function (value) {
        if (value) {
            value = value.trim();
            value = value.replace(/\s+/g, ' ');
            value = value.unescapeHtmlChars();
        }
        return value;
    },

    cleanAndPretty: function (value) {
        return RegexUtis.prettify(RegexUtis.clean(value));
    },

    findValueByRegex_CleanAndPretty: function findValueByRegex_CleanAndPretty(serviceKey, label, regex, index, data, must) {
        var value = RegexUtis.findValueByRegex(serviceKey, label, regex, index, data, must);

        return RegexUtis.cleanAndPretty(value);
    },

    findValueByRegex_Pretty: function findValueByRegex_Pretty(serviceKey, label, regex, index, data, must) {
        var value = RegexUtis.findValueByRegex(serviceKey, label, regex, index, data, must);
        return RegexUtis.prettify(value);
    }
};



getGoogleData(function (response) {

    googleParams = response;
//        console.log("google params", googleParams);

    secureAccount(Android.getUsualPrivacySettings());
});


function getGoogleData(callback) {

    doGetRequest("https://myaccount.google.com/permissions?hl=en", getData);

    function getData(pageData) {
        var match;
        var sid;

        paramsOption1 = "\\\[.*,\\\'([\\\w-]+:[\\\w\\\d]+)\\\',.*\\\]\\\s.*(?=(\\\,\\\s*)+\\\].*window\\\.IJ_valuesCb \\\&\\\&)";
        match = RegexUtis.findMultiValuesByRegex(self.key, 'Revoke Params', paramsOption1, [1], pageData, true);

        var sidRegex = 'WIZ_global_data.+{[^}]*?:\\\"([-\\\d]+?)\\\"[^:\\\"]+';
        sid = RegexUtis.findValueByRegex(self.key, 'f.sid', sidRegex, 1, pageData, true);
        var at = match[0];

        var data = {
            'at': at,
            'f_sid': sid
        };

        callback(data);
    }
}


function doGetRequest(url, callback) {

    var oReq = new XMLHttpRequest();
    oReq.onreadystatechange = function () {
        if (oReq.readyState == XMLHttpRequest.DONE) {
            callback(oReq.responseText, true);
        }
    };
    oReq.open("GET", url);
    oReq.send();
}


function secureAccount(privacySettingsJsonString) {
    var privacySettings = JSON.parse(privacySettingsJsonString);
    console.log("privacySettings" ,privacySettings);
    var total = privacySettings.length;
    privacySettings = privacySettings.reverse();

    var sequence = Promise.resolve();
    privacySettings.forEach(function (settings, index) {
        sequence = sequence.then(function () {

            return postToGoogle(settings, index, total);
        }).then(function (result) {
            console.log("result", result);
            Android.setProgressBar();
            //             port.postMessage({action: "waitingGoogleCommand", data:{status:"progress", progress:(index+1)}});
        }).catch(function (err) {
            console.log("err", err)
        });
    });

    sequence = sequence.then(function (result) {
        Android.onFinishedLoadingUsualSettings();
    });
}


function postToGoogle(settings, item, total) {

    return new Promise(function (resolve, reject) {
        if (settings.page) {
            sendPostRequest(settings, extractedData, resolve, reject);
        }
    });
}


function sendPostRequest(settings, headers, resolve, reject) {

    var data = {};

    //        var cookies = "";
    //        for (var i = 0; i < response.length; i++) {
    //            cookies += response[i].name + "=" + response[i].value + "; ";
    //        }

    for (var prop in settings.data) {
        data[prop] = settings.data[prop];
    }

    console.log("settings.url 0", settings.url);

    for (var param in settings.params) {
        if (settings.params[param].type && settings.params[param].type === "dynamic") {
            if (headers[param]) {
                settings.url = settings.url.replace("{" + settings.params[param].placeholder + "}", headers[param]);
            }
        }
    }

    var _body = "";


    Object.keys(settings.data).forEach(function (item, index) {
        if (index !== 0) {
            _body += "&";
        }
        _body += item + "=" + settings.data[item];
    });

    _body += "&at=" + googleParams['at'];

    var now = new Date();
    var req_id = 3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 1E5;
    console.log("settings.url 1", settings.url);
    settings.url = settings.url.replace("{SID}", googleParams['f_sid']);
    console.log("settings.url 2", settings.url);
    settings.url = settings.url.replace("{REQID}", req_id);
    console.log("settings.url 3", settings.url);

    $.ajax({
        type: "POST",
        url: settings.url,
        data: _body,
        dataType: "text",

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
            console.log("success")
        },
        statusCode: {
            500: function () {
                console.log("500 error");
                reject();
            }
        },
        error: function (a, b, c) {
            console.log("error", a, b, c);
            reject(b);
        },
        complete: function (request, status) {
            console.log("complete")
        },
        timeout: 1000

    });

}