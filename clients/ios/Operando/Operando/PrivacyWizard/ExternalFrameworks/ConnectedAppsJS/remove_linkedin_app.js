removeLinkedinApp("LOCAL_APP_ID");

var kMessageTypeKey = "messageType";
var kLogMessageTypeContentKey = "logContent";
var kLogMessageType = "log";

var kStatusMessageMessageType = "statusMessageType";
var kStatusDoneMessageType = "statusDoneMessageType"
var kStatusMessageContentKey = "statusMessageContent";

var webkitSendMessage = function(message) {
    alert(message);
};

window.console = {};
window.console.log = function(logMessage) {
    var webkitMessage = {};
    webkitMessage[kMessageTypeKey] = kLogMessageType;
    webkitMessage[kLogMessageTypeContentKey] = logMessage;
    
    webkitSendMessage(JSON.stringify(webkitMessage));
    
};

var sendStatusMessage = function(settingName) {
    var webkitMessage = {};
    webkitMessage[kMessageTypeKey] = kStatusMessageMessageType;
    webkitMessage[kStatusMessageContentKey] = settingName;
    webkitSendMessage(JSON.stringify(webkitMessage));
};

var sendDoneStatus = function() {
    var webkitMessage = {};
    webkitMessage[kMessageTypeKey] = kStatusDoneMessageType;
    webkitSendMessage(JSON.stringify(webkitMessage));
};

function removeLinkedinApp(appId) {
    
    doGetRequest("https://www.linkedin.com/psettings/permitted-services", function (content) {
        extractLinkedinToken(content, function (data) {
            var _body = "id=" + appId + "&" + "type=OPEN_API" + "&" + "csrfToken=" + data.csrfToken;
            doPOSTRequest("https://www.linkedin.com/psettings/permitted-services/remove", _body, function (response) {
                          
                sendDoneStatus()
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
