require.scopes["RegexUtils"] = (function()
{
    var exports = {};
    if (!String.prototype.unescapeHtmlChars)
    {
        String.prototype.unescapeHtmlChars = function()
        {
            var value = this;
            value = value.replace(/&amp;/g, "&");
            value = value.replace(/&quot;/g, "\"");
            value = value.replace(/&apos;/g, "'");
            value = value.replace(/&nbsp;/g, " ");
            value = value.replace(/&gt;/g, ">");
            value = value.replace(/&lt;/g, "<");
            value = value.replace(/&rlm;/g, "");
            value = value.replace(/&#(\d+);/g, function(match, number)
            {
                return String.fromCharCode(parseInt(number, 10));
            });
            value = value.replace(/&#x([0-9a-fA-F]+);/g, function(match, hex)
            {
                return String.fromCharCode(parseInt(hex, 16));
            });
            return value;
        };
    }
    RegexUtis = {
        findValueByRegex: function findValueByRegex(serviceKey, label, regex, index, data, must)
        {
            var value = this.findMultiValuesByRegex(serviceKey, label, regex, [index], data, must)[0];
            return RegexUtis.cleanAndPretty(value);
        },
        findMultiValuesByRegex: function findMultiValuesByRegex(serviceKey, label, regex, indices, data)
        {
            var rawValues = data.match(regex);
            var values = [];
            if (!rawValues)
            {
                return values;
            }
            for (var i = 0; i < indices.length; i++)
            {
                values[values.length] = rawValues[indices[i]];
            }
            return values;
        },
        findAllOccurrencesByRegex: function findAllOccurrencesByRegex(serviceKey, label, regex, index, data, processor)
        {
            var rawValues = data.match(new RegExp(regex, "g"));
            var values = [];
            if (!rawValues)
            {
                return values;
            }
            for (var i = 0; i < rawValues.length; i++)
            {
                var valueToProcess = ("" + rawValues[i]).match(regex)[index];
                if (processor)
                {
                    values[values.length] = processor(valueToProcess);
                }
                else
                {
                    values[values.length] = valueToProcess;
                }
            }
            return values;
        },
        clean: function(value)
        {
            if (value)
            {
                value = value.replace(/<[^>]*>/g, "");
            }
            return value;
        },
        prettify: function(value)
        {
            if (value)
            {
                value = value.trim();
                value = value.replace(/\s+/g, " ");
                value = value.unescapeHtmlChars();
            }
            return value;
        },
        cleanAndPretty: function(value)
        {
            return RegexUtis.prettify(RegexUtis.clean(value));
        },
        findValueByRegex_CleanAndPretty: function findValueByRegex_CleanAndPretty(serviceKey, label, regex, index, data, must)
        {
            var value = RegexUtis.findValueByRegex(serviceKey, label, regex, index, data, must);
            return RegexUtis.cleanAndPretty(value);
        },
        findValueByRegex_Pretty: function findValueByRegex_Pretty(serviceKey, label, regex, index, data, must)
        {
            var value = RegexUtis.findValueByRegex(serviceKey, label, regex, index, data, must);
            return RegexUtis.prettify(value);
        }
    };
    return exports;
})();
require.scopes["LocalRepo"] = (function()
{
    var exports = {};
    var LocalRepo = exports.LocalRepo = {};

    function updateRepo(storage, item)
    {}

    function addRepo(index)
    {}
    return exports;
})();
require.scopes["observers-pool"] = (function()
{
    var exports = {};

    function PortObserver(port)
    {
        this.port = port;
        this.observers = [];
    }
    PortObserver.prototype = {
        subscribe: function(request, fn)
        {
            this.observers.push(
                {
                    request: request,
                    fn: fn
                });
        },
        unsubscribe: function(request, fn)
        {
            this.observers = this.observers.filter(function(observer)
            {
                if (fn)
                {
                    if (observer.request === request && fn === observer.fn)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                else
                {
                    return observer.request !== request;
                }
            });
        },
        fire: function(request, status, message)
        {
            this.observers.forEach(function(observer)
            {
                if (observer.request === request)
                {
                    observer.fn.call(observer.fn, status, message);
                }
            });
        }
    };

    function PortsObserversPool()
    {
        this.observersPool = [];
    }
    PortsObserversPool.prototype = {
        registerPortObserver: function(port)
        {
            this.observersPool.push(new PortObserver(port));
        },
        getPortObservers: function(_port)
        {
            for (var i = 0; i < this.observersPool.length; i++)
            {
                if (this.observersPool[i].port === _port)
                {
                    return this.observersPool[i].observers;
                }
            }
        },
        unregisterPortObserver: function(port)
        {
            this.observersPool = this.observersPool.filter(function(portObserver)
            {
                return portObserver.port !== port;
            });
        },
        addPortRequestSubscriber: function(port, request, fn)
        {
            this.observersPool.forEach(function(observer)
            {
                if (observer.port === port)
                {
                    observer.subscribe(request, fn);
                }
            });
        },
        trigger: function(request, message)
        {
            this.observersPool.forEach(function(observer)
            {
                observer.fire(request, "success", message);
            });
        },
        findPortByName: function(name)
        {
            for (var i = 0; i < this.observersPool.length; i++)
            {
                var portObserver = this.observersPool[i];
                if (portObserver.port.name === name)
                {
                    return portObserver.port;
                }
            }
        },
        removeSubscriber: function(port, request, callback)
        {
            this.observersPool.forEach(function(observer)
            {
                if (observer.port === port)
                {
                    observer.unsubscribe(request, callback);
                }
            });
        },
        changeObserverCallback: function(request, sourceCallback, toBeChangedCallback)
        {
            this.observersPool.forEach(function(observer)
            {
                var observers = observer.observers;
                observers.forEach(function(obs)
                {
                    if (obs.request === request && obs.fn === sourceCallback)
                    {
                        obs.fn = toBeChangedCallback;
                    }
                });
            });
        }
    };
    var pop = new PortsObserversPool();
    exports.portObserversPool = pop;
    return exports;
})();
require.scopes["bus-service"] = (function()
{
    var exports = {};
    var busActions = {};
    var observers = {};
    var bus = exports.bus = {
        registerAction: function(key, callback)
        {
            if (busActions[key])
            {
                console.log("Error occurred! An action with ", key + " is already registered!");
            }
            else
            {
                busActions[key] = callback;
            }
        },
        registerService: function(service)
        {
            var self = this;
            Object.keys(service).forEach(function(key)
            {
                self.registerAction(key, service[key]);
            });
        },
        registerObservers: function()
        {
            for (var i = 0; i < arguments.length; i++)
            {
                Object.assign(observers, arguments[i]);
            }
        },
        removeObserverByCallback: function(request, fn)
        {
            if (observers[request])
            {
                observers[request].removeObserver(fn);
            }
        },
        hasAction: function(actionName)
        {
            if (busActions[actionName])
            {
                return true;
            }
            return false;
        },
        getAction: function(actionName)
        {
            return busActions[actionName];
        }
    };
    return exports;
})();
require.scopes["swarm-service"] = (function()
{
    var exports = {};
    var swarmConnection = null;
    var connectCallbacks = [];
    var reconnectCallbacks = [];
    var connectionErrorCallback = [];
    var bus = require("bus-service").bus;

    function runConnectCallbacks()
    {
        connectCallbacks.forEach(function(callback)
        {
            callback();
        });
    }

    function runReconnectCallbacks()
    {
        reconnectCallbacks.forEach(function(callback)
        {
            callback();
        });
    }

    function runConnectionErrorCallback()
    {
        connectionErrorCallback.forEach(function(callback)
        {
            callback();
        });
    }
    var swarmService = exports.swarmService = {
        initConnection: function(host, port, email, password, tenant, ctor, securityErrorFunction, errorFunction, reconnectCbk, connectCbk)
        {
            if (errorFunction)
            {
                this.onConnectionError(errorFunction);
            }
            if (reconnectCbk)
            {
                this.onReconnect(reconnectCbk);
            }
            if (connectCbk)
            {
                this.onConnect(connectCbk);
            }
            if (!swarmConnection)
            {
                swarmConnection = new SwarmClient(host, port, email, password, tenant, ctor, securityErrorFunction, runConnectionErrorCallback, runReconnectCallbacks, runConnectCallbacks);
                swarmHub.resetConnection(swarmConnection);
            }
            else
            {
                swarmConnection.tryLogin(email, password, tenant, ctor, false, securityErrorFunction, runConnectionErrorCallback, runReconnectCallbacks, runConnectCallbacks);
            }
        },
        restoreConnection: function(host, port, email, sessionId, securityErrorFunction, errorFunction, reconnectCbk, connectCbk)
        {
            if (errorFunction)
            {
                this.onConnectionError(errorFunction);
            }
            if (reconnectCbk)
            {
                this.onReconnect(reconnectCbk);
            }
            if (connectCbk)
            {
                this.onConnect(connectCbk);
            }
            swarmConnection = new SwarmClient(host, port, email, sessionId, "chromeBrowserExtension", "restoreSession", securityErrorFunction, runConnectionErrorCallback, runReconnectCallbacks, runConnectCallbacks);
            swarmHub.resetConnection(swarmConnection);
        },
        removeConnection: function()
        {
            swarmConnection.logout();
            swarmConnection = null;
            connectCallbacks = [];
            reconnectCallbacks = [];
            connectionErrorCallback = [];
        },
        onReconnect: function(callback)
        {
            reconnectCallbacks.push(callback);
        },
        onConnect: function(callback)
        {
            connectCallbacks.push(callback);
        },
        onConnectionError: function(callback)
        {
            connectionErrorCallback.push(callback);
        }
    };
    bus.registerService(swarmService);
    return exports;
})();
require.scopes["identity-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var identities = [];
    var lastUpdate = new Date();
    var oneHour = 60 * 60 * 1000;
    var listIdentitiesInProgress = false;
    var waitingForIdentitiesCallbacks = [];
    var identityService = exports.identityService = {
        generateIdentity: function(success_callback, error_callback)
        {
            var generateIdentityHandler = swarmHub.startSwarm("identity.js", "generateIdentity");
            generateIdentityHandler.onResponse("generateIdentity_success", function(swarm)
            {
                success_callback(swarm.generatedIdentity);
            });
            generateIdentityHandler.onResponse("generateIdentity_error", function(swarm)
            {
                error_callback(swarm.error);
            });
        },
        addIdentity: function(identity, success_callback, error_callback)
        {
            var addIdentityHandler = swarmHub.startSwarm("identity.js", "createIdentity", identity);
            addIdentityHandler.onResponse("createIdentity_success", function(swarm)
            {
                identities.push(swarm.identity);
                success_callback(swarm.identity);
            });
            addIdentityHandler.onResponse("createIdentity_error", function(swarm)
            {
                error_callback(swarm.error);
            });
        },
        removeIdentity: function(identity, success_callback, error_callback)
        {
            var removeIdentityHandler = swarmHub.startSwarm("identity.js", "removeIdentity", identity);
            removeIdentityHandler.onResponse("deleteIdentity_success", function(swarm)
            {
                identities = identities.filter(function(oldIdentity)
                {
                    return oldIdentity.email != identity.email;
                });
                success_callback(swarm.default_identity);
            });
            removeIdentityHandler.onResponse("deleteIdentity_error", function(swarm)
            {
                error_callback(swarm.error);
            });
        },
        listIdentities: function(callback)
        {
            function returnIdentities(identities)
            {
                while (waitingForIdentitiesCallbacks.length > 0)
                {
                    var cbk = waitingForIdentitiesCallbacks.pop();
                    cbk(identities);
                }
            }
            waitingForIdentitiesCallbacks.push(callback);
            if (listIdentitiesInProgress == false)
            {
                if (identities.length === 0 || new Date() - lastUpdate > oneHour)
                {
                    listIdentitiesInProgress = true;
                    var listIdentitiesHandler = swarmHub.startSwarm("identity.js", "getMyIdentities");
                    listIdentitiesHandler.onResponse("getMyIdentities_success", function(swarm)
                    {
                        listIdentitiesInProgress = false;
                        identities = swarm.identities;
                        lastUpdate = new Date();
                        returnIdentities(swarm.identities);
                    });
                }
                else
                {
                    returnIdentities(identities);
                }
            }
        },
        updateDefaultSubstituteIdentity: function(identity, callback)
        {
            var updateDefaultIdentityHandler = swarmHub.startSwarm("identity.js", "updateDefaultSubstituteIdentity", identity);
            updateDefaultIdentityHandler.onResponse("defaultIdentityUpdated", function(swarm)
            {
                identities.forEach(function(oldIdentity)
                {
                    oldIdentity.isDefault = oldIdentity.email === identity.email;
                });
                callback(swarm.identity);
            });
        },
        listDomains: function(callback)
        {
            var listDomainsHandler = swarmHub.startSwarm("identity.js", "listDomains");
            listDomainsHandler.onResponse("gotDomains", function(swarm)
            {
                callback(swarm.domains);
            });
        },
        clearIdentitiesList: function()
        {
            identities = [];
            listIdentitiesInProgress = false;
            waitingForIdentitiesCallbacks = [];
        }
    };
    bus.registerService(identityService);
    return exports;
})();
require.scopes["device-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var deviceService = exports.deviceService = {
        saveDeviceId: function(deviceId)
        {
            chrome.storage.local.set(
                {
                    "deviceId": deviceId
                }, function()
                {
                    chrome.cookies.set(
                        {
                            url: ExtensionConfig.SERVER_HOST_PROTOCOL + "://" + ExtensionConfig.WEBSITE_HOST,
                            name: "deviceId",
                            value: deviceId,
                            expirationDate: parseInt(Date.now() / 1000) + 946080000,
                            secure: ExtensionConfig.SERVER_HOST_PROTOCOL === "https" ? true : false
                        });
                });
        },
        getDeviceId: function(callback)
        {
            var deviceId = null;
            chrome.storage.local.get("deviceId", function(response)
            {
                if (!response.deviceId)
                {
                    chrome.cookies.getAll(
                        {
                            url: ExtensionConfig.SERVER_HOST_PROTOCOL + "://" + ExtensionConfig.WEBSITE_HOST,
                            name: "deviceId",
                            secure: ExtensionConfig.SERVER_HOST_PROTOCOL === "https" ? true : false
                        }, function(cookies)
                        {
                            if (cookies.length)
                            {
                                var cookie = cookies[0];
                                deviceId = cookie.value;
                            }
                            else
                            {
                                deviceId = (new Date()).getTime().toString(16) + Math.floor(Math.random() * 10000).toString(16);
                                deviceService.saveDeviceId(deviceId);
                            }
                            callback(deviceId);
                        });
                }
                else
                {
                    callback(response.deviceId);
                }
            });
        },
        associateUserWithDevice: function()
        {
            deviceService.getDeviceId(function(deviceId)
            {
                var handler = swarmHub.startSwarm("UDESwarm.js", "registerDeviceId", deviceId);
                handler.onResponse("device_registered", function(swarm)
                {
                    console.log("Device id is: ", deviceId);
                });
                handler.onResponse("failed", function(swarm)
                {
                    console.log(swarm.error);
                });
            });
        },
        disassociateUserWithDevice: function(callback)
        {
            deviceService.getDeviceId(function(deviceId)
            {
                var handler = swarmHub.startSwarm("UDESwarm.js", "registerDeviceId", deviceId, true);
                handler.onResponse("device_registered", function(swarm)
                {
                    callback();
                });
                handler.onResponse("failed", function(swarm)
                {
                    console.log(swarm.error);
                });
            });
        }
    };
    bus.registerService(deviceService);
    return exports;
})();
require.scopes["notification-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var deviceService = require("device-service").deviceService;
    var notificationService = exports.notificationService = {
        getNotifications: function(callback)
        {
            var getNotificationHandler = swarmHub.startSwarm("notification.js", "getNotifications");
            getNotificationHandler.onResponse("gotNotifications", function(swarm)
            {
                callback(swarm.notifications);
            });
        },
        dismissNotification: function(notificationData, callback)
        {
            var dismissNotificationHandler = swarmHub.startSwarm("notification.js", "dismissNotification", notificationData.notificationId);
            dismissNotificationHandler.onResponse("notificationDismissed", function()
            {
                callback();
            });
        },
        registerForPushNotifications: function()
        {
            var plusprivacyGCMId = ["276859564715"];
            chrome.gcm.register(plusprivacyGCMId, function(pushNotificationId)
            {
                deviceService.getDeviceId(function(deviceId)
                {
                    swarmHub.startSwarm("UDESwarm.js", "updateNotificationToken", deviceId, pushNotificationId);
                });
            });
        },
        notificationReceived: function(callback)
        {
            chrome.gcm.onMessage.addListener(callback);
        }
    };
    bus.registerService(notificationService);
    return exports;
})();
require.scopes["authentication-service"] = (function()
{
    var exports = {};
    var swarmService = require("swarm-service").swarmService;
    var identityService = require("identity-service").identityService;
    var deviceService = require("device-service").deviceService;
    var loggedIn = false;
    var authenticatedUser = {};
    var loggedInObservable = swarmHub.createObservable();
    var notLoggedInObservable = swarmHub.createObservable();
    var portObserversPool = require("observers-pool").portObserversPool;
    var bus = require("bus-service").bus;
    var authenticationService = exports.authenticationService = {
        isLoggedIn: function()
        {
            return loggedIn;
        },
        getUser: function()
        {
            return authenticatedUser;
        },
        authenticateUser: function(login_details, successFn, securityFn)
        {
            swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, login_details.email, login_details.password, "chromeBrowserExtension", "userLogin", function()
            {});
            var loginSuccessfully = function(swarm)
            {
                if (loggedIn === false)
                {
                    authenticationService.setUser(successFn);
                }
                loggedIn = swarm.authenticated;
                var daysUntilCookieExpire = 1;
                if (login_details.remember_me === true)
                {
                    daysUntilCookieExpire = 365;
                }
                Cookies.set("daysUntilCookieExpire", daysUntilCookieExpire,
                    {
                        expires: 3650
                    });
                Cookies.set("sessionId", swarm.meta.sessionId,
                    {
                        expires: daysUntilCookieExpire
                    });
                Cookies.set("userId", swarm.userId,
                    {
                        expires: daysUntilCookieExpire
                    });
                swarmHub.off("login.js", "success", loginSuccessfully);
                swarmHub.startSwarm("notification.js", "registerInZone", "Extension");
            };
            swarmHub.on("login.js", "success", loginSuccessfully);
            swarmHub.on("login.js", "failed", function loginFailed(swarm)
            {
                securityFn(swarm.error);
                swarmHub.off("login.js", "success", loginSuccessfully);
                swarmHub.off("login.js", "failed", loginFailed);
            });
        },
        registerUser: function(user, successFunction, errorFunction)
        {
            swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, CONSTANTS.GUEST_EMAIL, CONSTANTS.GUEST_PASSWORD, "chromeBrowserExtension", "userLogin", errorFunction, errorFunction);
            swarmHub.on("login.js", "success_guest", function guestLoginForUserRegistration(swarm)
            {
                swarmHub.off("login.js", "success_guest", guestLoginForUserRegistration);
                if (swarm.authenticated)
                {
                    var registerHandler = swarmHub.startSwarm("register.js", "registerNewUser", user);
                    registerHandler.onResponse("success", function(swarm)
                    {
                        successFunction("success");
                        authenticationService.logoutCurrentUser();
                    });
                    registerHandler.onResponse("error", function(swarm)
                    {
                        errorFunction(swarm.error);
                        authenticationService.logoutCurrentUser();
                    });
                }
            });
        },
        resetPassword: function(email, successCallback, failCallback)
        {
            swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, CONSTANTS.GUEST_EMAIL, CONSTANTS.GUEST_PASSWORD, "chromeBrowserExtension", "userLogin", function()
            {}, function()
            {});
            swarmHub.on("login.js", "success_guest", function guestLoginForPasswordRecovery(swarm)
            {
                swarmHub.off("login.js", "success_guest", guestLoginForPasswordRecovery);
                if (swarm.authenticated)
                {
                    var resetPassHandler = swarmHub.startSwarm("UserInfo.js", "resetPassword", email);
                    resetPassHandler.onResponse("resetRequestDone", function(swarm)
                    {
                        successCallback(swarm.email);
                        authenticationService.logoutCurrentUser();
                    });
                    resetPassHandler.onResponse("emailDeliveryUnsuccessful", function(swarm)
                    {
                        failCallback(swarm.error);
                        authenticationService.logoutCurrentUser();
                    });
                    resetPassHandler.onResponse("resetPasswordFailed", function(swarm)
                    {
                        failCallback(swarm.error);
                        authenticationService.logoutCurrentUser();
                    });
                }
            });
        },
        authenticateWithToken: function(userId, authenticationToken, successCallback, failCallback, networkErrorCallback)
        {
            var self = this;
            var authenticateWithTokenHandler = function()
            {
                swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, userId, authenticationToken, "chromeBrowserExtension", "tokenLogin", failCallback, networkErrorCallback, function()
                {});
                var tokenLoginSuccessfully = function(swarm)
                {
                    if (loggedIn === false)
                    {
                        self.setUser(successCallback);
                    }
                    loggedIn = swarm.authenticated;
                    var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
                    Cookies.set("sessionId", swarm.meta.sessionId,
                        {
                            expires: cookieValidityDays
                        });
                    Cookies.set("userId", swarm.userId,
                        {
                            expires: cookieValidityDays
                        });
                    swarmHub.off("login.js", "tokenLoginSuccessfully", tokenLoginSuccessfully);
                };
                var tokenLoginFailed = function()
                {
                    loggedIn = false;
                    self.restoreUserSession(successCallback, function()
                    {
                        Cookies.remove("userId");
                        Cookies.remove("sessionId");
                    });
                    swarmHub.off("login.js", "tokenLoginFailed", tokenLoginFailed);
                };
                swarmHub.on("login.js", "tokenLoginSuccessfully", tokenLoginSuccessfully);
                swarmHub.on("login.js", "tokenLoginFailed", tokenLoginFailed);
            };
            if (self.isLoggedIn() === true)
            {
                self.logoutCurrentUser(authenticateWithTokenHandler);
            }
            else
            {
                authenticateWithTokenHandler();
            }
        },
        resendActivationCode: function(email, successCallback, failCallback)
        {
            swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, CONSTANTS.GUEST_EMAIL, CONSTANTS.GUEST_PASSWORD, "chromeBrowserExtension", "userLogin", failCallback, failCallback);
            swarmHub.on("login.js", "success_guest", function guestLoginForUserRegistration(swarm)
            {
                swarmHub.off("login.js", "success_guest", guestLoginForUserRegistration);
                if (swarm.authenticated)
                {
                    var resendActivationCodeHandler = swarmHub.startSwarm("register.js", "sendActivationCode", email);
                    resendActivationCodeHandler.onResponse("success", function(swarm)
                    {
                        successCallback();
                        authenticationService.logoutCurrentUser();
                    });
                    resendActivationCodeHandler.onResponse("failed", function(swarm)
                    {
                        failCallback(swarm.error);
                        authenticationService.logoutCurrentUser();
                    });
                }
            });
        },
        restoreUserSession: function(successCallback, failCallback, errorCallback, reconnectCallback)
        {
            if (!errorCallback)
            {
                errorCallback = function()
                {};
            }
            if (!reconnectCallback)
            {
                reconnectCallback = function()
                {};
            }
            var customReconnectCallback = function()
            {
                chrome.runtime.reload();
            };
            if (authenticationService.isLoggedIn())
            {
                successCallback();
            }
            else
            {
                var username = Cookies.get("userId");
                var sessionId = Cookies.get("sessionId");
                if (!username || !sessionId)
                {
                    failCallback();
                    return;
                }
                swarmService.restoreConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, username, sessionId, failCallback, errorCallback, customReconnectCallback);
                swarmHub.on("login.js", "restoreSucceed", function restoredSuccessfully(swarm)
                {
                    loggedIn = true;
                    if (successCallback)
                    {
                        authenticationService.setUser(successCallback);
                    }
                    var cookieValidityDays = parseInt(Cookies.get("daysUntilCookieExpire"));
                    Cookies.set("sessionId", swarm.meta.sessionId,
                        {
                            expires: cookieValidityDays
                        });
                    Cookies.set("userId", swarm.userId,
                        {
                            expires: cookieValidityDays
                        });
                    swarmHub.off("login.js", "restoreSucceed", restoredSuccessfully);
                });
                swarmHub.on("login.js", "restoreFailed", function restoreFailed(swarm)
                {
                    authenticationService.clearUserData();
                    swarmHub.off("login.js", "restoreSucceed", restoreFailed);
                });
            }
        },
        setUser: function(callback)
        {
            var associateUserWithDeviceAction = bus.getAction("associateUserWithDevice");
            var registerForPushNotificationsAction = bus.getAction("registerForPushNotifications");
            associateUserWithDeviceAction();
            registerForPushNotificationsAction();
            var setUserHandler = swarmHub.startSwarm("UserInfo.js", "info");
            setUserHandler.onResponse("result", function(swarm)
            {
                authenticatedUser = swarm.result;
                if (authenticatedUser.email !== ExtensionConfig.GUEST_EMAIL)
                {
                    loggedInObservable.notify();
                    if (callback)
                    {
                        callback(authenticatedUser);
                    }
                }
                else
                {
                    authenticationService.logoutCurrentUser();
                }
            });
        },
        getCurrentUser: function(callback)
        {
            var wrappedCallback = function()
            {
                callback(authenticatedUser);
            };
            portObserversPool.changeObserverCallback("getCurrentUser", callback, wrappedCallback);
            loggedInObservable.observe(wrappedCallback, !loggedIn);
        },
        notifyWhenLogout: function(callback)
        {
            notLoggedInObservable.observe(callback, loggedIn);
        },
        clearUserData: function()
        {
            authenticatedUser = {};
            loggedIn = false;
            notLoggedInObservable.notify();
            Cookies.remove("userId");
            Cookies.remove("sessionId");
        },
        logoutCurrentUser: function(callback)
        {
            deviceService.disassociateUserWithDevice(function()
            {
                swarmHub.startSwarm("login.js", "logout");
            });
            swarmHub.on("login.js", "logoutSucceed", function logoutSucceed(swarm)
            {
                authenticationService.clearUserData();
                swarmHub.off("login.js", "logoutSucceed", logoutSucceed);
                identityService.clearIdentitiesList();
                swarmService.removeConnection();
                if (callback)
                {
                    callback();
                }
            });
        },
        userIsAuthenticated: function(successCallback, failCallback)
        {
            switch (authenticationService.isLoggedIn())
            {
                case true:
                    successCallback();
                    break;
                case false:
                    failCallback();
                    break;
            }
        }
    };
    bus.registerService(authenticationService);
    bus.registerObservers(
        {
            "getCurrentUser": loggedInObservable
        },
        {
            "notifyWhenLogout": notLoggedInObservable
        });
    return exports;
})();
require.scopes["pfb-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var currentDeals = false;
    var lastUpdate = new Date();
    var oneDay = 24 * 60 * 60 * 1000;
    var pfbService = exports.pfbService = {
        getAllPfbDeals: function(success_callback)
        {
            if (!currentDeals || new Date() - lastUpdate > oneDay)
            {
                var getAllDealsHandler = swarmHub.startSwarm("pfb.js", "getAllDeals");
                getAllDealsHandler.onResponse("gotAllDeals", function(swarm)
                {
                    currentDeals = swarm.deals;
                    lastUpdate = new Date();
                    success_callback(currentDeals);
                });
            }
            else
            {
                success_callback(currentDeals);
            }
        },
        acceptPfbDeal: function(pfbDealId, success_callback)
        {
            var acceptPfBDeal = swarmHub.startSwarm("pfb.js", "acceptDeal", pfbDealId);
            acceptPfBDeal.onResponse("dealAccepted", function(swarm)
            {
                success_callback(swarm.deal);
                for (var i = 0; i < currentDeals.length; i++)
                {
                    if (currentDeals[i]["offerId"] == pfbDealId)
                    {
                        currentDeals[i].subscribed = true;
                        break;
                    }
                }
            });
        },
        unsubscribePfbDeal: function(pfbDealId, success_callback)
        {
            var unsubscribePfbDealHandler = swarmHub.startSwarm("pfb.js", "unsubscribeDeal", pfbDealId);
            unsubscribePfbDealHandler.onResponse("dealUnsubscribed", function(swarm)
            {
                for (var i = 0; i < currentDeals.length; i++)
                {
                    if (currentDeals[i]["offerId"] == pfbDealId)
                    {
                        currentDeals[i].subscribed = false;
                        delete currentDeals[i]["voucher"];
                        break;
                    }
                }
                success_callback(swarm.deal);
            });
        },
        getWebsiteDeal: function(data, success_callback, failCallback)
        {
            pfbService.getAllPfbDeals(function(deals)
            {
                var dealsAvailable = deals.filter(function(deal)
                {
                    var currentDate = new Date();
                    return data.tabUrl.match(getHostName(deal.website)) && currentDate < deal.end_date && currentDate >= deal.startDate;
                });
                if (dealsAvailable.length > 0)
                {
                    success_callback(dealsAvailable[0]);
                }
                else
                {
                    failCallback("no_pfb");
                }
            });
        }
    };

    function getHostName(url)
    {
        var match = url.match(/:\/\/(www[0-9]?\.)?(.[^/:]+)/i);
        if (match != null && match.length > 2 && typeof match[2] === "string" && match[2].length > 0)
        {
            return match[2];
        }
        else
        {
            return null;
        }
    }
    bus.registerService(pfbService);
    return exports;
})();
require.scopes["social-network-privacy-settings"] = (function()
{
    var exports = {};
    var observer = {
        privacy_setting_saved: {
            success: [],
            error: []
        }
    };
    swarmHub.on("sn_privacy_settngs.js", "stored_social_network_success", function(swarm)
    {
        while (observer.privacy_setting_saved.success.length > 0)
        {
            var c = observer.privacy_setting_saved.success.pop();
            c();
        }
    });
    var socialNetworkService = exports.socialNetworkService = {
        saveSocialNetworkSetting: function(sn_setting, success_callback, error_callback)
        {
            swarmHub.startSwarm("sn_privacy_settngs.js", "savePrivacySetting", sn_setting);
            observer.privacy_setting_saved.success.push(success_callback);
            observer.privacy_setting_saved.error.push(error_callback);
        }
    };
    return exports;
})();
require.scopes["osp-service"] = (function()
{
    var exports = {};
    var desiredOrder = ["google", "facebook", "linkedin", "twitter"];
    var bus = require("bus-service").bus;
    var ospService = exports.ospService = {
        getOSPSettings: function(success_callback)
        {
            function requestListener()
            {
                if (this.responseText)
                {
                    var ospSettings = JSON.parse(this.responseText);
                    var orderedOspSettings = {};
                    desiredOrder.forEach(function(ospName)
                    {
                        if (ospSettings[ospName])
                        {
                            orderedOspSettings[ospName] = ospSettings[ospName];
                        }
                    });
                    success_callback(orderedOspSettings);
                }
                else
                {
                    console.error("Failed retrieving privacy settings!");
                }
            }
            var xhrReq = new XMLHttpRequest();
            xhrReq.addEventListener("load", requestListener);
            var resourceURI = ExtensionConfig.SERVER_HOST_PROTOCOL + "://" + ExtensionConfig.OPERANDO_SERVER_HOST + ":" + ExtensionConfig.OPERANDO_SERVER_PORT + "/social-networks/privacy-settings/all";
            xhrReq.open("GET", resourceURI);
            xhrReq.send();
        }
    };
    bus.registerService(ospService);
    return exports;
})();
require.scopes["Interceptor"] = (function()
{
    var exports = {};
    var acceptedTypes = ["body-request", "headers-request", "headers-response"];
    var Interceptor = function(type, osp, pattern, callback)
    {
        if (acceptedTypes.indexOf(type).length == -1)
        {
            throw "Interceptor type is not recognized!";
        }
        this.type = type;
        this.osp = osp;
        this.pattern = pattern;
        this.callback = callback;
    };
    var InterceptorPools = (function()
    {
        var instance;
        var self = this;
        this.bodyRequestsPoolInterceptor = [];
        this.headersRequestsPoolInterceptor = [];
        this.headersResponsesPoolInterceptor = [];
        this.addBodyRequestInterceptor = function(osp, pattern, callback)
        {
            var bodyRequestInterceptor = new Interceptor("body-request", osp, pattern, callback);
            self.bodyRequestsPoolInterceptor.push(bodyRequestInterceptor);
        };
        this.addHeadersRequestsPoolInterceptor = function(osp, pattern, callback)
        {
            var headerRequestInterceptor = new Interceptor("headers-request", osp, pattern, callback);
            self.headersRequestsPoolInterceptor.push(headerRequestInterceptor);
        };
        this.addHeadersResponsesPoolInterceptor = function(osp, pattern, callback)
        {
            var headerResponsesInterceptor = new Interceptor("headers-response", osp, pattern, callback);
            self.headersResponsesPoolInterceptor.push(headerResponsesInterceptor);
        };
        this.getBodyRequestInterceptor = function(osp)
        {
            return self.bodyRequestsPoolInterceptor.filter(function(interceptor)
            {
                return interceptor.osp === osp;
            });
        };
        this.getHeadersRequestInterceptor = function(osp)
        {
            return self.headersRequestsPoolInterceptor.filter(function(interceptor)
            {
                return interceptor.osp === osp;
            });
        };
        this.getHeadersResponseInterceptor = function(osp)
        {
            return self.headersResponsesPoolInterceptor.filter(function(interceptor)
            {
                return interceptor.osp === osp;
            });
        };

        function init()
        {
            return {
                addBodyRequestInterceptor: self.addBodyRequestInterceptor,
                addHeadersRequestsPoolInterceptor: self.addHeadersRequestsPoolInterceptor,
                addHeadersResponsesPoolInterceptor: self.addHeadersResponsesPoolInterceptor,
                getBodyRequestInterceptor: self.getBodyRequestInterceptor,
                getHeadersRequestInterceptor: self.getHeadersRequestInterceptor,
                getHeadersResponseInterceptor: self.getHeadersResponseInterceptor
            };
        }
        return {
            getInstance: function()
            {
                if (!instance)
                {
                    instance = init();
                }
                return instance;
            }
        };
    })();
    exports.InterceptorPools = InterceptorPools.getInstance();
    return exports;
})();
require.scopes["request-intercepter-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var interceptorPools = require("Interceptor").InterceptorPools;
    var facebookFirstPOSTInterceptor = function(message, callback)
    {
        var interceptorCallback = function(request)
        {
            if (request.method == "POST")
            {
                if (message.template)
                {
                    if (request.url.indexOf("facebook.com/ajax/bz") != -1)
                    {
                        var requestBody = request.requestBody;
                        if (requestBody.formData)
                        {
                            var formData = requestBody.formData;
                            for (var prop in message.template)
                            {
                                if (formData[prop])
                                {
                                    if (formData[prop] instanceof Array)
                                    {
                                        message.template[prop] = formData[prop][0];
                                    }
                                    else
                                    {
                                        message.template[prop] = formData[prop];
                                    }
                                }
                            }
                        }
                        else if (requestBody.raw)
                        {
                            var rawRequest = String.fromCharCode.apply(null, new Uint8Array(requestBody.raw[0].bytes));
                            var requestArray = rawRequest.split("&");
                            var formDataObjects = {};
                            requestArray.forEach(function(pair)
                            {
                                var splitedPair = pair.split("=");
                                formDataObjects[splitedPair[0]] = splitedPair[1];
                            });
                            for (var prop in message.template)
                            {
                                if (formDataObjects[prop])
                                {
                                    message.template[prop] = decodeURIComponent(formDataObjects[prop]);
                                }
                            }
                        }
                        webRequest.onBeforeRequest.removeListener(interceptorCallback);
                        callback(
                            {
                                template: message.template
                            });
                    }
                }
            }
        };
        return interceptorCallback;
    };
    var twitterAppsRequestInterceptor = function(message, callback)
    {
        var twiterAppsInterceptorCallback = function(request)
        {
            var headers = request.requestHeaders;
            var getTwitterAppsHeader = headers.find(function(header)
            {
                return header.name.toLowerCase() === "get-twitter-apps";
            });
            if (getTwitterAppsHeader)
            {
                var insecureHeader = headers.find(function(header)
                {
                    return header.name.toLowerCase() === "upgrade-insecure-requests";
                });
                if (!insecureHeader)
                {
                    request.requestHeaders.push(
                        {
                            name: "upgrade-insecure-requests",
                            value: "1"
                        });
                    request.requestHeaders.push(
                        {
                            name: "referer",
                            value: "https://twitter.com/"
                        });
                    request.requestHeaders.push(
                        {
                            name: "cache-control",
                            value: "max-age=0"
                        });
                }
                var cookieHeader = headers.find(function(header)
                {
                    return header.name.toLowerCase() === "cookie";
                });
                cookieHeader.value += "; csrf_same_site=1";
                setTimeout(function()
                {
                    webRequest.onBeforeSendHeaders.removeListener(twiterAppsInterceptorCallback);
                }, 1000);
                for (var i = 0; i < request.requestHeaders.length; ++i)
                {
                    var header = request.requestHeaders[i];
                    if (header.name === "get-twitter-apps")
                    {
                        request.requestHeaders.splice(i, 1);
                        break;
                    }
                }
            }
            return {
                requestHeaders: request.requestHeaders
            };
        };
        return twiterAppsInterceptorCallback;
    };
    var twitterHeadersRequestInterceptor = function(message, callback)
    {
        var interceptorCallback = function(request)
        {
            var headers = [];
            var copyHeadersIfAvailable = function(requestHeader)
            {
                if (message.headers.indexOf(requestHeader["name"]) > -1)
                {
                    headers.push(
                        {
                            name: requestHeader.name,
                            value: requestHeader.value
                        });
                }
            };
            if (request.method == "POST")
            {
                if (request.url.indexOf("api.twitter.com/1.1/jot/client_event.json") != -1)
                {
                    var requestHeaders = request.requestHeaders;
                    requestHeaders.forEach(copyHeadersIfAvailable);
                    callback(
                        {
                            headers: headers
                        });
                    webRequest.onBeforeSendHeaders.removeListener(interceptorCallback);
                }
            }
        };
        return interceptorCallback;
    };
    var dropboxHeadersRequestInterceptor = function(message, callback)
    {
        var interceptorCallback = function(details)
        {
            var requestedHeaders = details.requestHeaders;
            var plusPrivacyCustomData;
            var plusPrivacyCustomDataIndex;
            requestedHeaders.some(function(rHeader, index)
            {
                if (rHeader.name === "PlusPrivacyCustomData")
                {
                    plusPrivacyCustomData = rHeader;
                    plusPrivacyCustomDataIndex = index;
                    return true;
                }
                return false;
            });
            if (plusPrivacyCustomData)
            {
                var cookieHeader = requestedHeaders.find(function(rHeader)
                {
                    return rHeader.name.toLowerCase() === "cookie";
                });
                var customData = JSON.parse(plusPrivacyCustomData.value);
                if (customData.custom_headers)
                {
                    var customHeaders = customData.custom_headers;
                    if (customHeaders instanceof Array)
                    {
                        customHeaders.forEach(function(header)
                        {
                            details.requestHeaders.push(header);
                        });
                    }
                }
                if (customData.custom_cookies)
                {
                    var customCookies = customData.custom_cookies;
                    if (customCookies instanceof Array)
                    {
                        customCookies.forEach(function(cookie)
                        {
                            cookieHeader.value += "; " + cookie.name + "=" + cookie.value;
                        });
                    }
                }
                if (plusPrivacyCustomDataIndex)
                {
                    details.requestHeaders.splice(plusPrivacyCustomDataIndex, 1);
                }
            }
            return {
                requestHeaders: details.requestHeaders
            };
        };
        return interceptorCallback;
    };
    var removeXFrameOptionsHeaders = function(message, callback)
    {
        var HEADERS_TO_STRIP_LOWERCASE = ["content-security-policy", "x-frame-options"];
        return function(details)
        {
            return {
                responseHeaders: details.responseHeaders.filter(function(header)
                {
                    return HEADERS_TO_STRIP_LOWERCASE.indexOf(header.name.toLowerCase()) < 0;
                })
            };
        };
    };
    var changeReferer = function(message, callback)
    {
        return function(details)
        {
            var referer = "";
            for (var i = 0; i < details.requestHeaders.length; ++i)
            {
                var header = details.requestHeaders[i];
                if (header.name === "X-Alt-Referer")
                {
                    referer = header.value;
                    details.requestHeaders.splice(i, 1);
                    break;
                }
            }
            if (referer !== "")
            {
                for (var i = 0; i < details.requestHeaders.length; ++i)
                {
                    var header = details.requestHeaders[i];
                    if (header.name === "Referer")
                    {
                        details.requestHeaders[i].value = referer;
                        break;
                    }
                }
            }
        };
    };
    var facebookOriginHeader = function(message, callback)
    {
        return function(details)
        {
            if (details["url"].indexOf("https://www.facebook.com/ajax/settings/apps/delete_app.php") >= 0)
            {
                for (var i = 0; i < details.requestHeaders.length; ++i)
                {
                    if (details.requestHeaders[i].name === "Origin")
                    {
                        details.requestHeaders[i].value = "https://www.facebook.com";
                        break;
                    }
                }
                details.requestHeaders.push(
                    {
                        name: "referer",
                        value: "https://www.facebook.com/settings?tab=applications"
                    });
            }
            return {
                requestHeaders: details.requestHeaders
            };
        };
    };
    interceptorPools.addBodyRequestInterceptor("facebook", ["*://www.facebook.com/*"], facebookFirstPOSTInterceptor);
    interceptorPools.addHeadersRequestsPoolInterceptor("twitter", ["*://api.twitter.com/*"], twitterHeadersRequestInterceptor);
    interceptorPools.addHeadersRequestsPoolInterceptor("twitter-apps", ["*://twitter.com/*"], twitterAppsRequestInterceptor);
    interceptorPools.addHeadersRequestsPoolInterceptor("dropbox", ["*://www.dropbox.com/*"], dropboxHeadersRequestInterceptor);
    interceptorPools.addHeadersRequestsPoolInterceptor("change-referer", ["<all_urls>"], changeReferer);
    interceptorPools.addHeadersRequestsPoolInterceptor("delete-fb-app", ["<all_urls>"], facebookOriginHeader);
    interceptorPools.addHeadersResponsesPoolInterceptor("all-header-responses", ["<all_urls>"], removeXFrameOptionsHeaders);
    var requestInterceptorService = exports.requestInterceptor = {
        interceptSingleRequest: function(target, message, callback)
        {
            var interceptorsCallback = interceptorPools.getBodyRequestInterceptor(target);
            interceptorsCallback.forEach(function(interceptor)
            {
                webRequest.onBeforeRequest.addListener(interceptor.callback(message, callback),
                    {
                        urls: interceptor.pattern
                    }, ["blocking", "requestBody"]);
            });
        },
        interceptHeadersBeforeRequest: function(target, message, callback)
        {
            var interceptorsCallback = interceptorPools.getHeadersRequestInterceptor(target);
            interceptorsCallback.forEach(function(interceptor)
            {
                webRequest.onBeforeSendHeaders.addListener(interceptor.callback(message, callback),
                    {
                        urls: interceptor.pattern
                    }, ["blocking", "requestHeaders"]);
            });
        },
        interceptHeadersResponse: function(target, message, callback)
        {
            var interceptorsCallback = interceptorPools.getHeadersResponseInterceptor(target);
            interceptorsCallback.forEach(function(interceptor)
            {
                webRequest.onHeadersReceived.addListener(interceptor.callback(message, callback),
                    {
                        urls: interceptor.pattern
                    }, ["blocking", "responseHeaders"]);
            });
        }
    };
    bus.registerService(requestInterceptorService);
    return exports;
})();
require.scopes["user-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var userUpdatedObservable = swarmHub.createObservable();
    var userService = exports.userService = {
        changePassword: function(changePasswordData, success_callback, error_callback)
        {
            var changePasswordHandler = swarmHub.startSwarm("UserInfo.js", "changePassword", changePasswordData.currentPassword, changePasswordData.newPassword);
            changePasswordHandler.onResponse("passwordSuccessfullyChanged", function(response)
            {
                success_callback();
            });
            changePasswordHandler.onResponse("passwordChangeFailure", function(response)
            {
                error_callback(response.error);
            });
        },
        userUpdated: function(callback)
        {
            userUpdatedObservable.observe(callback, true);
        },
        getUserPreferences: function(preferenceKey, success_callback, error_callback)
        {
            chrome.storage.local.get("UserPrefs", function(items)
            {
                var userPreferences;
                if (typeof items === "object" && Object.keys(items).length === 0)
                {
                    userPreferences = {};
                }
                else
                {
                    userPreferences = JSON.parse(items["UserPrefs"]);
                }
                var keyPreferences = {};
                if (userPreferences[preferenceKey] !== "undefined")
                {
                    keyPreferences = userPreferences[preferenceKey];
                }
                success_callback(keyPreferences);
            });
        },
        saveUserPreferences: function(data, success_callback, error_callback)
        {
            chrome.storage.local.get("UserPrefs", function(items)
            {
                var userPreferences;
                if (typeof items === "object" && Object.keys(items).length === 0)
                {
                    userPreferences = {};
                }
                else
                {
                    userPreferences = JSON.parse(items["UserPrefs"]);
                }
                userPreferences[data.preferenceKey] = data.preferences;
                chrome.storage.local.set(
                    {
                        UserPrefs: JSON.stringify(userPreferences)
                    });
                success_callback(data.preferences);
            });
        },
        removePreferences: function(preferenceKey, success_callback, error_callback)
        {
            chrome.storage.local.get("UserPrefs", function(items)
            {
                var userPreferences;
                if (typeof items === "object" && Object.keys(items).length === 0)
                {
                    userPreferences = {};
                }
                else
                {
                    userPreferences = JSON.parse(items["UserPrefs"]);
                }
                if (userPreferences[preferenceKey])
                {
                    delete userPreferences[preferenceKey];
                    chrome.storage.local.set(
                        {
                            UserPrefs: JSON.stringify(userPreferences)
                        }, success_callback);
                }
                else
                {
                    error_callback();
                }
            });
        },
        removeAccount: function(success_callback, error_callback)
        {
            var removeAccountHandler = swarmHub.startSwarm("UserInfo.js", "deleteAccount");
            removeAccountHandler.onResponse("success", function(response)
            {
                success_callback(response);
            });
            removeAccountHandler.onResponse("failed", function(response)
            {
                error_callback(response.error);
            });
        },
        contactMessage: function(data, success_callback, error_callback)
        {
            var contactMessageHandler = swarmHub.startSwarm("contact.js", "sendMessage", data);
            contactMessageHandler.onResponse("success", function(response)
            {
                success_callback();
            });
            contactMessageHandler.onResponse("error", function(response)
            {
                error_callback();
            });
        },
        resetExtension: function()
        {
            chrome.storage.sync.clear(function()
            {
                chrome.storage.local.clear(function()
                {
                    chrome.runtime.reload();
                });
            });
        },
        sendAnalytics: function(analyticsLabel)
        {
            swarmHub.startSwarm("analytics.js", "actionPerformed", analyticsLabel);
        },
        provideFeedbackQuestions: function(success_callback, error_callback)
        {
            function requestListener()
            {
                if (this.responseText)
                {
                    success_callback(JSON.parse(this.responseText));
                }
                else
                {
                    error_callback("Failed retrieving feedback questions!");
                }
            }
            var xhrReq = new XMLHttpRequest();
            xhrReq.addEventListener("load", requestListener);
            var resourceURI = ExtensionConfig.SERVER_HOST_PROTOCOL + "://" + ExtensionConfig.OPERANDO_SERVER_HOST + ":" + ExtensionConfig.OPERANDO_SERVER_PORT + "/feedback/questions";
            xhrReq.open("GET", resourceURI);
            xhrReq.send();
        },
        sendFeedback: function(feedback, success_callback, error_callback)
        {
            function requestListener()
            {
                if (this.responseText)
                {
                    success_callback(JSON.parse(this.responseText));
                    chrome.storage.local.get("UserPrefs", function(items)
                    {
                        var userPreferences;
                        if (typeof items === "object" && Object.keys(items).length === 0)
                        {
                            userPreferences = {};
                        }
                        else
                        {
                            userPreferences = JSON.parse(items["UserPrefs"]);
                        }
                        userPreferences["feedback-responses"] = feedback;
                        chrome.storage.local.set(
                            {
                                UserPrefs: JSON.stringify(userPreferences)
                            });
                    });
                }
                else
                {
                    error_callback("Failed submitting feedback responses!");
                }
            }
            var xhrReq = new XMLHttpRequest();
            xhrReq.addEventListener("load", requestListener);
            var resourceURI = ExtensionConfig.SERVER_HOST_PROTOCOL + "://" + ExtensionConfig.OPERANDO_SERVER_HOST + ":" + ExtensionConfig.OPERANDO_SERVER_PORT + "/feedback/responses";
            xhrReq.open("POST", resourceURI);
            xhrReq.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
            xhrReq.send(JSON.stringify(feedback));
        },
        hasUserSubmittedAFeedback: function(callback)
        {
            chrome.storage.local.get("UserPrefs", function(items)
            {
                var userPreferences;
                if (typeof items === "object" && Object.keys(items).length === 0)
                {
                    userPreferences = {};
                }
                else
                {
                    userPreferences = JSON.parse(items["UserPrefs"]);
                }
                var feedbackResponses = {};
                if (userPreferences["feedback-responses"])
                {
                    feedbackResponses = userPreferences["feedback-responses"];
                }
                callback(feedbackResponses);
            });
        }
    };
    bus.registerService(userService);
    bus.registerObservers(
        {
            "userUpdated": userUpdatedObservable
        });
    return exports;
})();
require.scopes["social-network-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var socialNetworkEmailAddressMap = {
        "facebook": {
            type: "email",
            url: "https://www.facebook.com/settings?tab=account",
            regex: "<span class=\"fbSettingsListItemContent fcg\">.*?: <strong>(.*?)</strong>"
        },
        "twitter": {
            type: "username",
            url: "https://twitter.com/settings/account",
            regex: "<span class=\"username u-dir\" dir=\"ltr\">@<b class=\"u-linkComplex-target\">(.*?)</b></span>"
        },
        "linkedin": {
            type: "email",
            url: "https://www.linkedin.com/psettings/email",
            regex: "<div class=\"address-details\"><p class=\"email-address\">(.*?)</p></div><div class=\"actions\"><span class=\"is-primary\">.*?</span></div>"
        },
        "google": {
            type: "email",
            url: "https://myaccount.google.com/email",
            regex: "<div class=\"WAITcd\"><h3 class=\"pYJXie\">.*?</h3><div class=\"HrlX8c\"><div class=\"n83bO\"><div class=\"fHYswf\"><div class=\"ia4Bx\"><span class=\"kI49Jc\">(.*?)</span></div></div></div><div class=\"Gyrjpb\">.*?</div></div></div>",
            group: 1
        },
        "dropbox": {
            type: "email",
            url: "https://www.dropbox.com/account",
            regex: "\"email\": \"(.*?)\""
        }
    };
    var socialNetworkService = exports.socialNetworkService = {
        getSocialNetworkEmailHandler: function(socialNetwork, callback)
        {
            if (socialNetworkEmailAddressMap[socialNetwork])
            {
                callback(socialNetworkEmailAddressMap[socialNetwork]);
            }
            else
            {
                console.error("No such social network!");
            }
        }
    };
    return exports;
})();
require.scopes["website-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var authenticationService = require("authentication-service").authenticationService;
    var portObserversPool = require("observers-pool").portObserversPool;
    var socialNetworkService = require("social-network-service").socialNetworkService;
    var interceptorService = require("request-intercepter-service").requestInterceptor;

    function doTwitterAppsRequest(url, callback)
    {
        var oReq = new XMLHttpRequest();
        oReq.onreadystatechange = function()
        {
            if (oReq.readyState == XMLHttpRequest.DONE)
            {
                callback(oReq.responseText, true);
            }
        };
        oReq.open("GET", url);
        oReq.withCredentials = true;
        interceptorService.interceptHeadersBeforeRequest("twitter-apps");
        oReq.setRequestHeader("get-twitter-apps", "1");
        oReq.send();
    }

    function doGetRequest(url, data, callback)
    {
        if (data instanceof Function)
        {
            callback = data;
        }
        var oReq = new XMLHttpRequest();
        oReq.onreadystatechange = function()
        {
            if (oReq.readyState == XMLHttpRequest.DONE)
            {
                callback(oReq.responseText, true);
            }
        };
        oReq.open("GET", url);
        console.log(arguments.length);
        if (arguments.length > 2)
        {
            if (data.headers)
            {
                oReq.withCredentials = true;
                data.headers.forEach(function(header)
                {
                    oReq.setRequestHeader(header.name, header.value);
                });
            }
        }
        oReq.send();
    }

    function doPOSTRequest(url, data, callback)
    {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", url, true);
        if (data.headers)
        {
            data.headers.forEach(function(header)
            {
                xhr.setRequestHeader(header.name, header.value);
            });
        }
        else
        {
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        xhr.onload = function()
        {
            callback(this.responseText);
        };
        xhr.send(data._body ? data._body : data);
    }
    var websiteService = exports.websiteService = {
        authenticateUserInExtension: function(data)
        {
            var maxAuthenticationsAllowed = 1;
            authenticationService.authenticateWithToken(data.userId, data.authenticationToken, function(res)
            {
                console.log("authenticated here");
                if (maxAuthenticationsAllowed > 0)
                {
                    chrome.runtime.openOptionsPage();
                }
                maxAuthenticationsAllowed--;
            }, function()
            {}, function()
            {}, function()
            {});
        },
        getCurrentUserLoggedInInExtension: function()
        {
            portObserversPool.trigger("getCurrentUserLoggedInInExtension", authenticationService.getUser());
        },
        goToDashboard: function()
        {
            if (authenticationService.isLoggedIn())
            {
                chrome.runtime.openOptionsPage();
            }
            else
            {
                portObserversPool.trigger("goToDashboard", "sendMeAuthenticationToken");
            }
        },
        logout: function()
        {
            authenticationService.notifyWhenLogout(function(message)
            {
                portObserversPool.trigger("logout", message);
            });
        },
        loggedIn: function()
        {
            authenticationService.getCurrentUser(function(message)
            {
                portObserversPool.trigger("loggedIn", message);
            });
        },
        getFacebookApps: function(callback)
        {
            var snApps = [];

            function getAppData(url)
            {
                return new Promise(function(resolve, reject)
                {
                    doGetRequest(url, function(data)
                    {
                        resolve(data);
                    });
                });
            }
            var handleDataForSingleApp = function(appId, crawledPage)
            {
                var appNameRegex;
                var appIconRegex;
                var permissionsRegex;
                var appVisibility;
                appNameRegex = "<div\\sclass=\"_5xu4\">\\s*<header>\\s*<h3.*?>(.*?)</h3>";
                appIconRegex = /<div\s+class="_5xu4"><i\s+class="img img _2sxw"\s+style="background-image: url\(&#039;(.+?)&#039;\);/;
                permissionsRegex = "<span\\sclass=\"_5ovn\">(.*?)</span>";
                appVisibility = "<div\\sclass=\"_52ja\"><span>(.*?)</span></div>";
                var name = RegexUtis.findValueByRegex_CleanAndPretty(self.key, "App Name", appNameRegex, 1, crawledPage, true);
                var iconUrl = RegexUtis.findValueByRegex(self.key, "App Icon", appIconRegex, 1, crawledPage, true);
                var permissions = RegexUtis.findAllOccurrencesByRegex(self.key, "Permissions Title", permissionsRegex, 1, crawledPage, RegexUtis.cleanAndPretty);
                var visibility = RegexUtis.findValueByRegex_CleanAndPretty(self.key, "Visibility", appVisibility, 1, crawledPage, true);
                var app = {
                    appId: appId,
                    iconUrl: iconUrl,
                    name: name,
                    permissions: permissions,
                    visibility: visibility
                };
                snApps.push(app);
            };
            var getApps = function(res)
            {
                var parser = new DOMParser();
                var doc = parser.parseFromString(res, "text/html");
                var sequence = Promise.resolve();
                var appsContainer = doc.getElementsByClassName("_xef");
                var apps = [];
                for (var i = 0; i < appsContainer.length; i++)
                {
                    apps.push(appsContainer[i].children[0].children[0].children[0].children[0]);
                }
                for (var i = 0; i < apps.length; i++)
                {
                    (function(i)
                    {
                        var appId = apps[i].getAttribute("href").split("appid=")[1];
                        sequence = sequence.then(function()
                        {
                            return getAppData("https://m.facebook.com/" + apps[i].getAttribute("href"));
                        }).then(function(result)
                        {
                            handleDataForSingleApp(appId, result);
                        });
                    })(i);
                }
                sequence.then(function()
                {
                    callback(snApps);
                });
            };
            doGetRequest("https://m.facebook.com/settings/apps/tabbed/", getApps);
        },
        getTwitterApps: function(callback)
        {
            var twitterApps = [];

            function getApps(res)
            {
                var rawAppsRegex = "<div\\s?id=\"oauth(?:.+)\"(?:.|\n)*?</div>(?:.|\n)*?</div>(?:.|\n)*?</div>(?:.|\n)*?</div>";
                var rawAppsList = RegexUtis.findAllOccurrencesByRegex(self.key, "List of Raw Apps", rawAppsRegex, 0, res);
                var appNameRegex = "strong>(.*?)\\s?</strong";
                var appIdRegex = "id=\"oauth_application_(.*?)\"\\s?class";
                var iconRegex = "<img\\s+class=\"app-img\"\\s+src=\"(.*?)\"";
                var permissionsRegex = "<p\\s+class=\"description\">.+?\\n.+?<small\\s+class=\"metadata\">(?:.+\\:\\s?)?(.+?)</small></p>";
                twitterApps = rawAppsList.map(function(rawAppData)
                {
                    var appName = RegexUtis.findValueByRegex_Pretty(self.key, "App Name+Id", appNameRegex, 1, rawAppData, true);
                    var appId = RegexUtis.findValueByRegex(self.key, "Revokde-Id", appIdRegex, 1, rawAppData, true);
                    var iconURL = RegexUtis.findValueByRegex(self.key, "App Icon", iconRegex, 1, rawAppData, true).unescapeHtmlChars();
                    var permissions = RegexUtis.findAllOccurrencesByRegex(self.key, "Extracting Permissions", permissionsRegex, 1, rawAppData, function(value)
                    {
                        return value.unescapeHtmlChars();
                    });
                    return {
                        "appId": appId,
                        "iconUrl": iconURL,
                        "name": appName,
                        "permissions": permissions
                    };
                });
                callback(twitterApps);
            }
            doTwitterAppsRequest("https://twitter.com/settings/applications?lang=en", function()
            {
                interceptorService.interceptHeadersBeforeRequest("twitter-apps");
                var headers = [
                    {
                        name: "get-twitter-apps",
                        value: "1"
                    }];
                doGetRequest("https://twitter.com/settings/applications?lang=en",
                    {
                        headers: headers
                    }, getApps);
            });
        },
        getLinkedInApps: function(callback)
        {
            var linkedInApps = [];

            function getApps(res)
            {
                var rawAppsRegex = "<li\\s+id=\"permitted-service-(?:.|\n)*?</div>(?:.|\n)*?</li>";
                var rawAppsList = RegexUtis.findAllOccurrencesByRegex(self.key, "List of Raw Apps", rawAppsRegex, 0, res);
                var appIdRegex = "data-app-id=\"(.*?)\"\\s?data-app-type";
                var appNameRegex = "p\\s+class=\"permitted-service-name\">(.*?)</p";
                var iconRegex = "src=\"(.*?)\"";
                linkedInApps = rawAppsList.map(function(rawAppData)
                {
                    return {
                        appId: RegexUtis.findValueByRegex(self.key, "Revokde-Id", appIdRegex, 1, rawAppData, true),
                        name: RegexUtis.findValueByRegex_Pretty(self.key, "App Name+Id", appNameRegex, 1, rawAppData, true),
                        iconUrl: RegexUtis.findValueByRegex(self.key, "App Icon", iconRegex, 1, rawAppData, true).unescapeHtmlChars()
                    };
                });
                callback(linkedInApps);
            }
            doGetRequest("https://www.linkedin.com/psettings/permitted-services", getApps);
        },
        getGoogleApps: function(callback)
        {
            var googleApps = [];
            var permissionsRegex = /<div[^>]+role="listitem"[^>]*>([^<]+).*?<\/div>/;
            var extractPermissionsFromRawGroup = function(rawData)
            {
                return RegexUtis.findAllOccurrencesByRegex(self.key, "Permissions in Group", permissionsRegex.source, 1, rawData, function(value)
                {
                    return value.trim().unescapeHtmlChars();
                });
            };

            function getApps(page)
            {
                var isLearnMoreRegex = /<div[^>]+role="listitem"[^>]*>[^<]*<a/;
                var permissionGroupRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^<]+<span[^<]+<img[^>]+src="([^"]+)"[^<]+<\/span>[^<]*<\/div>[^<]*<div[^>]+>([^<]+)<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
                var permissionGroupIconlessRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^<]+<span[^<]+<\/span>[^<]*<\/div>[^<]*<div[^>]+>([^<]+)<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
                var additionalPermissionGroupRegex = /<div[^>]+?role="listitem"[^>]*>[^<]*<div[^>]+>[^<]+<div[^<]+(<div[\s\S]+?<\/div>)[^<]*<\/div>[^<]*<\/div>[^<]*<\/div>/;
                var rawAppsRegex = "jscontroller[^<]+data-id[^<]+role=\"listitem\".*?role=\"row\".*?role=\"rowheader\".*?role=\"gridcell\".*?</div></div></div></div></div></content>";
                var rawAppsList = RegexUtis.findAllOccurrencesByRegex(self.key, "List of Raw Apps", rawAppsRegex, 0, page);
                var appIdRegex = "<div class=\"CMEZce\">([^\"]+)</div>";
                var iconUrlRegex = "<div class=\"ShbWnb\" aria-hidden=\"true\"><img src=\"([^\"]+)\"";
                googleApps = rawAppsList.map(function(rawAppData)
                {
                    var appId = RegexUtis.findValueByRegex(self.key, "App Id+Name", appIdRegex, 1, rawAppData, true).trim().unescapeHtmlChars();
                    var name = appId;
                    var iconUrl = RegexUtis.findValueByRegex(self.key, "App Icon", iconUrlRegex, 1, rawAppData, true).unescapeHtmlChars();
                    if (iconUrl.indexOf("google.com") > -1 && iconUrl.indexOf("android") > -1 || iconUrl.indexOf("gstatic.com") > -1 && iconUrl.indexOf("ios_icon") > -1)
                    {
                        return false;
                    }
                    var rawPermissionGroups = RegexUtis.findAllOccurrencesByRegex(self.key, "Permission Groups", permissionGroupRegex.source, 0, rawAppData, function(value)
                    {
                        return value.trim().unescapeHtmlChars();
                    });
                    permissionGroups = [];
                    var permissionIconGroups = rawPermissionGroups.map(function(rawGroup)
                    {
                        var groupData = RegexUtis.findMultiValuesByRegex(self.key, "Permission Group", permissionGroupRegex, [1, 2, 3], rawGroup, true);
                        var group = {
                            iconUrl: groupData[0].trim().unescapeHtmlChars(),
                            name: groupData[1].trim().unescapeHtmlChars()
                        };
                        var rawGroupContent = groupData[2];
                        if (!rawGroupContent.match(isLearnMoreRegex))
                        {
                            group.permissions = extractPermissionsFromRawGroup(rawGroupContent);
                        }
                        else
                        {
                            group.permissions = [group.name];
                        }
                        return group;
                    });
                    if (permissionIconGroups)
                    {
                        permissionGroups = permissionGroups.concat(permissionIconGroups);
                    }
                    var rawPermissionIconlessGroups = RegexUtis.findAllOccurrencesByRegex(self.key, "Permission Groups", permissionGroupIconlessRegex.source, 0, rawAppData, function(value)
                    {
                        return value.trim().unescapeHtmlChars();
                    });
                    var permissionIconlessGroups = rawPermissionIconlessGroups.map(function(rawGroup)
                    {
                        var groupData = RegexUtis.findMultiValuesByRegex(self.key, "Permission Group", permissionGroupIconlessRegex, [1, 2], rawGroup, true);
                        var group = {
                            name: groupData[0].trim().unescapeHtmlChars()
                        };
                        var rawGroupContent = groupData[1];
                        if (!rawGroupContent.match(isLearnMoreRegex))
                        {
                            group.permissions = extractPermissionsFromRawGroup(rawGroupContent);
                        }
                        else
                        {
                            group.permissions = [group.name];
                        }
                        return group;
                    });
                    if (permissionIconlessGroups)
                    {
                        permissionGroups = permissionGroups.concat(permissionIconlessGroups);
                    }
                    var rawAdditionalPermissionsGroup = RegexUtis.findValueByRegex(self.key, "Permission Group", additionalPermissionGroupRegex, 1, rawAppData, false);
                    if (rawAdditionalPermissionsGroup)
                    {
                        var additionalPermissions = extractPermissionsFromRawGroup(rawAdditionalPermissionsGroup);
                        permissionGroups.push(
                            {
                                permissions: additionalPermissions
                            });
                    }
                    return {
                        appId: appId,
                        iconUrl: iconUrl,
                        name: name,
                        permissionGroups: permissionGroups
                    };
                });
                callback(googleApps);
            }
            doGetRequest("https://myaccount.google.com/permissions", getApps);
        },
        getDropBoxApps: function(callback)
        {
            function getApps(content)
            {
                var matchRes = "(?:\"viewerData\"\\:)(?=.*\"Personal\")(?=.*\"userId\"\\:\\s+(\\w+))(?=.*\"personalName\"\\:\\s+\\\"([^\"]+)\\\"[,]\\s+)";
                var userId = RegexUtis.findValueByRegex_CleanAndPretty(self.key, "Account - UserId", matchRes, 1, content, true);
                chrome.cookies.getAll(
                    {
                        url: "https://www.dropbox.com"
                    }, function(cookies)
                    {
                        var t_cookie = cookies.find(function(cookie)
                        {
                            return cookie.name === "t";
                        });
                        var host_ss_cookie = cookies.find(function(cookie)
                        {
                            return cookie.name === "__Host-ss";
                        });
                        var body = "is_xhr=true" + "&" + "t=" + t_cookie.value + "&" + "_subject_uid=" + userId;
                        var customData = {
                            custom_headers: [
                                {
                                    name: "Origin",
                                    value: "https://www.dropbox.com"
                                },
                                {
                                    name: "Referer",
                                    value: "https://www.dropbox.com/account/connected_apps"
                                },
                                {
                                    name: "Accept",
                                    value: "application/json, text/javascript, */*; q=0.01"
                                }],
                            custom_cookies: [
                                {
                                    name: "__Host-ss",
                                    value: host_ss_cookie.value
                                }]
                        };
                        var headers = [
                            {
                                name: "X-DROPBOX-UID",
                                value: userId
                            },
                            {
                                name: "X-Requested-With",
                                value: "XMLHttpRequest"
                            },
                            {
                                name: "Content-Type",
                                value: "application/x-www-form-urlencoded; charset=UTF-8"
                            },
                            {
                                name: "PlusPrivacyCustomData",
                                value: JSON.stringify(customData)
                            }];
                        var data = {
                            _body: body,
                            headers: headers
                        };
                        doPOSTRequest("https://www.dropbox.com/account/get_linked_apps", data, function(response)
                        {
                            var rawApps = JSON.parse(response);
                            var apps = [];
                            rawApps.user_apps.forEach(function(app)
                            {
                                apps.push(
                                    {
                                        appId: app.id,
                                        name: app.name,
                                        iconUrl: app.icon_url.replace("size=16x16", "size=32x32"),
                                        permission: {
                                            title: app.access_type,
                                            description: app.access_type_desc
                                        }
                                    });
                            });
                            callback(apps);
                        });
                    });
            }
            doGetRequest("https://www.dropbox.com/account/connected_apps", getApps);
        },
        removeSocialApp: function(data, callback)
        {
            function extractFBToken(content, callback)
            {
                var dtsgOption1 = "DTSGInitialData.*?\"token\"\\s?:\\s?\"(.*?)\"";
                var dtsgOption2 = "name=\\\\?\"fb_dtsg\\\\?\"\\svalue=\\\\?\"(.*?)\\\\?\"";
                var dtsgOption3 = "dtsg\"\\s?:\\s?{\"token\"\\s?:\\s?\"(.*?)";
                var fb_dtsg = RegexUtis.findValueByRegex(self.key, "fb_dtsg", dtsgOption1, 1, content, false);
                if (!fb_dtsg)
                {
                    fb_dtsg = RegexUtis.findValueByRegex(self.key, "fb_dtsg", dtsgOption2, 1, content, false);
                }
                if (!fb_dtsg)
                {
                    fb_dtsg = RegexUtis.findValueByRegex(self.key, "fb_dtsg", dtsgOption3, 1, content, true);
                }
                var userIdOption1 = "\"USER_ID\" ?: ?\"(.*?)\"";
                var userId = RegexUtis.findValueByRegex(self.key, "USER_ID", userIdOption1, 1, content, true);
                var data = {
                    "fb_dtsg": fb_dtsg,
                    "userId": userId
                };
                callback(data);
            }

            function extractTwitterToken(content, callback)
            {
                var tokenRegex = "value=\"(.*?)\" name=\"authenticity_token\"";
                var token = RegexUtis.findValueByRegex(self.key, "authenticity_token", tokenRegex, 1, content, true);
                callback(
                    {
                        token: token
                    });
            }

            function extractLinkedinToken(content, callback)
            {
                var tokenRegex = "name=\"csrfToken\" value=\"(.*?)\"";
                var token = RegexUtis.findValueByRegex(self.key, "authenticity_token", tokenRegex, 1, content, true);
                callback(
                    {
                        csrfToken: token
                    });
            }

            function extractGoogleTokens(content, appId, callback)
            {
                var now = new Date();
                var paramsOption1 = "\\[.*,\\'([\\w-]+:[\\w\\d]+)\\',.*\\]\\s.*(?=(\\,\\s*)+\\].*window\\.IJ_valuesCb \\&\\&)";
                var match = RegexUtis.findMultiValuesByRegex(self.key, "Revoke Params", paramsOption1, [1], content, true);
                var sidRegex = "WIZ_global_data.+{[^}]*?:\\\"([-\\d]+?)\\\"[^:\\\"]+";
                var sid = RegexUtis.findValueByRegex(self.key, "f.sid", sidRegex, 1, content, true);
                var at = match[0];
                var req_id = 3600 * now.getHours() + 60 * now.getMinutes() + now.getSeconds() + 100000;
                var fReqRegex = "data-name=\"" + appId + "\".*?data-handle=\"(.*?)\"";
                var f_req = RegexUtis.findValueByRegex(self.key, "f_req", fReqRegex, 1, content, true);
                callback(
                    {
                        req_id: req_id,
                        f_req: f_req,
                        at: at,
                        f_sid: sid
                    });
            }

            function extractDropBoxTokens(content, callback)
            {
                var tokens = {};
                var matchRes = "(?:\"viewerData\"\\:)(?=.*\"Personal\")(?=.*\"userId\"\\:\\s+(\\w+))(?=.*\"personalName\"\\:\\s+\\\"([^\"]+)\\\"[,]\\s+)";
                tokens.userId = RegexUtis.findValueByRegex_CleanAndPretty(self.key, "Account - UserId", matchRes, 1, content, true);
                chrome.cookies.get(
                    {
                        url: "https://www.dropbox.com",
                        name: "t"
                    }, function(cookie)
                    {
                        tokens["t"] = cookie.value;
                        callback(tokens);
                    });
            }

            function removeFbApp(appId)
            {
                doGetRequest("https://www.facebook.com/settings?tab=applications", function(content)
                {
                    extractFBToken(content, function(data)
                    {
                        var _body = "_asyncDialog=1&__user=" + data["userId"] + "&__a=1&__req=o&__rev=1562552&app_id=" + appId + "&legacy=false&dialog=true&confirmed=true&ban_user=0&fb_dtsg=" + data["fb_dtsg"];
                        doPOSTRequest("https://www.facebook.com/ajax/settings/apps/delete_app.php?app_id=" + encodeURIComponent(appId) + "&legacy=false&dialog=true", _body, function(response)
                        {
                            callback();
                        });
                    });
                });
            }

            function removeTwitterApp(appId)
            {
                doGetRequest("https://twitter.com/settings/applications?lang=en", function(content)
                {
                    extractTwitterToken(content, function(data)
                    {
                        var _body = "token=" + appId + "&" + encodeURIComponent("scribeContext[component]") + "=oauth_app&twttr=true&authenticity_token=" + data.token;
                        doPOSTRequest("https://twitter.com/oauth/revoke", _body, function(response)
                        {
                            callback();
                        });
                    });
                });
            }

            function removeLinkedinApp(appId)
            {
                doGetRequest("https://www.linkedin.com/psettings/permitted-services", function(content)
                {
                    extractLinkedinToken(content, function(data)
                    {
                        var _body = "id=" + appId + "&" + "type=OPEN_API" + "&" + "csrfToken=" + data.csrfToken;
                        doPOSTRequest("https://www.linkedin.com/psettings/permitted-services/remove", _body, callback);
                    });
                });
            }

            function removeGoogleApp(appId)
            {
                doGetRequest("https://myaccount.google.com/permissions?hl=en", function(content)
                {
                    extractGoogleTokens(content, appId, function(tokens)
                    {
                        var body = "at=" + tokens["at"];
                        body += "&f.req=" + "[\"af.maf\",[[\"af.add\",143439692,[{\"143439692\":[\"" + tokens["f_req"] + "\"]}]]]]";
                        var url = "https://myaccount.google.com/_/AccountSettingsUi/mutate?ds.extension=143439692";
                        if (tokens["f_sid"])
                        {
                            url += "&f.sid=" + tokens["f_sid"];
                        }
                        url += "&hl=en&_reqid=" + tokens["req_id"] + "&rt=c";
                        doPOSTRequest(url, body, callback);
                    });
                });
            }

            function removeDropoxApp(appId)
            {
                doGetRequest("https://www.dropbox.com/account/connected_apps", function(content)
                {
                    extractDropBoxTokens(content, function(tokens)
                    {
                        var body = {
                            "app_id": appId,
                            "keep_sandbox_files": true
                        };
                        var url = "https://www.dropbox.com/2/security_settings/uninstall_app";
                        var userId = tokens["userId"];
                        chrome.cookies.getAll(
                            {
                                url: "https://www.dropbox.com"
                            }, function(cookies)
                            {
                                var host_ss_cookie = cookies.find(function(cookie)
                                {
                                    return cookie.name === "__Host-ss";
                                });
                                var customData = {
                                    custom_headers: [
                                        {
                                            name: "Origin",
                                            value: "https://www.dropbox.com"
                                        },
                                        {
                                            name: "Referer",
                                            value: "https://www.dropbox.com/account/connected_apps"
                                        },
                                        {
                                            name: "Accept",
                                            value: "application/json, text/javascript, */*; q=0.01"
                                        }],
                                    custom_cookies: [
                                        {
                                            name: "__Host-ss",
                                            value: host_ss_cookie.value
                                        }]
                                };
                                var headers = [
                                    {
                                        name: "X-DROPBOX-UID",
                                        value: userId
                                    },
                                    {
                                        name: "X-Requested-With",
                                        value: "XMLHttpRequest"
                                    },
                                    {
                                        name: "content-type",
                                        value: "application/json"
                                    },
                                    {
                                        name: "x-csrf-token",
                                        value: tokens["t"]
                                    },
                                    {
                                        name: "PlusPrivacyCustomData",
                                        value: JSON.stringify(customData)
                                    }];
                                var data = {
                                    _body: JSON.stringify(body),
                                    headers: headers
                                };
                                doPOSTRequest(url, data, callback);
                            });
                    });
                });
            }
            switch (data.sn)
            {
                case "facebook":
                    removeFbApp(data.appId);
                    break;
                case "twitter":
                    removeTwitterApp(data.appId);
                    break;
                case "linkedin":
                    removeLinkedinApp(data.appId);
                    break;
                case "google":
                    removeGoogleApp(data.appId);
                    break;
                case "dropbox":
                    removeDropoxApp(data.appId);
                    break;
            }
        },
        getGoogleData: function(callback)
        {
            doGetRequest("https://myaccount.google.com/permissions?hl=en", getData);

            function getData(pageData)
            {
                var match;
                var sid;
                paramsOption1 = "\\[.*,\\'([\\w-]+:[\\w\\d]+)\\',.*\\]\\s.*(?=(\\,\\s*)+\\].*window\\.IJ_valuesCb \\&\\&)";
                match = RegexUtis.findMultiValuesByRegex(self.key, "Revoke Params", paramsOption1, [1], pageData, true);
                var sidRegex = "WIZ_global_data.+{[^}]*?:\\\"([-\\d]+?)\\\"[^:\\\"]+";
                sid = RegexUtis.findValueByRegex(self.key, "f.sid", sidRegex, 1, pageData, true);
                var at = match[0];
                var data = {
                    "at": at,
                    "f_sid": sid
                };
                callback(data);
            }
        },
        getMyLoggedinEmail: function(socialNetwork, success_callback, error_callback)
        {
            socialNetworkService.getSocialNetworkEmailHandler(socialNetwork, function(data)
            {
                var getDataPromise = function(url)
                {
                    return new Promise(function(resolve, reject)
                    {
                        switch (socialNetwork)
                        {
                            case "twitter":
                                var headers = {
                                    headers: [
                                        {
                                            name: "get-twitter-apps",
                                            value: "1"
                                        }]
                                };
                                doGetRequest(url, headers, resolve);
                                break;
                            default:
                                doGetRequest(url, resolve);
                                break;
                        }
                    });
                };
                var sequence = Promise.resolve();
                sequence = sequence.then(function()
                {
                    return getDataPromise(data.url);
                }).then(function(content)
                {
                    var regex = new RegExp(data.regex);
                    var match = regex.exec(content);
                    if (match && match[1])
                    {
                        success_callback(
                            {
                                type: data.type,
                                account: match[1]
                            });
                    }
                    else
                    {
                        error_callback();
                    }
                });
            });
        }
    };
    bus.registerService(websiteService);
    return exports;
})();
require.scopes["script-injector-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var facebookCallback = null;
    var linkedinCallback = null;
    var twitterCallback = null;
    var googleCallback = null;
    var googleActivityCallback = null;
    var scriptInjectorService = exports.scriptInjectorService = {
        insertFacebookIncreasePrivacyScript: function(data)
        {
            chrome.tabs.executeScript(data.tabId,
                {
                    code: data.code
                }, function()
                {
                    insertCSS(data.tabId, "operando/assets/css/feedback.css");
                    injectScript(data.tabId, "operando/modules/osp/writeFacebookSettings.js", ["FeedbackProgress", "jQuery"]);
                });
        },
        insertLinkedinIncreasePrivacyScript: function(data)
        {
            injectScript(data.tabId, "operando/modules/osp/writeLinkedinSettings.js", ["FeedbackProgress", "jQuery"], function()
            {
                insertCSS(data.tabId, "operando/assets/css/feedback.css");
            });
        },
        insertTwitterIncreasePrivacyScript: function(data)
        {
            chrome.tabs.executeScript(data.tabId,
                {
                    code: data.code
                }, function()
                {
                    insertCSS(data.tabId, "operando/assets/css/feedback.css");
                    injectScript(data.tabId, "operando/modules/osp/writeTwitterSettings.js", ["FeedbackProgress", "jQuery", "Tooltipster"]);
                });
        },
        insertGoogleIncreasePrivacyScript: function(data)
        {
            chrome.tabs.executeScript(data.tabId,
                {
                    code: data.code
                }, function()
                {
                    injectScript(data.tabId, "operando/modules/osp/writeGoogleSettings.js", ["FeedbackProgress", "jQuery"], function()
                    {
                        insertCSS(data.tabId, "operando/assets/css/feedback.css");
                    });
                });
        },
        insertActivityControlsWizardFiles: function(data)
        {
            injectScript(data.tabId, "operando/modules/osp/activityControlsWizard.js", ["jQuery"], function()
            {
                insertCSS(data.tabId, "operando/assets/css/activityControlsWizard.css");
            });
        },
        facebookMessage: function(callback)
        {
            facebookCallback = callback;
        },
        linkedinMessage: function(callback)
        {
            linkedinCallback = callback;
        },
        twitterMessage: function(callback)
        {
            twitterCallback = callback;
        },
        googleMessage: function(callback)
        {
            googleCallback = callback;
        },
        googleActivityMessage: function(callback)
        {
            googleActivityCallback = callback;
        },
        waitingFacebookCommand: function(instructions)
        {
            facebookCallback(instructions);
        },
        waitingLinkedinCommand: function(instructions)
        {
            linkedinCallback(instructions);
        },
        waitingTwitterCommand: function(instructions)
        {
            twitterCallback(instructions);
        },
        waitingGoogleCommand: function(instructions)
        {
            googleCallback(instructions);
        },
        waitingGoogleActivityCommand: function(instructions)
        {
            googleActivityCallback(instructions);
        }
    };
    bus.registerService(scriptInjectorService);
    return exports;
})();
require.scopes["popup-service"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var stateData = {};
    var popupService = exports.popupService = {
        updatePopupStateData: function(data)
        {
            for (var param in data)
            {
                stateData[param] = data[param];
            }
        },
        getPopupStateData: function(callback)
        {
            callback(stateData);
        }
    };
    bus.registerService(popupService);
    return exports;
})();
require.scopes["SynchronizedPersistence"] = (function()
{
    var exports = {};
    var SynchronizedPersistence = function()
    {};
    SynchronizedPersistence.prototype.get = function(model, key, callback)
    {
        chrome.storage.sync.get(model, function(obj)
        {
            console.log(obj);
            if (obj[model])
            {
                if (obj[model][key])
                {
                    callback(obj[model][key]);
                }
                else
                {
                    callback(null);
                }
            }
            else
            {
                callback(null);
            }
        });
    };
    SynchronizedPersistence.prototype.set = function(model, key, value)
    {
        chrome.storage.sync.get(model, function(obj)
        {
            if (obj[model] === undefined)
            {
                obj[model] = {};
            }
            if (obj[model][key] === undefined)
            {
                obj[model][key] = [];
            }
            obj[model][key].push(value);
            chrome.storage.sync.set(obj);
        });
    };
    SynchronizedPersistence.prototype.exists = function(model, key, value, callback)
    {
        this.get(model, key, function(_arr)
        {
            if (_arr && _arr.indexOf(value) >= 0)
            {
                callback(true);
            }
            else
            {
                callback(false);
            }
        });
    };
    exports.syncPersistence = new SynchronizedPersistence();
    return exports;
})();
require.scopes["DependencyManager"] = (function()
{
    var exports = {};
    var DependencyManager = exports.DependencyManager = {
        dependencyRepository: [
            {
                name: "FeedbackProgress",
                path: "/operando/util/FeedbackProgress.js"
            },
            {
                name: "jQuery",
                path: "/operando/utils/jquery-2.1.4.min.js"
            },
            {
                name: "Tooltipster",
                path: "/operando/utils/tooltipster/tooltipster.bundle.min.js"
            },
            {
                name: "UserPrefs",
                path: "/operando/modules/UserPrefs.js"
            },
            {
                name: "DOMElementProvider",
                path: "/operando/modules/DOMElementProvider.js"
            }],
        resolveDependency: function(dependency, resolve)
        {
            var dependencyFound = false;
            for (var i = 0; i < this.dependencyRepository.length; i++)
            {
                if (this.dependencyRepository[i].name == dependency)
                {
                    dependencyFound = true;
                    break;
                }
            }
            if (dependencyFound == true)
            {
                resolve(this.dependencyRepository[i].path);
            }
            else
            {
                console.error("Could not load dependency ", dependency);
            }
        }
    };
    return exports;
})();
require.scopes["TabsManager"] = (function()
{
    var exports = {};
    var bus = require("bus-service").bus;
    var authenticationService = require("authentication-service").authenticationService;
    var SyncPersistence = require("SynchronizedPersistence").syncPersistence;
    var BrowserTab = function(tab)
    {
        this.tab = tab;
        this.isActive = false;
        this.notificationId = null;
        this.history = [];
        this.removedCallback = [];
    };
    BrowserTab.prototype = {
        update: function(tab)
        {
            this.tab = tab;
        },
        onRemoved: function(callback)
        {
            this.removedCallback.push(callback);
        },
        activate: function()
        {
            this.isActive = true;
        },
        deactivate: function()
        {
            this.isActive = false;
        },
        setNotification: function(notification)
        {
            this.notificationId = notification;
        },
        removeNotification: function()
        {
            delete this.notificationId;
        },
        addUrlInHistory: function(url)
        {
            this.history.push(url);
        },
        getHistory: function()
        {
            return this.history;
        },
        getLastVisited: function()
        {
            if (this.history.length > 0)
            {
                return this.history[this.history.length - 1];
            }
            else
            {
                return null;
            }
        }
    };
    var TabsManager = function()
    {
        init();
        this.browserTabs = {};
        var self = this;
        chrome.tabs.query(
            {}, function(results)
            {
                results.forEach(function(tab)
                {
                    self.browserTabs[tab.id] = new BrowserTab(tab);
                });
            });
        chrome.tabs.onActivated.addListener(function(activeInfo)
        {
            for (var id in self.browserTabs)
            {
                if (id === activeInfo.tabId)
                {
                    self.browserTabs[id].activate();
                }
                else
                {
                    self.browserTabs[id].deactivate();
                }
            }
        });

        function onUpdatedListener(tabId, changeInfo, tab)
        {
            self.browserTabs[tab.id].update(tab);
            if (isGoodToAddInHistory(changeInfo.url))
            {
                self.browserTabs[tab.id].addUrlInHistory(changeInfo.url);
            }
        }

        function onRemovedListener(tabId)
        {
            var tab = self.browserTabs[tabId];
            while (tab.removedCallback.length > 0)
            {
                var removedCbk = tab.removedCallback.pop();
                removedCbk(
                    {
                        identifier: tabId
                    });
            }
            delete self.browserTabs[tabId];
        }
        chrome.tabs.onCreated.addListener(function(tab)
        {
            self.browserTabs[tab.id] = new BrowserTab(tab);
            if (isGoodToAddInHistory(tab.url))
            {
                self.browserTabs[tab.id].addUrlInHistory(tab.url);
            }
        });
        chrome.webNavigation.onCreatedNavigationTarget.addListener(function(details)
        {
            var parentTab = self.getTab(details.sourceTabId);
            if (parentTab)
            {
                self.getTab(details.tabId).addUrlInHistory(parentTab.getLastVisited());
            }
        });
        chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab)
        {
            onUpdatedListener(tabId, changeInfo, tab);
            if (authenticationService.isLoggedIn())
            {
                checkConnectWithSNApisUrls(tabId, changeInfo, tab);
            }
            if (tab.url)
            {
                if (changeInfo.status === "complete")
                {
                    if (tab.url.indexOf(ExtensionConfig.WEBSITE_HOST) != -1)
                    {
                        establishPlusPrivacyWebsiteCommunication(tabId);
                    }
                    else if (isAllowedToInsertScripts(tab.url))
                    {
                        if (authenticationService.isLoggedIn())
                        {
                            self.suggestSubstituteIdentities(tab.id);
                        }
                    }
                }
            }
        });
        chrome.tabs.onRemoved.addListener(onRemovedListener);
    };
    (TabsManager.prototype.getTab = function(tabId)
    {
        return this.browserTabs[tabId];
    }, TabsManager.prototype.getBrowserTabByNotificationId = function(notificationId)
    {
        for (var p in this.browserTabs)
        {
            if (this.browserTabs[p].notificationId && this.browserTabs[p].notificationId == notificationId)
            {
                return this.browserTabs[p];
            }
        }
    }, TabsManager.prototype.allowSocialNetworkPopup = function(data)
    {
        var browserTab = TabsMng.getBrowserTabByNotificationId(data.notificationId);
        browserTab.removeNotification();
        var tab = browserTab.tab;
        if (data.status === "allow" && data.notificationId)
        {
            chrome.tabs.executeScript(tab.id,
                {
                    file: "/operando/modules/pfb/allowSNContent.js"
                });
            authenticationService.getCurrentUser(function(response)
            {
                SyncPersistence.set("PfbNotificationsAccepted", "offerUserId", data.offerId.toString() + response.data.userId.toString());
            });
        }
        else
        {
            chrome.tabs.query(
                {
                    windowId: tab.windowId,
                    windowType: "popup"
                }, function(tabs)
                {
                    if (tabs.length > 0)
                    {
                        tab = tabs[0];
                        chrome.tabs.remove(tab.id);
                    }
                    else
                    {
                        chrome.tabs.executeScript(tab.id,
                            {
                                code: "window.history.back();"
                            });
                    }
                });
        }
    });
    TabsManager.prototype.suggestSubstituteIdentities = function(tabId)
    {
        injectScript(tabId, "operando/modules/identity/input-track.js", ["jQuery", "UserPrefs", "DOMElementProvider", "Tooltipster"], function()
        {
            insertCSS(tabId, "operando/assets/css/change-identity.css");
            insertCSS(tabId, "operando/utils/tooltipster/tooltipster.bundle.min.css");
            insertCSS(tabId, "operando/utils/tooltipster/tooltipster-plus-privacy.css");
        });
    };
    TabsManager.prototype.offerIsAccepted = function(offerId, callback)
    {
        authenticationService.getCurrentUser(function(response)
        {
            SyncPersistence.exists("PfbNotificationsAccepted", "offerUserId", offerId.toString() + response.data.userId.toString(), function(existence)
            {
                callback(existence);
            });
        });
    };
    TabsManager.prototype.getLastVisitedUrl = function(notificationId, callback)
    {
        var tab = TabsMng.getBrowserTabByNotificationId(notificationId);
        var visited = tab.getLastVisited();
        console.log(visited);
        callback(visited);
    };
    TabsManager.prototype.onTabRemoved = function(data, callback)
    {
        TabsMng.getTab(data.identifier).onRemoved(callback);
    };

    function establishPlusPrivacyWebsiteCommunication(tabId)
    {
        insertJavascriptFile(tabId, "operando/modules/communication/message-relay.js");
        chrome.tabs.executeScript(tabId,
            {
                file: "operando/modules/communication/extension-is-installed.js",
                runAt: "document_start",
                allFrames: false
            }, function()
            {});
    }

    function checkConnectWithSNApisUrls(tabId, changeInfo, tab)
    {
        if (changeInfo.url && urlIsApiUrl(changeInfo.url) == true)
        {
            chrome.tabs.insertCSS(tabId,
                {
                    file: "operando/modules/pfb/css/style.css",
                    runAt: "document_start"
                }, function()
                {
                    var notificationId = (new Date()).getTime();
                    var extensionId = chrome.runtime.id;
                    chrome.tabs.executeScript(tabId,
                        {
                            code: "var notificationId=" + notificationId + ";var extensionId='" + extensionId + "';"
                        }, function()
                        {
                            chrome.tabs.executeScript(tabId,
                                {
                                    file: "operando/modules/pfb/hideSNContent.js",
                                    runAt: "document_start"
                                }, function()
                                {
                                    TabsMng.getTab(tabId).setNotification(notificationId);
                                });
                        });
                });
        }
    }

    function init()
    {
        chrome.tabs.query(
            {
                url: "*://" + ExtensionConfig.WEBSITE_HOST + "/*"
            }, function(tabs)
            {
                tabs.forEach(function(tab)
                {
                    establishPlusPrivacyWebsiteCommunication(tab.id);
                });
            });
    }

    function urlIsApiUrl(url)
    {
        var facebookPattern = new RegExp("facebook.com/((v[0-9]{1,2}.[0-9]{1,2})|(dialog/oauth))");
        switch (true)
        {
            case url.indexOf("api.twitter.com/oauth/") >= 0:
                return true;
                break;
            case url.indexOf("accounts.google.com/signin/oauth/") >= 0:
                return true;
                break;
            case url.indexOf("linkedin.com/uas/oauth2/") >= 0:
                return true;
                break;
            case facebookPattern.test(url):
                return true;
                break;
            default:
                return false;
        }
    }

    function isGoodToAddInHistory(url)
    {
        if (url)
        {
            if (url.indexOf("google.com") == -1 && url.indexOf("facebook.com") == -1 && url.indexOf("linkedin.com") == -1 && url.indexOf("twitter.com") == -1)
            {
                return true;
            }
        }
        return false;
    }
    chrome.webNavigation.onHistoryStateUpdated.addListener(function(details)
    {
        var tabId = details.tabId;
        if (isGoodToAddInHistory(details.url))
        {
            TabsMng.getTab(tabId).addUrlInHistory(details.url);
        }
    });
    var TabsMng = exports.TabsManager = new TabsManager();
    bus.registerService(exports.TabsManager.__proto__);
    return exports;
})();
/**
 * Created by Rafa on 4/30/2018.
 */
