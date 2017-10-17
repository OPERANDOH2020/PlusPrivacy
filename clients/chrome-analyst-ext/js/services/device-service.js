var ExtensionConfig = new Config();
var SERVER_PROTOCOL = ExtensionConfig.SERVER_HOST_PROTOCOL;
var WEBSITE_HOST = ExtensionConfig.WEBSITE_HOST;

angular.module("app").factory("deviceService", function(){

    var DeviceService;
    DeviceService = (function () {

        function DeviceService() {

        }

        function saveDeviceId(deviceId){
            chrome.storage.local.set({"deviceId": deviceId}, function () {
                chrome.cookies.set({
                    url:SERVER_PROTOCOL+"://"+WEBSITE_HOST,
                    name:"analystDeviceId",
                    value:deviceId,
                    expirationDate:parseInt(Date.now()/1000)+946080000,
                    secure:SERVER_PROTOCOL === "https"?true:false});
            });
        };

        DeviceService.prototype.getDeviceId = function(callback){
            var deviceId = null;
            chrome.storage.local.get("analystDeviceId",function(response){
                if(!response.deviceId) {
                    chrome.cookies.getAll({url:SERVER_PROTOCOL+"://"+WEBSITE_HOST,name:"analystDeviceId",secure:SERVER_PROTOCOL === "https"?true:false},function(cookies){
                        if(cookies.length){
                            var cookie = cookies[0];
                            deviceId = cookie.value;
                        }
                        else {
                            deviceId = new Date().getTime().toString(16) + Math.floor(Math.random() * 10000).toString(16);
                            saveDeviceId(deviceId);
                        }
                        callback(deviceId);

                    });

                }else{
                    callback(response.deviceId);
                }
            });
        };

        DeviceService.prototype.associateUserWithDevice = function(callback){
            DeviceService.prototype.getDeviceId(function(deviceId){
                var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",deviceId);
                handler.onResponse("device_registered",function (swarm) {
                    callback();
                    console.log("Device id is: ",deviceId);
                });

                handler.onResponse("failed",function (swarm) {
                    console.log(swarm.error);
                });
            });
        };
        DeviceService.prototype.disassociateUserWithDevice = function(callback){
            DeviceService.getDeviceId(function(deviceId){
                var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",deviceId,true);
                handler.onResponse("device_registered",function (swarm) {
                    callback();
                });

                handler.onResponse("failed",function (swarm) {
                    console.log(swarm.error);
                });
            });
        };

        return DeviceService;
    })();

    if (typeof(window.angularDeviceService) === 'undefined' || window.angularDeviceService === null) {
        window.angularDeviceService = new DeviceService();
    }

    return window.angularDeviceService;

});