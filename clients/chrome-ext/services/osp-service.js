angular.module('osp')
    .factory("ospService", ["messengerService", '$q', function (messengerService, $q) {

        var ospSettingsConfig = {};

        function generateAngularForm(ospname) {
            var schema = {
                type: "object"
            }

            schema.properties = {};
            for (var v in ospSettingsConfig[ospname]) {
                var conf = ospSettingsConfig[ospname][v];

                var availableSettings = conf["read"].availableSettings;
                var jquerySelector = conf["read"].jquery_selector;

                if (Object.keys(jquerySelector).length !== 0 && availableSettings) {
                    var settingEnum = [];
                    for (var key in availableSettings) {
                        settingEnum.push({
                            value: key,
                            name: availableSettings[key].name
                        })
                    }
                    schema.properties[v] = {
                        title: conf["read"].name,
                        type: "string",
                        enum: conf["read"].availableSettings ? settingEnum : ["Yes", "No"]

                    };
                }
            }
            return schema;
        }


        function getOSPSettings(callback, ospname) {

            loadOSPSettings(function (ospSettingsConfig) {
                if (!ospname) {
                    callback(ospSettingsConfig);
                }
                else {
                    callback(ospSettingsConfig[ospname]);
                }
            })
        }


        function getSettingKeyValue(osp, settingKey, settingValue) {

            /**
             * write settings are more close to what we read
             */
            var availableSettings = ospSettingsConfig[osp][settingKey].write.availableSettings;

            if (!availableSettings) {
                availableSettings = ospSettingsConfig[osp][settingKey].read.availableSettings;
            }

            for (key in availableSettings) {
                console.log(key, availableSettings[key].name);
                if (availableSettings[key].name === settingValue) {
                    console.log(key);
                    return key;
                }
            }
            return settingValue;
        }

        function getOSPs(callback) {
            loadOSPSettings(function () {
                var osps = [];
                for (var v in ospSettingsConfig) {
                    osps.push(v);
                }
                callback(osps);
            })
        }

        function setOSPSettings(ospConfigs) {
            ospSettingsConfig = ospConfigs;
        }

        getUserSettings = function (callback) {
            chrome.storage.local.get('sn_privacy_settings', function (settings) {
                callback(settings);
            });
        };

        setUserSetting = function (settingName, settingValue) {

            chrome.storage.local.get('sn_privacy_settings', function (settings) {

                if (!(settings instanceof Object) || Object.keys(settings).length === 0) {
                    settings = [];
                }
                else {
                    settings = settings.sn_privacy_settings;
                }

                var isNew = true;
                for (var i = 0; i < settings.length; i++) {

                    if (settings[i].settingKey == settingName) {
                        settings[i].settingValue = settingValue;
                        isNew = false;
                        break;
                    }
                }

                if (isNew == true) {
                    settings.push({settingKey: settingName, settingValue: settingValue});
                }


                chrome.storage.local.set({sn_privacy_settings: settings}, function () {
                });

                messengerService.send("saveSocialNetworkSetting", {sn_privacy_settings: settings}, function(){

                });

            });

        }

        function loadOSPSettings (callback){
            if(Object.keys(ospSettingsConfig).length == 0){
                messengerService.send("getOSPSettings",function(response){
                    var settings = response.data;
                    ospSettingsConfig = settings;
                    callback(settings);
                });
            }
            else{
                callback(ospSettingsConfig);
            }
        }


        return {
            generateAngularForm:generateAngularForm,
            getOSPSettings:getOSPSettings,
            getSettingKeyValue:getSettingKeyValue,
            getOSPs:getOSPs,
            setOSPSettings:setOSPSettings,
            getUserSettings: getUserSettings,
            setUserSetting: setUserSetting,
            loadOSPs: function () {
                var deferred = $q.defer();
                if (Object.keys(ospSettingsConfig).length > 0) {
                    deferred.resolve(ospSettingsConfig);
                }
                else {
                    messengerService.send("getOSPSettings", function (response) {
                        var settings = response.data;
                        ospSettingsConfig = settings;
                        deferred.resolve(settings);
                    });
                }

                return deferred.promise;
            }
        }

    }]);