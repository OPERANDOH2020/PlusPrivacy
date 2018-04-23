removeLinkedinApp(Android.getAppId());

function removeLinkedinApp(appId) {

    doGetRequest("https://www.linkedin.com/psettings/permitted-services", function (content) {
        extractLinkedinToken(content, function (data) {
            var _body = "id=" + appId + "&" + "type=OPEN_API" + "&" + "csrfToken=" + data.csrfToken;
            doPOSTRequest("https://www.linkedin.com/psettings/permitted-services/remove", _body, function (response) {
                Android.onAppRemoved(appId);
            });
        });
    });
}

function extractLinkedinToken(content, callback) {
    var tokenRegex = 'name="csrfToken" value="(.*?)"';
    var token = RegexUtils.findValueByRegex(self.key, 'authenticity_token', tokenRegex, 1, content, true);
    callback({csrfToken: token});
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
