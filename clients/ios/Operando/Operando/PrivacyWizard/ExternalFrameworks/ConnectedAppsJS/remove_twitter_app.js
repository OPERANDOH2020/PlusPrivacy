removeTwitterApp(Android.getAppId());

function removeTwitterApp(appId) {
    doGetRequest("https://twitter.com/settings/applications?lang=en", function (content) {
        extractTwitterToken(content, function (data) {
            var _body = "token=" + appId + "&" + encodeURIComponent("scribeContext[component]")
                + "=oauth_app&twttr=true&authenticity_token=" + data.token;
            doPOSTRequest("https://twitter.com/oauth/revoke", _body, function (response) {
//                callback();
                Android.onAppRemoved(appId);
            })
        });
    })
}

function extractTwitterToken(content, callback) {
    var tokenRegex = 'value="(.*?)" name="authenticity_token"';
    var token = RegexUtils.findValueByRegex(self.key, 'authenticity_token', tokenRegex, 1, content, true);
    callback({token: token});
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
