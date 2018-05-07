removeFbApp(LOCAL_APP_ID);


function removeFbApp(appId) {

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
    
    doGetRequest("https://www.facebook.com/settings?tab=applications", function (content) {
        extractFBToken(content, function (data) {

            var _body = "_asyncDialog=1&__user=" + data['userId'] + "&__a=1&__req=o&__rev=1562552&app_id=" + appId
                + "&legacy=false&dialog=true&confirmed=true&ban_user=0&fb_dtsg=" + data['fb_dtsg'];
        
            console.log("AICI REMOVE");
                       
            doPOSTRequest("https://www.facebook.com/ajax/settings/apps/delete_app.php?app_id=" + encodeURIComponent(appId) + "&legacy=false&dialog=true", _body, function (response) {
//                callback();
//                Android.onAppRemoved(appId);
                          sendDoneStatus()
            })

        });
    });
}


function extractFBToken(content, callback) {
    
    var dtsgOption1 = 'DTSGInitialData.*?"token"\\s?:\\s?"(.*?)"';
    var dtsgOption2 = 'name=\\\\?"fb_dtsg\\\\?"\\svalue=\\\\?"(.*?)\\\\?"';
    var dtsgOption3 = 'dtsg"\\s?:\\s?\{"token"\\s?:\\s?"(.*?)';

    var fb_dtsg = RegexUtils.findValueByRegex(self.key, 'fb_dtsg', dtsgOption1, 1, content, false);
    if (!fb_dtsg)
        fb_dtsg = RegexUtils.findValueByRegex(self.key, 'fb_dtsg', dtsgOption2, 1, content, false);
    if (!fb_dtsg)
        fb_dtsg = RegexUtils.findValueByRegex(self.key, 'fb_dtsg', dtsgOption3, 1, content, true);

    var userIdOption1 = '"USER_ID" ?: ?"(.*?)"';
    var userId = RegexUtils.findValueByRegex(self.key, 'USER_ID', userIdOption1, 1, content, true);

    var data = {
        'fb_dtsg': fb_dtsg,
        'userId': userId
    };
    
    callback(data);
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
