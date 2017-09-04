var bus = require("bus-service").bus;
var deviceService = exports.deviceService = {


    saveDeviceId:function(deviceId){
        chrome.storage.local.set({"deviceId": deviceId}, function () {
            chrome.cookies.set({
                url:ExtensionConfig.SERVER_HOST_PROTOCOL+"://"+ExtensionConfig.WEBSITE_HOST,
                name:"deviceId",
                value:deviceId,
                expirationDate:parseInt(Date.now()/1000)+946080000,
                secure:ExtensionConfig.SERVER_HOST_PROTOCOL === "https"?true:false});
            }
        );
    },

    getDeviceId : function(callback){
        var deviceId = null;

        chrome.storage.local.get("deviceId",function(response){
            if(!response.deviceId) {
                chrome.cookies.getAll({url:ExtensionConfig.SERVER_HOST_PROTOCOL+"://"+ExtensionConfig.WEBSITE_HOST,name:"deviceId",secure:ExtensionConfig.SERVER_HOST_PROTOCOL === "https"?true:false},function(cookies){
                    if(cookies.length){
                        var cookie = cookies[0];
                        deviceId = cookie.value;
                    }
                    else {
                        deviceId = new Date().getTime().toString(16) + Math.floor(Math.random() * 10000).toString(16);
                        deviceService.saveDeviceId(deviceId);
                    }
                    callback(deviceId);

                });

            }else{
                callback(response.deviceId);
            }

        });

    },

    associateUserWithDevice:function(){
        deviceService.getDeviceId(function(deviceId){
            var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",deviceId);
            handler.onResponse("device_registered",function (swarm) {
                console.log("Device id is: ",deviceId);
            });

            handler.onResponse("failed",function (swarm) {
               console.log(swarm.error);
            });
        });
    },

    disassociateUserWithDevice:function(callback){
        deviceService.getDeviceId(function(deviceId){
            var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",deviceId,true);
            handler.onResponse("device_registered",function (swarm) {
                callback();
            });

            handler.onResponse("failed",function (swarm) {
                console.log(swarm.error);
            });
        });
    }

};
bus.registerService(deviceService);