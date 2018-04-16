
(function () {

    var snApps = [];

    function getAppData(url) {
        return new Promise(function (resolve, reject) {
            doGetRequest(url, function (data) {
                resolve(data);
            })
        })
    }

    var handleDataForSingleApp = function (appId, crawledPage) {

        var appNameRegex;
        var appIconRegex;
        var permissionsRegex;
        var appVisibility;

        appNameRegex = '<div\\sclass="_5xu4">\\s*<header>\\s*<h3.*?>(.*?)</h3>';
        appIconRegex = /<div\s+class="_5xu4"><i\s+class="img img _2sxw"\s+style="background-image: url\(&#039;(.+?)&#039;\);/;
        permissionsRegex = '<span\\sclass="_5ovn">(.*?)</span>';
        appVisibility = '<div\\sclass="_52ja"><span>(.*?)</span></div>';

        var name = RegexUtils.findValueByRegex_CleanAndPretty(self.key, 'App Name', appNameRegex, 1, crawledPage, true);
        var iconUrl = RegexUtils.findValueByRegex(self.key, 'App Icon', appIconRegex, 1, crawledPage, true);
        var permissions = RegexUtils.findAllOccurrencesByRegex(self.key, "Permissions Title", permissionsRegex, 1, crawledPage, RegexUtils.cleanAndPretty);
        var visibility = RegexUtils.findValueByRegex_CleanAndPretty(self.key, 'Visibility', appVisibility, 1, crawledPage, true);
        console.log("iconUrl ", iconUrl);
        var app = {
            appId: appId,
            iconUrl: iconUrl,
            name: name,
            permissions: permissions,
            visibility: visibility
        };

        snApps.push(app)
    }


    var getApps = function (res) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(res, "text/html");
        var sequence = Promise.resolve();
        var apps = $('div._5b6q h3 a');

        for (var i = 0; i < apps.length; i++) {
            (function (i) {
                var appId = apps[i].getAttribute('href').split('appid=')[1];
                sequence = sequence.then(function () {
                    return getAppData("https://m.facebook.com/" + apps[i].getAttribute('href'));
                })
                    .then(function (result) {
                        handleDataForSingleApp(appId, result);
                    });
            })(i);

        }

        sequence.then(function () {
//            callback(snApps);
            console.log("snApps" + snApps);
                      return JSON.stringify(snApps);
        });

    };

//    doGetRequest("https://m.facebook.com/privacy/touch/apps/list/?tab=all", getApps);
    getApps(document.getElementsByTagName('html')[0].innerHTML);

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
