
(function () {
 
 var kMessageTypeKey = "messageType";
 var kLogMessageTypeContentKey = "logContent";
 var kLogMessageType = "log";
 
 var kStatusMessageMessageType = "statusMessageType";
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

var linkedInApps = [];


function getAppsForMobile(res) {
    var rawAppsRegex = '<li\\s+id=\"permitted-service-(?:.|\n)*?</div>(?:.|\n)*?</li>';
    var rawAppsList = RegexUtils.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, res);
    var appIdRegex = 'data-app-id="(.*?)"\\s?data-app-type';
    var appNameRegex = 'p\\s+class="permitted-service-name">(.*?)</p';
    var iconRegex = 'src=\"(.*?)\"';

    linkedInApps = rawAppsList.map(function (rawAppData) {

        return {
            appId: RegexUtils.findValueByRegex(self.key, 'Revokde-Id', appIdRegex, 1, rawAppData, true),
            name: RegexUtils.findValueByRegex_Pretty(self.key, 'App Name+Id', appNameRegex, 1, rawAppData, true),
            iconUrl: RegexUtils.findValueByRegex(self.key, 'App Icon', iconRegex, 1, rawAppData, true)
                .unescapeHtmlChars()
        }
    });

//    callback(linkedInApps);
sendStatusMessage(linkedInApps);

}

doGetRequest("https://www.linkedin.com/psettings/permitted-services", getAppsForMobile)


})();


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
