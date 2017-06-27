angular.module('pspApp').factory("messengerService", function () {

    var MessengerService = (function () {

        function MessengerService() {

        }

        var callbacks = {};
        var events = {};
        var relayIsReady = false;
        var waitingMessages = [];

        MessengerService.prototype.relayMessage = function (message) {

            if (relayIsReady) {
                window.postMessage(message, "*");
            }
            else {
                waitingMessages.push(message);
            }
        };

        MessengerService.prototype.on = function (event, callback) {
            if (!events[event]) {
                events[event] = [];
            }
            events[event].push(callback);
            this.relayMessage({type: "FROM_WEBSITE", action: event, message: {messageType: "SUBSCRIBER"}});
        };

        MessengerService.prototype.send = function () {
            var action = arguments[0];
            if (arguments.length == 2) {
                if (typeof arguments[1] === "function") {
                    this.relayMessage({type: "FROM_WEBSITE", action: action});

                }
            }
            else {
                this.relayMessage({type: "FROM_WEBSITE", action: action, message: arguments[1]});
            }

            if (!callbacks[action]) {
                callbacks[action] = [];
            }
            callbacks[action].push(arguments[arguments.length - 1]);
        };

        MessengerService.prototype.extensionIsActive = function () {
            return relayIsReady;
        };

        window.addEventListener("messageFromExtension", function (event) {

            if (callbacks[event.detail.action]) {
                while (callbacks[event.detail.action].length > 0) {
                    var messageCallback = callbacks[event.detail.action].pop();
                    messageCallback(event.detail.message);
                }
            }
            else if (events[event.detail.action]) {
                for (var i = 0; i < events[event.detail.action].length; i++) {
                    var eventCallback = events[event.detail.action][i];
                    eventCallback(event.detail.message);
                }
            }
        });

        window.addEventListener("relayIsReady", function (event) {
            var self = this;
            relayIsReady = true;

            waitingMessages = waitingMessages.filter(function (waitingMessage, index, array) {
                console.log(waitingMessage);
                self.relayMessage(waitingMessage);
                return (waitingMessage.message && waitingMessage.message.messageType === "SUBSCRIBER")
            });
        });

        window.addEventListener("relayIsDown", function (event) {
            relayIsReady = false;
            //alert("Connection is lost!");
        });

        return MessengerService;

    })();

    if (typeof(window.messengerService) === 'undefined' || window.messengerService === null) {
        window.messengerService = new MessengerService();
    }

    return window.messengerService;

});
