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
                    self.home("Notification Identifier Registered")
                }
            }))
        }
    },

    registerDeviceId:function(deviceId,disassociate){
        this.deviceId = deviceId;
        this.userId = disassociate?-1:this.meta.userId; //if disassociate is true, it means that the user logged out so the link between the device and the user must be dropped
        this.swarm("registerDevice");
    },
    
    registerDevice:{
        node:"UDEAdapter",
        code:function(){
            var self = this;
            registerDevice(this.deviceId,this.userId,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home("Device Registered")
                }
            }))
        }
    },

    registerApplication:function(deviceId,applicationId,applicationDescription){
        this.deviceId = deviceId;
        this.applicationId = applicationId;
        this.applicationDescription = applicationDescription
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

    }

};
udeSwarming;

