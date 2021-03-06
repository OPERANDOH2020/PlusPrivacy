/**
 * Created by ciprian on 4/20/17.
 */




var udeSwarming = {
    updateNotificationToken:function(deviceId,notificationId){
        /*
            Upon login a user must request a notification token from GCM to that he could receive push-notifications. That token must be registered in the UDE adapter.
            Upon logout the user must update the GCM notification token to -1 thus signaling that it no longer can/wishes to receive notifications on that particular device.
         */

        this.deviceId = deviceId;
        this.notificationId = notificationId;
        this.swarm('updateNotificationId')
    },
    updateNotificationId:{
        node:"UDEAdapter",
        code:function(){
            var self = this;
            updateNotificationIdentifier(this.deviceId,this.notificationId,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home("success");
                }
            }))
        }
    },

    registerDeviceId:function(deviceId,disassociate){
        this.deviceId = deviceId;
        this.userId = disassociate?-1:this.meta.userId; //if disassociate is true, it means that the user logged out so the link between the device and the user must be dropped
        this.swarm("registerDevice");
    },

    uninstalledOnDevice:function(deviceId){
        this.deviceId = deviceId;
        this.swarm("uninstalledDevice")
    },

    registerDevice:{
        node:"UDEAdapter",
        code:function(){
            var self = this;
            registerDevice(this.deviceId,this.userId,S(function(err,result){
                if(err){
                    self.error = err.message;
                    self.home('failed');
                }else{
                    self.home("device_registered")
                }
            }))
        }
    },

    registerApplication:function(deviceId,applicationId,applicationDescription){
        this.deviceId = deviceId;
        this.applicationId = applicationId;
        this.applicationDescription = applicationDescription;
        this.swarm('registerApp');
    },
    registerApp:{
        node:"UDEAdapter",
        code:function(){
            var self = this;
            registerApplicationInDevice(this.applicationId,this.deviceId,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    registerApplication(self.applicationId,self.applicationDescription,S(function(err,result){
                        if(err){
                            self.err = err.message;
                            self.home('failed')
                        }else{
                            self.home('Application Registered');
                        }
                    }))
                }
            }))
        }
    },

    getApplicationsOnDevice:function(deviceId){
        this.deviceId = deviceId;
        this.swarm("getApplications");
    },
    getApplications:{
        node:"UDEAdapter",
        code:function(){
            var self = this;
            getApplicationsForDevice(this.deviceId,S(function(err,result){
                if(err){
                    self.err = err;
                    self.home('failed')
                }else{
                    self.applicationDescriptions = result;
                    self.home("Got descriptions")
                }
            }))
        }
    },

    uninstalledDevice:{
        node:"UDEAdapter",
        code: function () {
            var self = this;
            getFilteredDevices({deviceId: this.deviceId}, S(function (err, devices) {
                if (err) {
                    console.error(err);
                }
                else {
                    var deviceInfo = {deviceId:self.deviceId};
                    if(devices.length===0){
                          console.log("Device was not registered!");
                    }
                    else{
                        var device = devices[0];
                        deviceInfo.deviceUserId = device.userId;
                        self.swarm("removeDeviceFromRecords");
                    }
                }
            }));
        }
    },
    removeDeviceFromRecords:{
        node:"UDEAdapter",
        code: function () {
            var self = this;
            removeDeviceFromSystem(self.deviceId, S(function (err,device) {
                if(err){
                    console.error(err);
                }
            }));
        }
    }

};
udeSwarming;

