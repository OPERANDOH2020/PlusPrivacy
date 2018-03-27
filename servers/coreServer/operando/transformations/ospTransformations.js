exports.transformations = {
    getOSPSettings: {
        method: 'get',
        params: ["osp"],
        path: '/social-networks/privacy-settings/$osp',
        code: function (osp, callback) {

            var swarmDispatcher = getSwarmDispatcher();
            return new Promise(function (resolve) {
                var myRequestId = swarmDispatcher.subscribeToSwarmResult(function (data) {
                    resolve(JSON.stringify(data));
                });
                startSwarm("PrivacyWizardSwarm.js", 'getOSPSettings',osp, myRequestId);

            }).then(function (data) {
                callback(data);
            });
        }
    }
};