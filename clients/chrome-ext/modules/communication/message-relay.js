var port = chrome.runtime.connect({name:"PLUSPRIVACY_WEBSITE"});

port.onMessage.addListener(function (data) {
    var event = new CustomEvent("messageFromExtension",	{
        detail: {
            message: data.message,
            action: data.action
        },
        bubbles: true,
        cancelable: true
    });
    document.dispatchEvent(event);
});


var messageEventHandler = function(event){
    console.log(event);
    // We only accept messages from ourselves
    if (event.source != window)
        return;

    if (event.data.type && (event.data.type == "FROM_WEBSITE")) {
        port.postMessage(event.data);
    }
}

window.addEventListener("message", messageEventHandler, false);

port.onDisconnect.addListener(function(){
    var event = new CustomEvent("relayIsDown",	{
        bubbles: true,
        cancelable: true
    });
    document.dispatchEvent(event);

    window.removeEventListener("message", messageEventHandler)
});


(function(){
    var event = new CustomEvent("relayIsReady",	{
        bubbles: true,
        cancelable: true
    });
    document.dispatchEvent(event);
})();