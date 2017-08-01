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
thisAdapter = core.createAdapter("AnalyticsAdapter");

var container = require('safebox').container;
var apersistence = require('apersistence');
var uuid = require('node-uuid');
var persistence = undefined;
var flow = require('callflow');
var geolocator = require('geoip-lite');

function registerModels(callback){
    var models = [
        {
            modelName:"RegistrationAnalytic",
            dataModel : {
                userId:{
                    type:"string",
                    pk:true,
                    length:255,
                    index:true
                },
                email:{
                    type: "string",
                    length:255,
                    index:true
                },
                country:{
                    type: "string",
                    length:255,
                    default:'UNKNOWN'
                },
                date:{
                    type:"datetime"
                }
            }
        },
        {
            modelName:"LoginAnalytic",
            dataModel:{
                id:{
                    type:"string",
                    pk:true,
                    length:255
                },
                userId:{
                    type:"string",
                    length:255
                },
                date:{
                    type:"datetime"
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

container.declareDependency("AnalyticsAdapter",['mysqlPersistence'],function(outOfService,mysqlPersistence){
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }else{
                console.log("Analytics adapter available");
            }
        })
    } else {
        console.log("Disabling AnalyticsAdapter...");
    }
});

addRegistration = function(userId,userEmail,ip,callback){
    
    persistence.lookup("RegistrationAnalytic",userId,function (err,registrationAnalytic) {


        if(err){
            callback(err)
        }else{
            if(!registrationAnalytic.__meta.freshRawObject){
                callback(new Error("User already registered"))
            }else{

                var geolocation = geolocator.lookup(ip)
                if(geolocation && geolocation.country){
                    registrationAnalytic["country"] = geolocator.lookup(ip)['country'];
                }
                registrationAnalytic["email"] = userEmail;
                registrationAnalytic["date"] = new Date();
                
                persistence.save(registrationAnalytic,callback)
            }
        }
    })
};

addLogin = function(userId,callback){
    flow.create("registerModels",{
        begin:function(){
            var loginId = uuid.v1();
            persistence.lookup("LoginAnalytic",loginId, this.continue("gotLoginAnalytic"));
        },
        gotLoginAnalytic:function(err, loginAnalytic){
            if(err){
                callback(err)
            }else{
                if(loginAnalytic.__meta.freshRawObject){
                    this.begin();
                }else{
                    loginAnalytic["userId"] = userId;
                    loginAnalytic["date"] = new Date();
                    persistence.save(loginAnalytic,callback)
                }
            }
        }
    })();
};
