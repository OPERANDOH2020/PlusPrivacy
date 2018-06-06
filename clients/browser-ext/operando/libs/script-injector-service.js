var bus = require("bus-service").bus;
var facebookCallback = null;
var linkedinCallback = null;
var twitterCallback = null;
var googleCallback = null;
var googleActivityCallback = null;
var scriptInjectorService = exports.scriptInjectorService = {

    insertFacebookIncreasePrivacyScript: function (data) {
        chrome.tabs.executeScript(data.tabId, {
            code: data.code
        }, function () {
            insertCSS(data.tabId, "assets/css/feedback.css");
            injectScript(data.tabId, "modules/osp/writeFacebookSettings.js", ["FeedbackProgress", "jQuery"]);
        });
    },

    insertLinkedinIncreasePrivacyScript:function(data){
        injectScript(data.tabId, "modules/osp/writeLinkedinSettings.js", ["FeedbackProgress", "jQuery"], function(){
            insertCSS(data.tabId, "assets/css/feedback.css");
        });
    },

    insertTwitterIncreasePrivacyScript:function(data){
        chrome.tabs.executeScript(data.tabId, {
            code: data.code
        }, function () {
            insertCSS(data.tabId, "assets/css/feedback.css");
            injectScript(data.tabId, "modules/osp/writeTwitterSettings.js", ["FeedbackProgress", "jQuery","Tooltipster"]);
        });
    },

    insertGoogleIncreasePrivacyScript:function(data){
        chrome.tabs.executeScript(data.tabId, {
            code: data.code
        },function(){
            injectScript(data.tabId, "modules/osp/writeGoogleSettings.js", ["FeedbackProgress", "jQuery"], function(){
                insertCSS(data.tabId, "assets/css/feedback.css");
            });
        });
    },

    insertActivityControlsWizardFiles:function(data){
        injectScript(data.tabId,"modules/osp/activityControlsWizard.js",["jQuery"]);
        insertCSS(data.tabId, "assets/css/activityControlsWizard.css");

        var backgroundCSS =".modal-header h2{background-image:url('"+chrome.runtime.getURL("/assets/images/icons/pp-42-logo.png")+"')}";
        backgroundCSS+=".modal-body {background-image:url('"+chrome.runtime.getURL("assets/images/google-logo.png")+"')}";
        backgroundCSS+=".downArrow span {background-image:url('"+chrome.runtime.getURL("assets/images/icons/pp-42-logo-orange.png")+"')}";
        insertCSSCode(data.tabId, backgroundCSS);
    },

    facebookMessage : function (callback){
        facebookCallback = callback;
    },

    linkedinMessage:function(callback){
        linkedinCallback = callback;
    },
    twitterMessage: function(callback){
        twitterCallback = callback;
    },
    googleMessage:function(callback){
        googleCallback = callback;
    },
    googleActivityMessage:function(callback){
        googleActivityCallback = callback;
    },
    waitingFacebookCommand:function(instructions){
        facebookCallback (instructions);
    },
    waitingLinkedinCommand:function(instructions){
        linkedinCallback (instructions);
    },
    waitingTwitterCommand:function(instructions){
        twitterCallback(instructions);
    },
    waitingGoogleCommand : function(instructions){
        googleCallback(instructions);
    },
    waitingGoogleActivityCommand : function(instructions){
        googleActivityCallback(instructions);
    }

};
bus.registerService(scriptInjectorService);
