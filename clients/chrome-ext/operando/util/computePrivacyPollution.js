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


function computePrivacyPollution(list){
    var over7 = false;
    var counter = 0;
    var value = list.reduce(function(prev, current){

        if(!permissionConfig[current]){
            permissionConfig[current] = 5;
        }

        if(permissionConfig[current] >7){
            over7 = true;
        }
        counter++;
        return permissionConfig[current] + prev;
    }, 1);
    if(over7){
        value += (5 * counter)-1;
        value = value/counter - 5;
    } else {
        if(counter){
            value = value/counter;
        }
    }

    return Math.ceil(value);
}


function getPrivacyPollutionColor(number){
    return colours[number];
}

