exports.transformations = {
    getOSPSettings: {
        method: 'get',
        params: [],
        path: '/social-networks/privacy-settings',
        code: function (callback) {

            var swarmDispatcher = getSwarmDispatcher();
            return new Promise(function (resolve) {
                thisAdapter.myUUID = swarmDispatcher.subscribeToSwarmResult(function (data) {
                    resolve(JSON.stringify(data));
                });
                startSwarm("PrivacyWizardSwarm.js", 'getOSPSettings');
            }).then(function (data) {
                callback(data);
            });
        }
    }
};