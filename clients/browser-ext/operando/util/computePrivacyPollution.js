var colours = {};
colours[10] = colours [9] = "red";
colours[8]  = colours [7] = "orange";
colours[6]  = colours [5] = "yellow";
colours[4]  = colours [3] = "green";
colours[2]  = colours [1] = "blue";

var permissionConfig= {
    "activeTab" :	10,
    "alarms"    :   3,
    "app.window.alwaysOnTop":2,
    "audioModem":	2,
    "background":	1,
    "bookmarks"	:   3,
    "browsingData":	5,
    "clipboardRead":8,
    "clipboardWrite":10,
    "contentSettings":10,
    "contextMenus":	5,
    "cookies":  	10,
    "copresence":	7,
    "debugger":	    10,
    "declarativeContent":5,
    "declarativeWebRequest":6,
    "desktopCapture":8,
    "dns":7,
    "documentScan": 9,
    "downloads":    10,
    "enterprise.platformKeys":10,
    "experimental": 5,
    "fileBrowserHandler":5,
    "fileSystemProvider":5,
    "fileSystem":8,
    "fileSystem.write":8,
    "fileSystem.directory":8,
    "fileSystem.retainEntries":6,
    "fontSettings": 3,
    "gcm":          3,
    "geolocation":  7,
    "history":  	9,
    "identity":	    10,
    "identity.email":10,
    "idle": 	    1,
    "idltest":  	1,
    "location": 	8,
    "management":	7,
    "mediaGalleries":3,
    "nativeMessaging":2,
    "networking.config":5,
    "notificationProvider":5,
    "notifications":5,
    "pageCapture":  5,
    "platformKeys": 10,
    "power":	    1,
    "printerProvider":2,
    "privacy":  	7,
    "processes":	5,
    "proxy":	    7,
	"searchProvider": 	1,
    "sessions": 	10,
    "signedInDevices":5,
    "socket":       5,
    "storage":  	3,
    "system.cpu":   2,
    "system.display":2,
    "system.memory":2,
    "system.network":8,
    "system.storage":2,
    "tabCapture":   5,
    "tabs":         5,
    "topSites":     5,
    "tts":          1,
    "ttsEngine":	1,
    "unlimitedStorage":	1,
    "vpnProvider":	3,
    "wallpaper":	1,
    "webConnectable":3,
    "webview":2,
    "webNavigation":3,
    "webRequest":	10,
    "webRequestBlocking":5,


};


function computePrivacyPollutionByPermissions(list) {
    var over7 = false;
    var counter = 0;
    var value = list.reduce(function (prev, current) {

        if (!permissionConfig[current]) {
            permissionConfig[current] = 5;
        }

        if (permissionConfig[current] > 7) {
            over7 = true;
        }
        counter++;
        return permissionConfig[current] + prev;
    }, 1);
    if (over7) {
        value += (5 * counter) - 1;
        value = value / counter - 5;
    } else {
        if (counter) {
            value = value / counter;
        }
    }

    return Math.ceil(value);
}


function computePrivacyPollution(extension){
    if(extension.homepageUrl === ""){
        return computePrivacyPollutionByPermissions(extension.permissions);
    }
    else{
        var webstorePage = "https://chrome.google.com/webstore/detail/"+extension.id;


        $.ajax({
            type: "GET",
            url: webstorePage,
            success: function(data){
                var parser = new DOMParser();
                var doc = parser.parseFromString(data, "text/html");
                extractInfoFromDoc(doc);
            },
            dataType: "html"
        });
    }
}


function extractInfoFromDoc(doc){
    var $doc=$(doc);
    var mainContent = $doc.find(".e-f")[0];

    var rating = $(mainContent).find(".rsw-stars")[0];
    var rating_number = $(rating).attr("g:rating_override");
    rating_number = Math.round(rating_number*100)/100;
    console.log(rating_number);

    var users = $(mainContent).find(".e-f-ih")[0];
    if(users){
        var usersTitle = $(users).attr("title");
        var users_number = usersTitle.replace( /\D+/g, '');
        console.log(users_number);
    }

    getAlexaRankData("zoso.ro", function(data){
        console.log(data);
    });

}

function getPrivacyPollutionColor(number){
    return colours[number];
}

function getAlexaRankData(siteUrl, callback){
    var url = "http://www.alexa.com/siteinfo/"+siteUrl;

    requestRank(url, callback);
}

function extractAlexaRanking(alexaDoc, callback){

    var $alexaDoc=$(alexaDoc);


    var globleRank = $alexaDoc.find(".globleRank")[0];


       var globalRanking = $(globleRank).children().children().next().children().next().next().prev().text().toString().replace(/\s/g, "");

    callback(globalRanking);

    /*$('.countryRank').filter(function () {
        var data = $(this);
        rankData.countryRank = {};
        rankData.countryRank.rank = data.children().children().next().children().next().next().prev().text().toString().replace(/\s/g, "");
        rankData.countryRank.country = data.children().children().children()['0'].attribs.title.toString();
    });
    $('#engagement-content').filter(function () {
        var data = $(this);

        var engagementData = data.children().children().children().children().next().children().next().prev().text().toString().split('\n');
        rankData.engagement = {};

        rankData.engagement.bounceRate = engagementData[1].replace(/\s/g, "");
        rankData.engagement.dailyPageViewPerVisitor = engagementData[2].replace(/\s/g, "");
        rankData.engagement.dailyTimeOnSite = engagementData[3].replace(/\s/g, "");
    });*/


}

function requestRank(url,callback){
    $.ajax({
        type: "GET",
        url: url,
        success: function(data){
            var parser = new DOMParser();
            var doc = parser.parseFromString(data, "text/html");
            extractAlexaRanking(doc,callback);
        },
        dataType: "html"
    });
}

