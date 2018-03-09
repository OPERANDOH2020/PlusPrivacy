var SwarmDispatcher = (function () {
    var instance;
    var callbacks = {};

    function init() {

        return {
            subscribeToSwarmResult: function (id, callbck) {
                callbacks[id] = callbck;
            },
            notifySubscribers: function (id, data) {
                if (callbacks[id]) {
                    callbacks[id](data);
                    delete callbacks[id];
                }
            }
        }
    }

    return {
        getInstance: function () {
            if (!instance) {
                instance = init();
            }
            return instance;
        }
    };
})();

exports.swarmDispatcher = SwarmDispatcher.getInstance();
