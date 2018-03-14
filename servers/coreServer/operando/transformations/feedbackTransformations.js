exports.transformations = {
    addFeedback: {
        method: 'post',
        params: ["__body"],
        path: '/feedback/responses',
        code: function (feedbackBody, callback) {
            var swarmDispatcher = getSwarmDispatcher();
            return new Promise(function (resolve) {
                var myRequestId = swarmDispatcher.subscribeToSwarmResult(function (data) {
                    resolve(JSON.stringify(data));
                });
                startSwarm("feedback.js", 'submitFeedback',feedbackBody, myRequestId);

            }).then(function (data) {
                callback(data);
            });
        }
    },
    getFeedbackQuestions:{
        method: 'get',
        params: [],
        path: '/feedback/questions',
        code: function (callback) {

            var swarmDispatcher = getSwarmDispatcher();
            return new Promise(function (resolve) {
                var myRequestId = swarmDispatcher.subscribeToSwarmResult(function (data) {
                    resolve(JSON.stringify(data));
                });
                startSwarm("feedback.js", 'getFeedbackQuestions', myRequestId);

            }).then(function (data) {
                callback(data);
            });
        }
    }
};