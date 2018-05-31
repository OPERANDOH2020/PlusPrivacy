
(function () {

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
    console.log("linkedInApps", linkedInApps);
    Android.onFinishedLoadingCallback(JSON.stringify(linkedInApps));

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