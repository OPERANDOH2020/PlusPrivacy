
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

            var swarmDispatcher = getSwarmDispatcher();

            swarmDispatcher.subscribeToSwarmResult(thisAdapter.myUUID, function(data){
                console.log(data);
            });

            startSwarm("PrivacyWizardSwarm.js", 'getOSPSettings');




            /*var client = util.createClient(adapterHost, adapterPort, "testLoginUser", "ok", "testTenant", "testCtor");
            client.startSwarm("PrivacyWizardSwarm.js", 'getOSPSettings');

            return new Promise(function (resolve, reject) {
                swarmHub.on("PrivacyWizardSwarm.js", "gotOSPSettings", function (swarm) {
                    resolve(JSON.stringify(swarm.ospSettings));
                });
            }).then(function (data) {
                client.logout();
                callback(data);
            });*/

        }
    }
};