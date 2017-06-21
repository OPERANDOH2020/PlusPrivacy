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
        var facebookTabId = null;
        var linkedinTabId = null;
        var twitterTabId = null;

        function increaseFacebookPrivacy(settings, callback, jobFinished) {
            chrome.tabs.create({url: FACEBOOK_PRIVACY_URL, "selected": false}, function (tab) {
                facebookTabId = tab.id;
                chrome.runtime.sendMessage({
                    message: "waitForAPost",
                    template: {
                        "__req": null,
                        "__dyn": null,
                        "__a": null,
                        "fb_dtsg": null,
                        "__user": null,
                        "ttstamp": null,
                        "__rev": null
                    }
                }, function (response) {
                    messengerService.send("insertFacebookIncreasePrivacyScript", {
                        code: "window.FACEBOOK_PARAMS = " + JSON.stringify(response.template),
                        tabId: facebookTabId
                    });
                });
            });
            var handleFacebookMessages = function(msg){
                if (msg.data.status == "waitingFacebookCommand") {
                    messengerService.send("sendMessageToFacebook",{sendToPort:"applyFacebookSettings",command: "applySettings", settings: settings});

                } else {
                    if (msg.data.status == "settings_applied") {
                        jobFinished();
                        messengerService.off("facebookMessage",handleFacebookMessages);
                        chrome.tabs.remove(facebookTabId);
                    }
                    else {
                        if (msg.data.status == "progress") {
                            console.log(msg.data.progress);
                            callback("facebook", msg.data.progress, settings.length);
                        }
                    }
                }
            };

            messengerService.on("facebookMessage", handleFacebookMessages);

        }

        function  increaseLinkedInPrivacy(settings, callback, jobFinished) {
            chrome.tabs.create({url: LINKEDIN_PRIVACY_URL, "selected": false}, function (tab) {
                linkedinTabId = tab.id;
                chrome.runtime.sendMessage({
                    message: "waitForAPost",
                    template: {
                        "__req": null,
                        "__dyn": null,
                        "__a": null,
                        "fb_dtsg": null,
                        "__user": null,
                        "ttstamp": null,
                        "__rev": null
                    }
                }, function (response) {

                    messengerService.send("insertLinkedinIncreasePrivacyScript", {tabId:linkedinTabId});

                });
            });

            var handleLinkedinMessages = function(msg){
                if (msg.data.status == "waitingLinkedinCommand") {
                    messengerService.send("sendMessageToLinkedin",{sendToPort:"applyLinkedinSettings",command: "applySettings", settings: settings});

                } else {
                    if (msg.data.status == "settings_applied") {
                        jobFinished();
                        messengerService.off("linkedinMessage",handleLinkedinMessages);
                        chrome.tabs.remove(linkedinTabId);
                    }
                    else {
                        if (msg.data.status == "progress") {
                            console.log(msg.data.progress);
                            callback("linkedin", msg.data.progress, settings.length);
                        }
                    }
                }
            };

            messengerService.on("linkedinMessage", handleLinkedinMessages);

        }

        function increaseTwitterPrivacy(settings, callback, jobFinished) {

            chrome.tabs.getCurrent(function(currentTab){


                chrome.tabs.create({url: TWITTER_PRIVACY_URL, "selected": false}, function (tab) {
                    twitterTabId = tab.id;
                    messengerService.send("insertTwitterIncreasePrivacyScript", {tabId:twitterTabId});
                });

                var handleTwitterMessages = function(msg){
                    if (msg.data.status == "waitingTwitterCommand") {
                        messengerService.send("sendMessageToTwitter",{sendToPort:"applyTwitterSettings",command: "applySettings", settings: settings});

                    } else {
                        if (msg.data.status == "settings_applied") {
                            jobFinished();
                            messengerService.off("twitterMessage",handleTwitterMessages);
                            chrome.tabs.remove(twitterTabId);
                        }
                        else {
                            if (msg.data.status == "progress") {
                                console.log(msg.data.progress);
                                callback("twitter", msg.data.progress, settings.length);
                            } else if(msg.data.status == "giveMeCredentials") {
                                chrome.tabs.update(twitterTabId, {active: true});
                            } else if(msg.data.status=="takeMeBackInExtension"){
                                chrome.tabs.update(currentTab.id, {active: true});
                            }
                        }
                    }
                };

                messengerService.on("twitterMessage", handleTwitterMessages);


            });



        }


        var secureAccount = function (desiredSettings, callback, completedCallback) {

            var desiredSettings = desiredSettings.sort(function (a, b) {
                return a - b
            });


            ospService.getOSPSettings(function (settings) {

                var settingsToBeApplied = {};
                for (var i = 0; i < desiredSettings.length; i++) {
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

        }

        function startApplyingSettings(settings, callback, completedCallback) {

            var jobsNumber = Object.keys(settings).length;

            if(jobsNumber === 0){
                completedCallback();
            }

            var jobFinished = function(){
                jobsNumber --;
                if(jobsNumber === 0){
                    completedCallback();
                }
            }

            for (ospname in settings) {
                switch (ospname) {
                    case "facebook":
                        increaseFacebookPrivacy(settings[ospname],callback, jobFinished);
                        break;
                    case "linkedin":
                        increaseLinkedInPrivacy(settings[ospname],callback, jobFinished);
                        break;
                    case "twitter":
                        increaseTwitterPrivacy(settings[ospname],callback, jobFinished);
                }
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
        }

        return {
            prepareSettings:prepareSettings,
            secureAccount: secureAccount,
            maximizeEnforcement:maximizeEnforcement,
            applySettings:startApplyingSettings,
            applyFacebookSettings:increaseFacebookPrivacy,
            applyLinkedInSettings:increaseLinkedInPrivacy,
            applyTwitterSettings:increaseTwitterPrivacy

        }

    }]);
