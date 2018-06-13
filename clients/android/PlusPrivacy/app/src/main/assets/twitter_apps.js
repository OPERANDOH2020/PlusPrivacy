(function () {

    var twitterApps = [];

    function getApps(res) {

        var rawAppsRegex = '<div\\s?id=\"oauth(?:.+)\"(?:.|\n)*?</div>(?:.|\n)*?</div>(?:.|\n)*?</div>(?:.|\n)*?</div>';
        var rawAppsList = RegexUtils.findAllOccurrencesByRegex(self.key, 'List of Raw Apps', rawAppsRegex, 0, res);

        var appNameRegex = 'strong>(.*?)\\s?</strong';
        var appIdRegex = 'id="oauth_application_(.*?)"\\s?class';

        var iconRegex = '<img\\s+class="app-img"\\s+src="(.*?)"';
        var permissionsRegex = '<p\\s+class="description">.+?\\n.+?<small\\s+class="metadata">(?:.+\\:\\s?)?(.+?)</small></p>';

        twitterApps = rawAppsList.map(function (rawAppData) {
            var appName = RegexUtils.findValueByRegex_Pretty(self.key, 'App Name+Id', appNameRegex, 1, rawAppData, true);
            var appId = RegexUtils.findValueByRegex(self.key, 'Revokde-Id', appIdRegex, 1, rawAppData, true);

            var iconURL = RegexUtils.findValueByRegex(self.key, 'App Icon', iconRegex, 1, rawAppData, true)
                .unescapeHtmlChars();

            var permissions = RegexUtils.findAllOccurrencesByRegex(self.key, "Extracting Permissions", permissionsRegex, 1, rawAppData, function (value) {
                return value.unescapeHtmlChars();
            });

            return {
                'appId': appId,
                'iconUrl': iconURL,
                'name': appName,
                'permissions': permissions
            };

        });
//        Android.showToast(document.getElementsByTagName('html')[0].innerHTML);
        Android.onFinishedLoadingCallback(JSON.stringify(twitterApps));
    }

//    console.log("CONTENT", document.getElementsByTagName('html')[0].innerHTML)
//    getApps(document.getElementsByTagName('html')[0].innerHTML);
    doGetRequest("https://twitter.com/settings/applications", getApps);

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






