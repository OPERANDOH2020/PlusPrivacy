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
    "webRequestBlocking":5


};

var whitelisted_extensiosn = [
    {
        name: "Adblock Plus",
        chrome_id: "cfhdojbkjhnklbpkdaibdccddilifddb",
        firefox_id: "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}"
    }, {
        name: "PlusPrivacy",
        id: "boagbmhcbemflaclmnbeebgbfhbegekc",
        firefox_id:"{d7dbba27-6af6-484c-a84e-9c59c458f0df}"
    },
    {
        name: "uBlock Origin",
        chrome_id: "cjpalhdlnbpafiamejdnhcphjbkeiagm",
        firefox_id:"uBlock0@raymondhill.net"
    },
    {
        name: "Privacy Badger",
        chrome_id: "pkehgijcmpdhfbdbbnkijodmdjhbjlgp",
        firefox_id:"jid1-MnnxcxisBPnSXQ@jetpack"
    },
    {
        name: "HTTPS Everywhere",
        chrome_id: "gcbommkclmclpchllfjekcdonpmejbdp",
        firefox_id:"https-everywhere@eff.org"
    }, {
        name: "CanvasFingerprintBlock",
        chrome_id: "ipmjngkmngdcdpmgmiebdmfbkcecdndc",
        firefox_id:"{94249bf3-29a3-4bb5-aa30-013883e8f2f4}"
    }, {
        name: "AdBlock",
        chrome_id: "gighmmpiobklfepjocnamgkkbiglidom",
        firefox_id:"jid1-NIfFY2CA8fy1tg@jetpack"
    }, {
        name: "Ghostery – Privacy Ad Blocker",
        chrome_id: "mlomiejdfkolichcflejclcbmpeaniij",
        firefox_id:"firefox@ghostery.com"
    }, {
        name: "Fair AdBlocker",
        chrome_id: "lgblnfidahcdcjddiepkckcfdhpknnjh"
    },
    {
        name: "Adblocker Genesis Plus",
        chrome_id: "jacihiikpacjaggdldhcdfjpbibbfjmh"
    }, {
        name: "uBlock Plus Adblocker",
        chrome_id: "oofnbdifeelbaidfgpikinijekkjcicg"
    }, {
        name: "uBlock Adblocker Plus",
        chrome_id: "pnhflmgomffaphmnbcogleagmloijbkd"
    }, {
        name: "AdGuard AdBlocker",
        chrome_id: "bgnkhhnnamicmpeenaelnjfhikgbkllg",
        firefox_id:"adguardadblocker@adguard.com"
    }, {
        name: "Social Network Adblocker",
        chrome_id: "dmgjckeibmdfndlflobjhddhmemajjld"
    }, {
        name: "Decentraleyes",
        chrome_id: "ldpochfccmkkmhdbclfhpagapcfdljkj",
        firefox_id:"jid1-BoFifL9Vbdl2zQ@jetpack"
    }, {
        name: "ScriptSafe",
        chrome_id: "oiigbmnaadbkfbmpbfijlflahbdbdgdf",
        firefox_id:"scriptsafe@protonmail.com"
    }, {
        name: "Privacy Cleaner",
        chrome_id: "liiikhhbkpmpomjmdofandjmdgapiahi"
    }
];



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



function extensionIsWhitelisted(browser, extensionId){

    var extensionsIds = whitelisted_extensiosn.map(function(extension){return extension[browser+"_id"]});
    return extensionsIds.indexOf(extensionId) > -1 ? true : false;
}


function getPrivacyPollutionColor(number){
    return colours[number];
}

