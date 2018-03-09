var util = require("swarmcore");
var adapterPort = 3000;
var adapterHost = "localhost";
var assert = require('double-check').assert;

exports.transformations = {
    getOSPSettings: {
        method: 'get',
        params: [],
        path: '/social-networks/privacy-settings',
        code: function (callback) {
            var uuid = require('uuid');
            thisAdapter.myUUID = uuid.v1();
            //TODO register UIID in dispatcher
            var swarmDispatcher = getSwarmDispatcher();

            return new Promise(function (resolve, reject) {
                swarmDispatcher.subscribeToSwarmResult(thisAdapter.myUUID, function (data) {
                    resolve(JSON.stringify(data));
                });

                startSwarm("PrivacyWizardSwarm.js", 'getOSPSettings');
            }).then(function (data) {
                callback(data);
            });
        }
    }
};