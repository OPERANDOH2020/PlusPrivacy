/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var core = require("swarmcore");
thisAdapter = core.createAdapter("UDEAdapter");

var container = require('safebox').container;
var apersistence = require('apersistence');
var uuid = require('node-uuid');
var persistence = undefined;
var flow = require('callflow');


function registerModels(callback){
    var models = [
        {
            modelName:"UserDevice",
            dataModel : {
                deviceId:{
                    type:"string",
                    pk:true,
                    length:255
                },
                userId:{
                    type: "string",
                    length:255,
                    index:true
                },
                notificationIdentifier:{
                    type: "string",
                    length:255,
                    default:-1
                },
                applications:{
                    type:"array:DeviceApplicationMapping",
                    relation:"deviceId:deviceId"
                }
            }
        },
        {
            modelName:"DeviceApplicationMapping",
            dataModel:{
                mappindId:{
                    type:"string",
                    pk:true,
                    length:255
                },
                deviceId:{
                    type:"string",
                    length:255
                },
                applicationId:{
                    type:"string",
                    length:255
                },
                device:{
                    type:"UserDevice",
                    relation:"deviceId:deviceId"
                },
                application:{
                    type:"Application",
                    relation:"applicationId:applicationId"
                }
            }
        },
        {
            modelName:"Application",
            dataModel : {
                applicationId:{
                    type:"string",
                    pk:true,
                    length:255
                },
                applicationDescription:{
                    type: "JSON",
                    length:255,
                    index:true
                },
                applicationName:{
                    type:"string",
                    length:255
                }
            }
        }
    ];

    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                persistence.registerModel(model.modelName,model.dataModel,self.continue("registerDone"));
            });

        },
        registerDone:function(err,result){
            if(err) {
                this.errs.push(err);
            }
        },
        end:{
            join:"registerDone",
            code:function(){
                if(callback && this.errs.length>0){
                    callback(this.errs);
                }else{
                    callback(null);
                }
            }
        }
    })()
}

container.declareDependency("UDEAdapter",['mysqlPersistence'],function(outOfService,mysqlPersistence){
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }else{
                console.log("UDE adapter available");
            }
        })
    } else {
        console.log("Disabling UDEAdapter...");
    }
});

registerDevice = function(deviceId,userId,callback){
    persistence.lookup("UserDevice",deviceId,function (err,result) {
        if(err){
            callback(err)
        }else{
            result.userId = userId;
            persistence.save(result,callback);
        }
    })
};

updateNotificationIdentifier = function(deviceId, notificationIdentifier,callback){
    persistence.findById("UserDevice",deviceId,function (err,result) {
        if(err){
            callback(err)
        }else if(result === null) {
            callback(new Error("No device with id "+deviceId))
        } else{
            result.notificationIdentifier = notificationIdentifier;
            persistence.save(result,callback);
        }
    })
}

registerApplication = function(applicationId,description, callback){
    persistence.lookup("Application",applicationId,function (err,result) {
        if(err){
            callback(err)
        }else{
            result.applicationDescription = description;
            persistence.save(result,callback);
        }
    })
}

registerApplicationInDevice = function(applicationId,deviceId,callback){
    persistence.filter("DeviceApplicationMapping",{"applicationId":applicationId,"deviceId":deviceId},function (err,result) {
        if(err){
            callback(err)
        }else if(result.length>0){
            callback(new Error("Application already registered"));
        }else
        {
            var newMapping = apersistence.createRawObject("DeviceApplicationMapping",uuid.v1());
            newMapping.applicationId = applicationId;
            newMapping.deviceId = deviceId;
            persistence.save(newMapping,callback);
        }
    })
}

deleteUserDevices = function(userId, callback){

    flow.create("registerModels",{

        begin:function(){
            this.errs = [];
            persistence.filter("UserDevice",{userId: userId}, this.continue("getDevices"));
        },
        getDevices:function(err, devices){
            var self = this;
            if(err){
                callback(err);
            }
            else  if(devices.length>0){
                devices.forEach(function(device){
                    persistence.delete(device, self.continue("waitDevicesDeletion"));
                })
            }else{
                callback(undefined);
            }
        },
        waitDevicesDeletion:function(err){
            if(err){
                this.errs.push(err);
            }
        },
        end:{
            join:"waitDevicesDeletion",
            code:function(){
                if(this.errs.length>0){
                    callback(this.errs[0]);
                }else{
                    callback(undefined);
                }
            }
        }
    })();


}

getFilteredDevices = function(filter,callback){
    persistence.filter("UserDevice",filter,callback);
}