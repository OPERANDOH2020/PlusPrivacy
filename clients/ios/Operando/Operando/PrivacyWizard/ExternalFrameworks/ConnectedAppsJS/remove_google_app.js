
removeGoogleApp(Android.getAppId());

function removeGoogleApp(appId) {

    doGetRequest("https://myaccount.google.com/permissions?hl=en", function (content) {
        extractGoogleTokens(content, appId, function (tokens) {
            var body = "at=" + tokens['at'];
            body += "&f.req=" + '["af.maf",[["af.add",143439692,[{"143439692":["' + tokens['f_req'] + '"]}]]]]';
            var url = 'https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=143439692';
            if (tokens['f_sid']) {
                url += '&f.sid=' + tokens['f_sid'];
            }
            url += '&hl=en&_reqid=' + tokens['req_id'] + '&rt=c';
            doPOSTRequest(url, body, function (response) {
                Android.onAppRemoved(appId);
            });
        });
    });
}


function extractGoogleTokens(content, appId, callback) {
    var now = new Date();
    var paramsOption1 = "\\\[.*,\\\'([\\\w-]+:[\\\w\\\d]+)\\\',.*\\\]\\\s.*(?=(\\\,\\\s*)+\\\].*window\\\.IJ_valuesCb \\\&\\\&)";
    var match = RegexUtils.findMultiValuesByRegex(self.key, 'Revoke Params', paramsOption1, [1], content, true);
    var sidRegex = 'WIZ_global_data.+{[^}]*?:\\\"([-\\\d]+?)\\\"[^:\\\"]+';
    var sid = RegexUtils.findValueByRegex(self.key, 'f.sid', sidRegex, 1, content, true);
    var at = match[0];


    var req_id = 3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 1E5;
    var fReqRegex = 'data-name="' + appId + '".*?data-handle="(.*?)"';
    var f_req = RegexUtils.findValueByRegex(self.key, 'f_req', fReqRegex, 1, content, true);


    callback({
        req_id: req_id,
        f_req: f_req,
        at: at,
        f_sid: sid
    });
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


function doPOSTRequest(url, data, callback) {

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);

    if (data.headers) {
        data.headers.forEach(function (header) {
            xhr.setRequestHeader(header.name, header.value);
        });
    }
    else {
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }

    xhr.onload = function () {
        callback(this.responseText);
    };
    xhr.send(data._body ? data._body : data);
}