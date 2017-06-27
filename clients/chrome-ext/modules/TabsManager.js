var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;
var SyncPersistence = require("SynchronizedPersistence").syncPersistence;


var BrowserTab = function (tab){
    this.tab = tab;
    this.isActive = false;
    this.notificationId = null;
    this.history = [];
};

BrowserTab.prototype = {

    update: function (tab) {
        this.tab = tab;
    },
    onRemoved: function () {

    },

    activate: function () {
        this.isActive = true;
    },

    deactivate: function () {
        this.isActive = false;
    },

    setNotification:function(notification){
        this.notificationId = notification;
    },
    removeNotification:function(){
        delete this.notificationId;
    },
    addUrlInHistory: function(url){
        this.history.push(url);
    },
    getHistory:function(){
        return this.history;
    },
    getLastVisited:function(){
        if(this.history.length>0){
            return this.history[this.history.length-1];
        }
        else{
            return null;
        }

    }

};

var TabsManager = function(){
    init();
    this.browserTabs = {};
    var self = this;

    chrome.tabs.query({}, function(results) {
        results.forEach(function(tab) {
            self.browserTabs[tab.id] = new BrowserTab(tab);
        });
    });

    chrome.tabs.onActivated.addListener(function (activeInfo){
        for(var id in self.browserTabs){
            if(id === activeInfo.tabId){
                self.browserTabs[id].activate();
            }
            else{
                self.browserTabs[id].deactivate();
            }
        }
    });

    function onUpdatedListener(tabId, changeInfo, tab) {
        self.browserTabs[tab.id].update(tab);
        if(isGoodToAddInHistory(changeInfo.url)){
            self.browserTabs[tab.id].addUrlInHistory(changeInfo.url);
        }

    }
    function onRemovedListener(tabId) {
        delete self.browserTabs[tabId];
    }

    chrome.tabs.onCreated.addListener(function (tab){
        self.browserTabs[tab.id]= new BrowserTab(tab);
        if(isGoodToAddInHistory(tab.url)){
            self.browserTabs[tab.id].addUrlInHistory(tab.url);
        }

    });

    chrome.webNavigation.onCreatedNavigationTarget.addListener(function (details){
        var parentTab = self.getTab(details.sourceTabId);
            if(parentTab){
                self.getTab(details.tabId).addUrlInHistory(parentTab.getLastVisited());
            }
    });

    chrome.tabs.onUpdated.addListener(function(tabId,changeInfo,tab){
        onUpdatedListener(tabId,changeInfo,tab);

        if (authenticationService.isLoggedIn()) {
            checkConnectWithSNApisUrls(tabId, changeInfo, tab);
        }

        if (tab.url) {

            if (changeInfo.status === "complete") {
                if (tab.url.indexOf(ExtensionConfig.WEBSITE_HOST) != -1) {
                    establishPlusPrivacyWebsiteCommunication(tabId);
                }
                else if (isAllowedToInsertScripts(tab.url)) {
                    if (authenticationService.isLoggedIn()) {
                        self.suggestSubstituteIdentities(tab.id);
                    }
                }
            }
        }
    });
    chrome.tabs.onRemoved.addListener(onRemovedListener);
};

TabsManager.prototype.getTab = function (tabId) {
    return this.browserTabs[tabId];
},
TabsManager.prototype.getBrowserTabByNotificationId = function (notificationId) {
    for (var p in this.browserTabs) {
        if (this.browserTabs[p].notificationId && this.browserTabs[p].notificationId == notificationId) {
            return this.browserTabs[p];
        }
    }
},

TabsManager.prototype.allowSocialNetworkPopup = function (data) {

    var browserTab = TabsMng.getBrowserTabByNotificationId(data.notificationId);
    browserTab.removeNotification();
    var tab = browserTab.tab;

    if(data.status === "allow" && data.notificationId){
        chrome.tabs.executeScript(tab.id, {file: "/operando/modules/pfb/allowSNContent.js"});
        authenticationService.getCurrentUser(function(user){
            SyncPersistence.set("PfbNotificationsAccepted", "offerUserId", data.offerId.toString()+user.userId.toString());
        });
    }
    else{

        chrome.tabs.query({windowId:tab.windowId,windowType:"popup"}, function(tabs){
           if(tabs.length>0){
               tab = tabs[0];
               chrome.tabs.remove(tab.id);
           }else{
               chrome.tabs.executeScript(tab.id, {code:"window.history.back();"});
           }
        });
    }
};

TabsManager.prototype.suggestSubstituteIdentities = function(tabId){
    injectScript(tabId, "operando/modules/identity/input-track.js", ["jQuery","UserPrefs","DOMElementProvider","Tooltipster"], function(){
        insertCSS(tabId,"operando/assets/css/change-identity.css");
        insertCSS(tabId,"operando/utils/tooltipster/tooltipster.bundle.min.css");
        insertCSS(tabId,"operando/utils/tooltipster/tooltipster-plus-privacy.css");
    });
};


TabsManager.prototype.offerIsAccepted = function(offerId, callback){
    authenticationService.getCurrentUser(function(user){
        SyncPersistence.exists("PfbNotificationsAccepted", "offerUserId", offerId.toString()+user.userId.toString(), function (existence) {
            callback(existence);
        });
    });


};

TabsManager.prototype.getLastVisitedUrl = function(notificationId, callback){
    var tab = TabsMng.getBrowserTabByNotificationId(notificationId);
    var visited = tab.getLastVisited();
    console.log(visited);
    callback(visited);
};

function establishPlusPrivacyWebsiteCommunication(tabId){
    insertJavascriptFile(tabId, "operando/modules/communication/message-relay.js");
}

function checkConnectWithSNApisUrls(tabId, changeInfo, tab){

    if(changeInfo.url && urlIsApiUrl(changeInfo.url)==true){
        chrome.tabs.insertCSS(tabId, {file: "operando/modules/pfb/css/style.css", runAt:"document_start"},function(){
            var notificationId = new Date().getTime();
            var extensionId = chrome.runtime.id;
            chrome.tabs.executeScript(tabId, {code:"var notificationId="+notificationId+";var extensionId='"+extensionId+"';"}, function(){
                chrome.tabs.executeScript(tabId, {file:'operando/modules/pfb/hideSNContent.js',runAt:"document_start"}, function(){
                    TabsMng.getTab(tabId).setNotification(notificationId);
                });
            });
        });
    }
}

function init() {
    chrome.tabs.query({url: "*://" + ExtensionConfig.WEBSITE_HOST + "/*"}, function (tabs) {
        tabs.forEach(function (tab) {
            establishPlusPrivacyWebsiteCommunication(tab.id);
        });
    });
}

function urlIsApiUrl(url){

    var facebookPattern = new RegExp("facebook.com\/((v[0-9]{1,2}\.[0-9]{1,2})|(dialog\/oauth))");
    switch(true){
        case url.indexOf("api.twitter.com/oauth/")>=0: return true; break;
        case url.indexOf("accounts.google.com/signin/oauth/")>=0: return true; break;
        case url.indexOf("linkedin.com/uas/oauth2/")>=0: return true; break;
        case facebookPattern.test(url): return true; break;
        default: return false;
    }
}

function isGoodToAddInHistory(url){
    if (url) {
        if (url.indexOf("google.com") == -1 &&
            url.indexOf("facebook.com") == -1 &&
            url.indexOf("linkedin.com") == -1 &&
            url.indexOf("twitter.com") == -1) {
            return true;
        }
    }
    return false;
}

chrome.webNavigation.onHistoryStateUpdated.addListener(function (details) {
    var tabId = details.tabId;
    if (isGoodToAddInHistory(details.url)) {
        TabsMng.getTab(tabId).addUrlInHistory(details.url);
    }

});

var TabsMng = exports.TabsManager = new TabsManager();
bus.registerService(exports.TabsManager.__proto__);

