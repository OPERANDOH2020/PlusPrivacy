function wrapper(baseMessage /* , [paramKeys] */)
{
    var paramKeys = [];
    for (var i = 1; i < arguments.length; i++)
        paramKeys.push(arguments[i]);

    return function(/* [paramValues], callback */)
    {
        var message = Object.create(null);
        for (var key in baseMessage)
            if (baseMessage.hasOwnProperty(key))
                message[key] = baseMessage[key];

        var paramValues = [];
        var callback;

        if (arguments.length > 0)
        {
            var lastArg = arguments[arguments.length - 1];
            if (typeof lastArg == "function")
                callback = lastArg;

            for (var i = 0; i < arguments.length - (callback ? 1 : 0); i++)
                message[paramKeys[i]] = arguments[i];
        }

        ext.backgroundPage.sendMessage(message, callback);
    };
}

var removeSubscription = wrapper({type: "subscriptions.remove"}, "url");
var getPref = wrapper({type: "prefs.get"}, "key");