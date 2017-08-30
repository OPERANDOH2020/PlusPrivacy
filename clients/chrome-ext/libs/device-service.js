var bus = require("bus-service").bus;
var deviceService = exports.deviceService = {


    saveDeviceId:function(deviceId){
        chrome.storage.local.set({"deviceId": deviceId}, function () {
            chrome.cookies.set({
                url:ExtensionConfig.SERVER_HOST_PROTOCOL+"://"+ExtensionConfig.WEBSITE_HOST,
                name:"deviceId",
                value:deviceId,
                expirationDate:parseInt(Date.now()/1000)+946080000,
                secure:true});
            }
        );
    },

    getDeviceId : function(callback){
        var deviceId = null;

        chrome.storage.local.get("deviceId",function(response){
            if(!response.deviceId) {
                chrome.cookies.getAll({url:ExtensionConfig.SERVER_HOST_PROTOCOL+"://"+ExtensionConfig.WEBSITE_HOST,name:"deviceId",secure:true},function(cookies){
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

    associateUserWithDevice:function(success_callback,error_callback){
        deviceService.getDeviceId(function(deviceId){
            var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",deviceId);
            handler.onResponse("device_registered",function (swarm) {
                console.log("Device id is: ",deviceId);
                success_callback();
            });

            handler.onResponse("failed",function (swarm) {
                error_callback(swarm.error);
            });
        });
    },

    disassociateUserWithDevice:function(success_callback,error_callback){
        /*
         There is a little bug here. However, in the next version this feature will disappear so there is no point in trying to fix it at the moment.
         */

        deviceService.getDeviceId(function(deviceId){

            var handler = swarmHub.startSwarm("UDESwarm.js","registerDeviceId",deviceId,true);
            handler.onResponse("device_registered",function (swarm) {
                console.log("Device id is: ",deviceId);
                success_callback();
            });

            handler.onResponse("failed",function (swarm) {
                error_callback(swarm.error);
            });
        });
    }

};
bus.registerService(deviceService);