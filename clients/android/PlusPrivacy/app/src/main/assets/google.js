console.log("works - google.js");

Android.showToast("test");


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


(function ($) {
    $.fn.goTo = function () {
        var windowHeight = jQuery(window).height();

        var itemHeight = $(this).height();
        $('html, body').animate({
            scrollTop: $(this).offset().top - (windowHeight - itemHeight) / 2 + 'px'
        }, 500);
        return this;
    }
})(jQuery);


(function ($) {
    console.log("$.fn.hasAttr = function(name) {");
    $.fn.hasAttr = function (name) {
        return this.attr(name) !== undefined;
    };

})(jQuery);

var containerClassName = ".HICA4c";
var arrowImage = jQuery('<img width="16px" height="16px" src="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMwOS4xNDMgMzA5LjE0MyIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMzA5LjE0MyAzMDkuMTQzOyIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgd2lkdGg9IjUxMnB4IiBoZWlnaHQ9IjUxMnB4Ij4KPHBhdGggZD0iTTI0MC40ODEsMTQ5LjI2OEw5My40MSwyLjE5N2MtMi45MjktMi45MjktNy42NzgtMi45MjktMTAuNjA2LDBMNjguNjYxLDE2LjM0ICBjLTEuNDA3LDEuNDA2LTIuMTk3LDMuMzE0LTIuMTk3LDUuMzAzYzAsMS45ODksMC43OSwzLjg5NywyLjE5Nyw1LjMwM2wxMjcuNjI2LDEyNy42MjVMNjguNjYxLDI4Mi4xOTcgIGMtMS40MDcsMS40MDYtMi4xOTcsMy4zMTQtMi4xOTcsNS4zMDNjMCwxLjk4OSwwLjc5LDMuODk3LDIuMTk3LDUuMzAzbDE0LjE0MywxNC4xNDNjMS40NjQsMS40NjQsMy4zODQsMi4xOTcsNS4zMDMsMi4xOTcgIGMxLjkxOSwwLDMuODM5LTAuNzMyLDUuMzAzLTIuMTk3bDE0Ny4wNzEtMTQ3LjA3MUMyNDMuNDExLDE1Ni45NDYsMjQzLjQxMSwxNTIuMTk3LDI0MC40ODEsMTQ5LjI2OHoiIGZpbGw9IiNmZmI0MDAiLz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPC9zdmc+Cg==" />');
var arrowElementDisable = jQuery('<div class="downArrow bounce"></div>');
var checkForPopup;
var enableDisablePopupCheckInterval;
var arrowElementEnable = jQuery('<div class="downArrow bounce off"></div>');

arrowElementDisable.append(jQuery("<span>Click to pause (recommended) </span>"));
arrowElementDisable.append(arrowImage);
arrowElementEnable.append(jQuery("<span>Click to turn on</span>"));
$(arrowImage).clone().appendTo(arrowElementEnable);


var steps = [];
var currentIndex = 0;


(function (privacySettingsJsonString) {

    var privacySettings = JSON.parse(privacySettingsJsonString);
    var activityControlsSettings = [];
    var usualSettings = [];

    privacySettings.forEach(function (setting) {
        if (setting.method_type == "user-action") {
            activityControlsSettings.push(setting);
        }
        else {
            usualSettings.push(setting);
        }
    });


    getGoogleData(function (response) {

        googleParams = response;
//        console.log("google params", googleParams);

        console.log("usualSettings", usualSettings);

        secureAccount(usualSettings);
    });

    applyActivityControlSettings(activityControlsSettings);


})(Android.getPrivacySettings());


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


function postToGoogle(settings, item, total) {

    return new Promise(function (resolve, reject) {
        if (settings.page) {
            console.log("method_type", settings.page, settings.method_type);
            if (settings.method_type === "GET") {
                sendGetRequest(settings, extractedData, resolve, reject);
            } else {
                console.log("sendPostRequest", settings);
                sendPostRequest(settings, extractedData, resolve, reject);
            }
        }
    });
}

function sendGetRequest(settings, headers, resolve, reject) {

    var getSIGValue = function (callback) {
        htmlContent = Android.doGetRequest(settings.page);
        console.log(htmlContent);
//        doGET(settings.page, function(htmlContent) {
//            console.log("settings.page", htmlContent);
        var sig_regex = /<input type="hidden" name="sig" value="(.*?)">/g;
        var m;
        if ((m = sig_regex.exec(htmlContent)) !== null) {
            if (m.index === sig_regex.lastIndex) {
                sig_regex.lastIndex++;
            }
        }
        console.log("m", m);
        if (m && m[1]) {

            callback(m[1]);
        } else {
            reject("no sig found");
        }
//        })
    };

    getSIGValue(function (sigValue) {
        console.log("sigValue", sigValue);
        var url = settings.url.replace("{SIG}", sigValue);
        doGET(url, resolve);
    })
}


function doGET(page, callback) {
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
        }
    });
}


function secureAccount(privacySettings) {
    var total = privacySettings.length;
    var sequence = Promise.resolve();
    privacySettings.forEach(function (settings, index) {
        sequence = sequence.then(function () {
            return postToGoogle(settings, index, total);
        }).then(function (result) {
            console.log(result);
            //             port.postMessage({action: "waitingGoogleCommand", data:{status:"progress", progress:(index+1)}});
        }).catch(function (err) {
            console.log(err)
        });
    });

    sequence = sequence.then(function (result) {


        var modal = $('<div class="modal"></div>');
        console.log("modal", modal);
        var modal_content = $('<div class="modal-content"></div>');

        var header = $('<div class="modal-header"><h2>PlusPrivacy Wizard</h2></header>');

        var closeModal = function () {
            $(modal_content).animate({
                opacity: 0, // animate slideUp
                marginTop: '600px'
            }, 'fast', 'linear', function () {
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

        var checkModalClick = function (event) {
            if (event.target == modal.get(0)) {

                closeModal();
                window.removeEventListener("click", checkModalClick);
            }
        };
        window.addEventListener("click", checkModalClick);


    });

    sequence = sequence.then(function (result) {
        Android.showToast(result);
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
    settings.url = settings.url.replace("{REQID}", req_id);
    console.log("settings.url 2", settings.url);

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


// var port = chrome.runtime.connect({name: "googleActivityControls"});
// port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"waitingGoogleActivityCommand"}});

function applyActivityControlSettings(settings) {

    console.log("activityControlsSettings", settings);
    console.log("settings.length", settings.length);
    for (var index = 0; index < settings.length; index++) {

        var setting = settings[index];
        console.log("push", setting.data.setting);
        var obj = {
            name: setting.name,
            index: index,
            data: setting.data.setting
        };

        steps.push(obj);
    }
//    settings.forEach(function (setting, index) {
//        console.log("push");
//        steps.push({
//            name: setting.name,
//            index: index,
//            data: setting.data.setting
//        });
//    });

    console.log("steps", steps);
    watchCurrentSettings();
}


function watchCurrentSettings() {
    detectCurrentSettings();
    var changeIsNeeded = false;
    for (var i = 0; i < steps.length; i++) {
        if (steps[i]['current_setting'] != steps[i]['data']) {
            currentIndex = i;
            changeIsNeeded = true;
            changeIndex(currentIndex);
            break;
        }
    }
    if (changeIsNeeded == false) {
        console.log("changeIsNeeded", changeIsNeeded);
        // port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"wizardFinished"}});
    }
}


function detectCurrentSettings() {

    jQuery(containerClassName).each(function (index, element) {

        if ($(element).find(".N2RpBe").length > 0) {
            steps[index]['current_setting'] = "on";
            console.log("N2RpBe", "on");
        }
        else {
            steps[index]['current_setting'] = "off";
            console.log("N2RpBe", "off");

        }
    })

}

function detectCurrentSetting(element) {

    console.log("detectCurrentSetting");

    if ($(element).find(".N2RpBe").length > 0) {
        var toggleElement = $(element).find(".N2RpBe")[0];
        $(toggleElement).parent().css("position", "relative");
        $(toggleElement).parent().prepend(arrowElementDisable[0]);
    }
    else {
        var toggleElement = $(element).find(".LsSwGf.PciPcd")[0];
        $(toggleElement).parent().css("position", "relative");
        $(toggleElement).parent().prepend(arrowElementEnable[0]);
    }
}

function changeIndex(index) {

    console.log("changeIndex", $(containerClassName)[index]);
    detectCurrentSetting($(containerClassName)[index]);
    $(containerClassName).addClass("pp_item_overlay");

    $($(containerClassName)[index]).removeClass("pp_item_overlay");
    $($(containerClassName)[index]).goTo();
    // port.postMessage({action: "waitingGoogleActivityCommand", data: {status:"currentIndex", index:index}});
}


setInterval(function () {
    if ($(".pp_item_overlay").length == 0) {

        watchCurrentSettings();
    }
}, 200);


function enableDisablePopupCheckIntervalFn() {
    var checkItOnce = false;
    enableDisablePopupCheckInterval = setInterval(function () {
        if ($("div[jsaction='JIbuQc:Wh8OAb']").length > 0) {
            if (steps[currentIndex]['current_setting'] == "on") {
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowElementDisable[0]);
            }
            else {
                $("div[jsaction='JIbuQc:Wh8OAb']").append(arrowElementEnable[0]);
            }
            clearInterval(enableDisablePopupCheckInterval);
            checkForPopupFn();
        }
        else {
            if (checkItOnce == false) {
                watchCurrentSettings();
            }
            checkItOnce = true;
        }
    }, 200);
}

function checkForPopupFn() {
    checkForPopup = setInterval(function () {
        if ($("div[jsaction='JIbuQc:Wh8OAb']").length === 0) {
            enableDisablePopupCheckIntervalFn();
            clearInterval(checkForPopup);
        }
    }, 300);
}

enableDisablePopupCheckIntervalFn();

$(".FaV4Jb").addClass("pp_global_overlay");
$(containerClassName).addClass("pp_item_overlay");

