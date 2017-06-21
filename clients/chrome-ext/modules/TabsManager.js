var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;
var SyncPersistence = require("SynchronizedPersistence").syncPersistence;


var BrowserTab = function (tab){
    this.tab = tab;
    this.isActive = false;
    this.notificationId = null;
    this.hasOffers = false;
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
    setWebsiteOffers:function(value){
        this.hasOffers = value;
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
    }
    function onRemovedListener(tabId) {
        delete self.browserTabs[tabId];
    }

    chrome.tabs.onCreated.addListener(function (tab){
        self.browserTabs[tab.id]= new BrowserTab(tab);
    });

    chrome.webNavigation.onCreatedNavigationTarget.addListener(function (details){
        var parentTab = self.getTab(details.sourceTabId);
            if(parentTab){
                self.getTab(details.tabId).setWebsiteOffers(parentTab.hasOffers);
            }
    });

    chrome.tabs.onUpdated.addListener(function(tabId,changeInfo,tab){
        onUpdatedListener(tabId,changeInfo,tab);

        if(self.getTab(tabId).hasOffers === false){
            checkConnectWithSNApisUrls(tabId,changeInfo,tab);
        }

        if (tab.url) {
            if (changeInfo.status === "complete" && tab.url.indexOf(ExtensionConfig.WEBSITE_HOST) != -1) {
                establishPlusPrivacyWebsiteCommunication(tabId);
            }
            if (authenticationService.isLoggedIn()) {
                if (changeInfo.status === "complete" && tab.url.indexOf("http") != -1) {
                    self.suggestSubstituteIdentities(tab.id);
                    self.suggestPrivacyForBenefits(tab);
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
}

TabsManager.prototype.suggestSubstituteIdentities=function(tabId){
    injectScript(tabId, "operando/modules/identity/input-track.js", ["jQuery","Tooltipster","UserPrefs","DOMElementProvider"], function(){
        insertCSS(tabId,"operando/assets/css/change-identity.css");
        insertCSS(tabId,"operando/utils/tooltipster/tooltipster.bundle.min.css");
        insertCSS(tabId,"operando/utils/tooltipster/tooltipster-plus-privacy.css");
    });
}

TabsManager.prototype.suggestPrivacyForBenefits = function (tab) {

    var self = this;
    var pfbHandler = swarmHub.startSwarm("pfb.js", "getWebsiteOffer", tab.url);
    pfbHandler.onResponse("success", function (swarm) {

        var offer = swarm.offers[0];
        self.getTab(tab.id).setWebsiteOffers(true);

        SyncPersistence.exists("PfbNotificationsDismissed", "offerId", offer.offerId, function (existence) {
            if (existence === false) {
                chrome.notifications.create("PfB#" + offer.offerId, {
                    type: "image",
                    iconUrl: "/operando/assets/images/icons/detailed/abp-64.png",
                    title: offer.name,
                    contextMessage: "Privacy deal",
                    message: offer.description,
                    imageUrl: "data:image/png;base64," + offer.logo,
                    requireInteraction: true,
                    buttons: [{
                        title: "Accept Deal",
                        iconUrl: "/operando/assets/images/icons/accept_offer.png"

                    }, {
                        title: "Deny Offer",
                        iconUrl: "/operando/assets/images/icons/reject_offer.png"
                    }]

                }, function () {

                });

                /*chrome.tabs.get(swarm.tabId, function (tab) {
                 if (tab) {
                 var deal = swarm.deal;
                 var tabId = tab.id;
                 insertJavascriptFile(tabId, "operando/utils/jquery.min.js");
                 insertJavascriptFile(tabId, "operando/utils/jquery.visible.min.js");
                 insertJavascriptFile(tabId, "operando/utils/webui-popover/jquery.webui-popover.js");
                 chrome.tabs.insertCSS(tabId, {file: "operando/utils/webui-popover/jquery.webui-popover.css"});
                 insertJavascriptFile(tabId, "operando/modules/pfb/operando_content.js", function () {
                 chrome.tabs.sendMessage(tabId, {pfbDeal: deal}, {}, function (response) {
                 if (response !== undefined) {
                 swarmHub.startSwarm("pfb.js", "acceptDeal", deal.serviceId);
                 }
                 });
                 });
                 }
                 });*/
            }
        })
    });

    pfbHandler.onResponse("no_pfb", function (swarm) {
        self.getTab(tab.id).setWebsiteOffers(false);
    });

}

function establishPlusPrivacyWebsiteCommunication(tabId){
    insertJavascriptFile(tabId, "operando/modules/communication/message-relay.js");
}


function checkConnectWithSNApisUrls(tabId, changeInfo, tab){

    if(changeInfo.url && urlIsApiUrl(changeInfo.url)){
        chrome.tabs.insertCSS(tabId, {file: "operando/modules/pfb/css/style.css", runAt:"document_start"},function(){
            var notificationId = new Date().getTime();
            var extensionId = chrome.runtime.id;
            chrome.tabs.executeScript(tabId, {code:"var notificationId="+notificationId+";var extensionId='"+extensionId+"'"}, function(){
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

    chrome.notifications.onButtonClicked.addListener(function(notificationId, index){
        if(notificationId.indexOf("PfB#")==0){

            var offerId = notificationId.split('PfB#')[1];
            if(index == 0){
                var acceptPfBDeal = swarmHub.startSwarm("pfb.js", "acceptDeal", offerId);
                acceptPfBDeal.onResponse("dealAccepted", function(swarm){
                    chrome.notifications.create("accepted",{
                        type:"basic",
                        iconUrl:"/operando/assets/images/icons/detailed/abp-64.png",
                        title:"Deal accepted",
                        message:"Please check your dashboard to see your reward!"
                    });
                })

            }
            else{
                chrome.notifications.create("notAccepted",{
                    type:"basic",
                    iconUrl:"/operando/assets/images/icons/detailed/abp-64.png",
                    title:"Offer not accepted!",
                    message:"You did not accept this offer. If you changed your mind please subscribe to it from dashboard!",
                    buttons:[]
                });

            }

            SyncPersistence.set("PfbNotificationsDismissed", "offerId", offerId);
            chrome.notifications.clear(notificationId);
        }

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
var TabsMng = exports.TabsManager = new TabsManager();
bus.registerService(exports.TabsManager.__proto__);

