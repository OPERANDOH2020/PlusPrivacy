var SwarmDispatcher = (function () {
    var instance;

    var ceva;

    function init(){
        console.log("INITIALIZAT");
        return {
            subscribeToSwarmResult: function (id, callbck) {
                console.log(id);
                ceva = id;
            },
            notifySubscribers: function (id, data) {
                console.log("Acel ceva",ceva);
                console.log("notified");
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
