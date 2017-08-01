angular.module('app')
    .factory("ospService", ["connectionService", '$q', function (connectionService, $q) {

        var ospSettingsConfig = {};

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

            var availableSettings = ospSettingsConfig[osp][settingKey].write.availableSettings;

            if (!availableSettings) {
                availableSettings = ospSettingsConfig[osp][settingKey].read.availableSettings;
            }

            for (key in availableSettings) {
                console.log(key, availableSettings[key].name);
                if (availableSettings[key].name === settingValue) {
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

        function loadOSPSettings (callback){
            if(Object.keys(ospSettingsConfig).length == 0){
                connectionService.getOSPSettings(function(response){
                    var settings = response;
                    ospSettingsConfig = settings;
                    callback(settings);
                });
            }
            else{
                callback(ospSettingsConfig);
            }
        }


        return {
            getOSPSettings:getOSPSettings,
            getSettingKeyValue:getSettingKeyValue,
            getOSPs:getOSPs,
            setOSPSettings:setOSPSettings,
            getUserSettings: getUserSettings,
            loadOSPs: function () {
                var deferred = $q.defer();
                if (Object.keys(ospSettingsConfig).length > 0) {
                    deferred.resolve(ospSettingsConfig);
                }
                else {
                    connectionService.getOSPSettings(function (response) {
                        var settings = response;
                        ospSettingsConfig = settings;
                        deferred.resolve(settings);
                    });
                }

                return deferred.promise;
            }
        }

    }]);