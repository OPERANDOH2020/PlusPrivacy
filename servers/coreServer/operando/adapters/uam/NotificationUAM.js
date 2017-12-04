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


var core = require ("swarmcore");
core.createAdapter("NotificationUAM");
var persistence = undefined;
var  container = require("safebox").container;
var flow = require("callflow");
var uuid = require('uuid');
var apersistence = require('apersistence');


var zoneTenantMappings = {
        "ALL_USERS":["ios","androidApp","chromeBrowserExtension","PlusPrivacyWebsite"],
        "Extension":["chromeBrowserExtension"],
        "iOS":["ios"],
        "Android":["androidApp"]
}

var signupNotifications = {
    privacy_questionnaire: {
        sender: "WatchDog",
        title: "Privacy Questionnaire",
        description: "You have not filled all your social network privacy settings yet. Doing so will tailor your social network privacy settings to your preferences. You can also optimize your social network privacy settings in a single click, using settings recommended by PrivacyPlus.",
        action_name:"social-network-privacy",
        zones:["ALL_USERS"]
    },
    identity: {
        sender: "WatchDog",
        title: "Add identity",
        description: "You have not yet generated alternative email identities. Doing so will enable you to sign up on websites without disclosing your real email.",
        action_name:"identity",
        zones:["ALL_USERS"]
    },
    feedback: {
        sender: "PlusPrivacy",
        title: "Welcome to PlusPrivacy!",
        description: "Welcome to PlusPrivacy! Please help us make PlusPrivacy better by providing feedback (see the feedback link on the sidebar). Thank you.",
        action_name:"feedback",
        zones:["Extension","Android"]
    },
    deals: {
        sender: "WatchDog",
        title: "Privacy deals",
        description: "You have not yet accepted any privacy deals. Privacy deals enable you to trade some of your privacy for valuable benefits.",
        action_name:"privacy-for-benefits",
        zones:["ALL_USERS"]
    },
    private_browsing: {
        sender: "WatchDog",
        title: "PrivateBrowsing",
        description: "Check the new feature: Private Browsing",
        action_name:"private_browsing",
        zones:["iOS","Android"]
    }
};


function registerModels(callback){

    var models = [
        {
            modelName: "Notification",
            dataModel: {
                notificationId: {
                    type: "string",
                    pk: true,
                    index: true,
                    length: 255
                },
                sender: {
                    type: "string",
                    length: 255
                },
                zones: {
                    type: "array:ZoneNotificationMapping",
                    relation: "notificationId:notificationId"
                },
                action_argument: {
                    type: "string",
                    length: 255
                },
                action_name: {
                    type: "string",
                    length: 255
                },
                title: {
                    type: "string",
                    length: 255
                },
                description: {
                    type: "string",
                    length: 1024
                },
                expirationDate: {
                    type: "datetime"
                },
                creationDate: {
                    type: "datetime"
                }
            }
        }, {
            modelName: "ZoneNotificationMapping",
            dataModel: {
                notification: {
                    type: "Notification",
                    relation:"notificationId:notificationId"
                },
                notificationId: {
                    type: "string",
                    length: 255,
                    index:true
                },
                zoneName: {
                    type: "string",
                    index: true,
                    length: 255
                },
                mappingId:{
                    type:"string",
                    pk:true,
                    length:254
                }
            }
        },
        {
            modelName: "DismissedNotifications",
            dataModel: {
                "id": {
                    type: "string",
                    length: 255,
                    pk: true
                },
                "userId": {
                    type: "string",
                    length: 255,
                    index: true
                },
                "notificationId": {
                    type: "string",
                    length: 255
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
                    console.log("\n\n\n\nERRORS:",this.errs);
                    callback(this.errs);
                }else{
                    callback(null);
                }
            }
        }
    })()
}

container.declareDependency("NotificationUAMAdapter", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }
        })

    } else {
        console.log("Disabling persistence...");
    }
});

createNotification = function (rawNotificationData, callback) {
    console.log(rawNotificationData);
    var notification = apersistence.createRawObject("Notification",uuid.v1());
    rawNotificationData.expirationDate = new Date(rawNotificationData.expirationDate);
    notification['action_name'] = rawNotificationData['actionType'];
    notification['action_argument'] = rawNotificationData['actionArgument'];
    persistence.externalUpdate(notification,rawNotificationData);
    notification.creationDate = new Date();
    persistence.save(notification, function(err, notification){
        var newAssociation = apersistence.modelUtilities.createRaw("ZoneNotificationMapping",uuid.v1().split("-").join(""));
        newAssociation.zoneName = rawNotificationData['zone'];
        newAssociation.notificationId = notification.notificationId;
        persistence.save(newAssociation,callback);
    });

};

deleteNotification = function (notificationId, callback) {
    flow.create("Delete Notification", {
        begin: function () {
            persistence.deleteById("Notification", notificationId, this.continue("deleteReport"));
        },
        deleteReport: function (err, obj) {
            callback(err, obj);
        }
    })();
};

updateNotification = function (notificationDump, callback) {
    flow.create("Update notification", {
        begin: function () {
            persistence.lookup("Notification", notificationDump.notificationId, this.continue("updateNotification"));
        },

        updateNotification: function (err, notification) {
            if (err) {
                callback(err, null);
            }

            else if (persistence.isFresh(notification)) {
                callback(new Error("Notification with id " + notification.notificationId + " was not found"), null);
            }
            else {
                persistence.externalUpdate(notification, notificationDump);
                persistence.saveObject(notification, callback);
            }
        }
    })();
};

getNotifications = function (userId, userZones, callback) {

    flow.create("Get notifications for user", {
        begin: function () {
            this.notifications = [];
            this.isDissmissed = {};
            this.errs = [];
            persistence.filter('DismissedNotifications',{"userId":userId},this.continue("gotDismissedNotifications"))
        },

        gotDismissedNotifications:function(err,dismissedNotifications){
            if(err){
                this.errs.push(err);
            }else{
                var self = this;
                dismissedNotifications.forEach(function(dismissedNotification){
                    self.isDissmissed[dismissedNotification.notificationId] = true;
                })
            }
            persistence.filter("ZoneNotificationMapping", {zoneName: userId}, this.continue("gotNotifications"));
            userZones.forEach(function(zone){
                    persistence.filter("ZoneNotificationMapping",{zoneName:zone},self.continue("gotNotifications"));
            })
        },

        gotNotifications:function(err,notificationsMappings){
            if(err){
                this.errs.push(err);
            }else{
                var self = this;
                notificationsMappings.forEach(function(notificationMapping){

                    notificationMapping.__meta.loadLazyFields(self.continue("loadNotifications"));

                })
            }
        },

        loadNotifications:function(err,lazyNotification){
            if (err) {
                console.error(err);
            }
            else {
                var notification = lazyNotification.notification;

                if (!this.isDissmissed[notification.notificationId]) {
                    var existingNotificationsIds = this.notifications.map(function(notification){return notification.notificationId});
                    if(existingNotificationsIds.indexOf(notification.notificationId)==-1){
                        this.notifications.push(notification);
                    }
                }
            }
        },

        deliverNotifications: {
            join:"loadNotifications",
            code:function () {
                if(this.errs.length>0){
                    callback(this.errs, this.notifications);
                }else{
                    callback(undefined,this.notifications)
                }
            }
        }
    })();
};



getAllUserNotifications = function (userId,userZones, callback){
    flow.create("Get all notificaitons for user", {
        begin: function () {
            this.notifications = [];
            this.isDissmissed = {};
            this.errs = [];
            persistence.filter('DismissedNotifications',{"userId":userId},this.continue("gotDismissedNotifications"))
        },

        gotDismissedNotifications:function(err,dismissedNotifications){
            if(err){
                this.errs.push(err);
            }else{
                var self = this;
                dismissedNotifications.forEach(function(dismissedNotification){
                    self.isDissmissed[dismissedNotification.notificationId] = true;
                })
            }
            persistence.filter("ZoneNotificationMapping", {zoneName: userId}, this.continue("gotNotifications"));
            userZones.forEach(function(zone){
                persistence.filter("ZoneNotificationMapping",{zoneName:zone},self.continue("gotNotifications"));
            })
        },
        gotNotifications:function(err,notificationsMappings){
            if(err){
                this.errs.push(err);
            }else{
                var self = this;
                notificationsMappings.forEach(function(notificationMapping){

                    notificationMapping.__meta.loadLazyFields(self.continue("loadNotifications"));

                })
            }
        },
        loadNotifications:function(err,lazyNotification){
            if (err) {
                console.error(err);
            }
            else {
                var notification = lazyNotification.notification;
                notification['isDismissed'] = this.isDissmissed[notification.notificationId]?true:false;
                this.notifications.push(notification);
            }
        },
        deliverNotifications: {
            join:"loadNotifications",
            code:function () {
                this.notifications=this.notifications.sort(function(a,b){
                    if(a.creationDate == null){
                        a.creationDate = new Date(0);
                    }

                    if(b.creationDate == null){
                        b.creationDate = new Date(0);
                    }
                   return b.creationDate.getTime() - a.creationDate.getTime();
                });
                if(this.errs.length>0){
                    callback(this.errs, this.notifications);
                }else{
                    callback(undefined,this.notifications)
                }
            }
        }
    })();
},

dismissNotification = function(userIdOrZone, notificationId, callback){
    var dismissedNotification = apersistence.createRawObject("DismissedNotifications",uuid.v1());
    dismissedNotification.userId = userIdOrZone;
    dismissedNotification.notificationId = notificationId;
    persistence.save(dismissedNotification,callback);
};

filterNotifications = function(filter,callback){
    persistence.filter("Notification",filter,callback);
}

generateSignupNotifications = function (callback) {


    flow.create("createSignupNotifications", {
        begin: function () {
            this.notifications = [];
            this.next("getNotificationsFromSystem");
        },

        getNotificationsFromSystem : function(){
            persistence.filter("Notification", {},this.continue("checkNotificationsFromSystem"));
        },
        checkNotificationsFromSystem: function(err, notifications){
            if(err){
                console.log(err.message)
            }
            else{
                this.existingNotifications = notifications;
                this.next("iterateNotifications");
            }
        },

        iterateNotifications: function () {

            var existingActions = this.existingNotifications.map(function(el){return el.action_name});
            var self = this;
            Object.keys(signupNotifications).forEach(function(key, index){
                if(existingActions.indexOf(signupNotifications[key]['action_name']) === -1){
                    self.next("createNotification",undefined,key, index);
                }
            });

        },
        createNotification: function (key, index) {
            var self = this;
            persistence.lookup("Notification", uuid.v1(), function (err, notification) {
                if (err) {
                    callback(err, null);
                }
                else {
                    for (var i in signupNotifications[key]) {
                        if(i!="zones"){
                            notification[i] = signupNotifications[key][i];
                        }
                    }
                    persistence.save(notification, self.continue("notificationCreated"));
                }
            });
        },
        notificationCreated:function(err, notification){
            //add to mapping

                Object.keys(signupNotifications).forEach(function(key, index){
                    if(notification['action_name'] === signupNotifications[key]['action_name']){
                        var zones = signupNotifications[key]['zones'];
                        console.log(zones);
                        zones.forEach(function(zoneName){
                            var newAssociation = apersistence.modelUtilities.createRaw("ZoneNotificationMapping",uuid.v1().split("-").join(""));
                            newAssociation.zoneName = zoneName;
                            newAssociation.notificationId = notification.notificationId;
                            persistence.save(newAssociation);
                        });
                    }
                });

            this.notifications.push(notification);
        },
        end:{
            join:"notificationCreated",
            code:function(){
                callback(null, this.notifications);
            }
        }

    })();
};

clearIdentityNotifications = function(userId){
    clearNotification(userId,signupNotifications.identity.action_name);
}

clearDealsNotifications = function(userId){
    clearNotification(userId,signupNotifications.deals.action_name);
}

clearSocialNetwork = function(userId){
    clearNotification(userId,signupNotifications.privacy_questionnaire.action_name);
}

clearNotification = function(userId, action_name){
    var self = this;
    flow.create("dismissIdentitiesNotifications", {

        begin:function(){
            if(!userId){
                console.log(new Error("userId is invalid"));
            }
            else{
                persistence.filter("Notification", {action_name: action_name}, this.continue("dismissNotificationsByAction"));
            }
        },
        dismissNotificationsByAction:function(err, notifications){

            if(err){
                console.log(err);
            }
            else{
                notifications.forEach(function(notification){
                    self.dismissNotification(userId, notification.notificationId, function(){
                        console.log("Notification dismissed by action");
                    });
                });
            }
        }


    })();
};


getTenantZones = function(userZones, tenant){
    var availableZones=[];
    userZones.forEach(function(zoneName){
        if(zoneTenantMappings[zoneName]){
            if(zoneTenantMappings[zoneName].indexOf(tenant)!=-1){
                availableZones.push(zoneName);
            }
        }
        else{//not in mappings
            availableZones.push(zoneName);
        }
    });
    return availableZones;
}


var admin = require("firebase-admin");
var serviceAccount = require("./firebaseAdmin.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://plusprivacy-ef5ac.firebaseio.com"
});

notifyUsers = function (receivers,notification,callback) {
    var toSend = {
        "title":notification.title,
        "description":notification.description?notification.description:"",
        "action_argument":notification.action_argument?notification.action_argument:"",
        "action_name":notification.action_name?notification.action_name:""
    }

    admin.messaging().sendToDevice(receivers, {"data":toSend}).then(function(result){
        callback();
    }).
    catch(callback);
};