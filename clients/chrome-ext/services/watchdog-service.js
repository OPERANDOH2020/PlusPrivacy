/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

operandoCore
    .factory("watchDogService", ["ospService", "messengerService", function (ospService, messengerService) {

        var FACEBOOK_PRIVACY_URL = "https://www.facebook.com/settings?tab=privacy&section=composer&view";
        var LINKEDIN_PRIVACY_URL = "https://www.linkedin.com/psettings/";
        var TWITTER_PRIVACY_URL = "https://twitter.com/settings/safety";
        var GOOGLE_PRIVACY_URL = "https://myaccount.google.com/activitycontrols";
        var facebookTabId = null;
        var linkedinTabId = null;
        var twitterTabId = null;
        var googleTabId = null;
        var callbacks = {};

        function closeTabListener(tabId, callback){

            callbacks[tabId] = callback;
            messengerService.requestNotification("onTabRemoved", tabId, function(responsedTabId){
                if(callbacks[responsedTabId]){
                    callbacks[responsedTabId]();
                    delete callbacks[responsedTabId];
                }
            });
        }

        /**
         * performing Google privacy settings
         * @param settings
         * @param callback
         * @param jobFinished
         */
        function increaseGooglePrivacy(settings, callback, jobFinished){
            var jobDone = false;
            chrome.tabs.create({url: GOOGLE_PRIVACY_URL, "selected": false}, function (tab) {
                googleTabId = tab.id;

                closeTabListener(googleTabId, function(){
                    messengerService.off("googleMessage",handleGoogleMessages);
                    if(jobDone == false){
                        callback("google", -1, settings.length);// -1 means aborted
                        jobFinished(true);//true means aborted
                    }
                });

                messengerService.send("getGoogleData",function(response){
                    messengerService.send("insertGoogleIncreasePrivacyScript", {
                        code: "window.GOOGLE_PARAMS = " + JSON.stringify(response.data),
                        tabId:googleTabId
                    });
                });


            });
            callback("google", 0, settings.length);
            var handleGoogleMessages = function(msg){
                if (msg.data.status == "waitingGoogleCommand") {
                    messengerService.send("sendMessageToGoogle",{sendToPort:"applyGoogleSettings",command: "applySettings", settings: settings});

                } else {
                    if (msg.data.status == "settings_applied") {
                        jobFinished();
                        jobDone = true;
                        messengerService.off("googleMessage",handleGoogleMessages);
                        //chrome.tabs.remove(googleTabId);
                        googleTabId = null;
                    }
                    else {
                        if (msg.data.status == "progress") {
                            callback("google", msg.data.progress, settings.length);
                        }
                    }
                }
            };

            messengerService.on("googleMessage", handleGoogleMessages);
        }


        function increaseFacebookPrivacy(settings, callback, jobFinished) {

            var jobDone = false;
            chrome.tabs.create({url: FACEBOOK_PRIVACY_URL, "selected": false}, function (tab) {
                facebookTabId = tab.id;
                closeTabListener(facebookTabId, function(){
                    if(jobDone == false){
                        messengerService.off("facebookMessage",handleFacebookMessages);
                        callback("facebook", -1, settings.length);// -1 means aborted
                        jobFinished(true);//true means aborted
                    }
                });

                chrome.runtime.sendMessage({
                    message: "waitForAPost",
                    template: {
                        "__req": null,
                        "__dyn": null,
                        "__a": null,
                        "fb_dtsg": null,
                        "__user": null,
                        "__af": null,
                        "__rev": null,
                        "jazoest":null,
                        "__spin_r":null,
                        "__spin_b":null,
                        "__spin_t":null,
                        "__be":null,
                        "__pc":null
                    }
                }, function (response) {
                    messengerService.send("insertFacebookIncreasePrivacyScript", {
                        code: "window.FACEBOOK_PARAMS = " + JSON.stringify(response.template),
                        tabId: facebookTabId
                    });
                });
            });

            callback("facebook", 0, settings.length);
            var handleFacebookMessages = function(msg){
                if (msg.data.status == "waitingFacebookCommand") {
                    messengerService.send("sendMessageToFacebook",{sendToPort:"applyFacebookSettings",command: "applySettings", settings: settings});

                } else {
                    if (msg.data.status == "settings_applied") {
                        jobFinished();
                        messengerService.off("facebookMessage",handleFacebookMessages);
                        chrome.tabs.remove(facebookTabId);
                        jobDone = true;
                        facebookTabId = null;
                    }
                    else {
                        if (msg.data.status == "progress") {
                            callback("facebook", msg.data.progress, settings.length);
                        }
                    }
                }
            };

            messengerService.on("facebookMessage", handleFacebookMessages);

        }

        function  increaseLinkedInPrivacy(settings, callback, jobFinished) {
            var jobDone = false;
            chrome.tabs.create({url: LINKEDIN_PRIVACY_URL, "selected": false}, function (tab) {
                linkedinTabId = tab.id;

                closeTabListener(linkedinTabId, function(){
                    messengerService.off("linkedinMessage",handleLinkedinMessages);
                    if(jobDone == false){
                        callback("linkedin", -1, settings.length);// -1 means aborted
                        jobFinished(true);//true means aborted
                    }
                });

                messengerService.send("insertLinkedinIncreasePrivacyScript", {tabId:linkedinTabId});
            });
            callback("linkedin", 0, settings.length);
            var handleLinkedinMessages = function(msg){
                if (msg.data.status == "waitingLinkedinCommand") {
                    messengerService.send("sendMessageToLinkedin",{sendToPort:"applyLinkedinSettings",command: "applySettings", settings: settings});

                } else {
                    if (msg.data.status == "settings_applied") {
                        jobFinished();
                        jobDone = true;
                        messengerService.off("linkedinMessage",handleLinkedinMessages);
                        chrome.tabs.remove(linkedinTabId);
                        linkedinTabId = null;
                    }
                    else {
                        if (msg.data.status == "progress") {
                            callback("linkedin", msg.data.progress, settings.length);
                        }
                    }
                }
            };

            messengerService.on("linkedinMessage", handleLinkedinMessages);

        }

        function increaseTwitterPrivacy(settings, callback, jobFinished, passwordWasPromptedCallback) {

            var jobDone = false;
            chrome.tabs.getCurrent(function(currentTab){
                chrome.tabs.create({url: TWITTER_PRIVACY_URL, "selected": false}, function (tab) {
                    twitterTabId = tab.id;
                    closeTabListener(twitterTabId, function(){
                        if(jobDone == false){
                            messengerService.off("twitterMessage",handleTwitterMessages);
                            callback("twitter", -1, settings.length);// -1 means aborted
                            jobFinished(true);//true means aborted
                            if(passwordWasPromptedCallback){
                                passwordWasPromptedCallback();
                            }
                        }
                    });
                    messengerService.send("insertTwitterIncreasePrivacyScript", {tabId:twitterTabId});
                });

                callback("twitter", 0, settings.length);

                var handleTwitterMessages = function(msg){
                    if (msg.data.status == "waitingTwitterCommand") {
                        messengerService.send("sendMessageToTwitter",{sendToPort:"applyTwitterSettings",command: "applySettings", settings: settings});

                    } else {
                        if (msg.data.status == "settings_applied") {
                            jobFinished();
                            messengerService.off("twitterMessage",handleTwitterMessages);
                            chrome.tabs.remove(twitterTabId);
                            twitterTabId = null;
                            jobDone = true;
                        }
                        else {
                            if (msg.data.status == "progress") {
                                callback("twitter", msg.data.progress, settings.length);
                            } else if(msg.data.status == "giveMeCredentials") {
                                chrome.tabs.update(twitterTabId, {active: true});
                            } else if(msg.data.status=="takeMeBackInExtension"){
                                chrome.tabs.update(currentTab.id, {active: true});
                                if(passwordWasPromptedCallback){
                                    passwordWasPromptedCallback();
                                }
                            } else if(msg.data.status == "abortTwitter") {
                                chrome.tabs.remove(twitterTabId);
                                twitterTabId = null;
                            }

                        }
                    }
                };

                messengerService.on("twitterMessage", handleTwitterMessages);

            });
        }

        var secureAccount = function (desiredSettingsArray, callback, completedCallback) {

            var desiredSettings = desiredSettingsArray.sort(function (a, b) {
                return a - b;
            });

            ospService.getOSPSettings(function (settings) {

                var settingsToBeApplied = {};
                for(var i = 0; i < desiredSettings.length; i++) {
                    var found = false;
                    for (ospname in settings) {
                        if (found === false) {

                            for (setting in settings[ospname]) {

                                if (typeof settings[ospname][setting].read.availableSettings !== "object") {
                                    continue;
                                }
                                var result = Object.keys(settings[ospname][setting].read.availableSettings).filter(function (s) {
                                    return parseInt(settings[ospname][setting].read.availableSettings[s].index) == parseInt(desiredSettings[i]);
                                });

                                if (result.length > 0) {

                                    if (!settingsToBeApplied[ospname]) {
                                        settingsToBeApplied[ospname] = [];
                                    }

                                    settingsToBeApplied[ospname].push(prepareSettings(settings[ospname][setting].write, result[0]));

                                    found = true;
                                    break;
                                }
                            }
                        }
                    }
                }

                startApplyingSettings(settingsToBeApplied, callback, completedCallback);
            });

        };

        function startApplyingSettings(settings, callback, completedCallback) {

            var jobsNumber = Object.keys(settings).length;
            var successfullyFinished = 0;

            if(jobsNumber === 0){
                completedCallback();
            }

            var jobFinished = function(aborted){
                if(aborted !== true){
                    successfullyFinished ++;
                }
                jobsNumber --;
                if(jobsNumber === 0){
                    completedCallback(successfullyFinished);
                }
            }

            function checkSettings(){
                for (ospname in settings) {
                    switch (ospname) {
                        case "facebook":
                            increaseFacebookPrivacy(settings[ospname],callback, jobFinished);
                            break;
                        case "linkedin":
                            increaseLinkedInPrivacy(settings[ospname],callback, jobFinished);
                            break;
                        case "google":
                            increaseGooglePrivacy(settings[ospname],callback, jobFinished);
                            break;
                    }
                }
            }

            if(Object.keys(settings).indexOf("twitter")>-1){
                increaseTwitterPrivacy(settings["twitter"],callback, jobFinished, checkSettings);
            }
            else{
                checkSettings();
            }

        }

        function prepareSettings(settingToBeApplied, settingKey) {

            var name = settingToBeApplied.name;
            var urlToPost = settingToBeApplied.url_template;
            var page = settingToBeApplied.page;
            var data = settingToBeApplied.data ? settingToBeApplied.data : {};

            var params = settingToBeApplied.availableSettings[settingKey].params;

            if (params) {
                for (key in params) {
                    var param = params[key];

                    if (typeof param.value !== 'undefined') {
                        urlToPost = urlToPost.replace("{" + param.placeholder + "}", param.value);
                    }
                    /**
                     * else we replace later when we are in SN page and will take the value from there
                     */
                }
            }

            if (settingToBeApplied.availableSettings[settingKey].data) {
                var specificData = settingToBeApplied.availableSettings[settingKey].data;
                for (var attrname in specificData) {
                    data[attrname] = specificData[attrname];
                }
            }

            var setting = {
                name: name,
                type: settingToBeApplied.type,
                url: urlToPost,
                params: settingToBeApplied.availableSettings[settingKey].params,
                page: page,
                data: data
            };
            return setting;

        }

        var maximizeEnforcement = function(availableOSPs, callback, completedCallback){

            ospService.getOSPSettings(function (settings) {

                var settingsToBeApplied = {};

                for (ospname in settings) {
                    if (availableOSPs.indexOf(ospname)>-1) {

                        for (setting in settings[ospname]) {

                            var s = settings[ospname][setting];

                            if (s.write.recommended && s.write.availableSettings && s.write.availableSettings[s.write.recommended]) {

                                if (!settingsToBeApplied[ospname]) {
                                    settingsToBeApplied[ospname] = [];
                                }

                                settingsToBeApplied[ospname].push(prepareSettings(s.write, s.write.recommended));
                            }

                        }
                    }
                }

                startApplyingSettings(settingsToBeApplied, callback, completedCallback);

            });
        };

        var cancelEnforcement = function(callback){
            callbacks = {};
            messengerService.off("facebookMessage");
            messengerService.off("linkedinMessage");
            messengerService.off("twitterMessage");
            messengerService.off("googleMessage");

            var tabIdsToBeRemoved = [twitterTabId,facebookTabId,linkedinTabId];
            var sequence = Promise.resolve();
            tabIdsToBeRemoved.forEach(function (tabId, index) {
                sequence = sequence.then(function () {
                    return removeTab(tabId);
                }).then(function (result) {
                    if (callback) {
                        callback();
                    }
                });
            });


            var removeTab = function(tabId){
                return new Promise(function (resolve, reject) {
                    if(tabId){
                        chrome.tabs.get(tabId, function(tab){
                            if (chrome.runtime.lastError) {
                                console.log("Tab does not exists");
                                resolve();
                            }
                            else{
                                chrome.tabs.remove(tab.id,resolve);
                            }
                        });
                    }

                });

            };
        };

        return {
            prepareSettings:prepareSettings,
            secureAccount: secureAccount,
            maximizeEnforcement:maximizeEnforcement,
            applySettings:startApplyingSettings,
            applyFacebookSettings:increaseFacebookPrivacy,
            applyLinkedInSettings:increaseLinkedInPrivacy,
            applyTwitterSettings:increaseTwitterPrivacy,
            applyGoogleSettings:increaseGooglePrivacy,
            cancelEnforcement:cancelEnforcement

        }

    }]);
