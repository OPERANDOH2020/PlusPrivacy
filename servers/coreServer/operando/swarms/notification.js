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


var notificationSwarming = {
    getNotifications: function () {
        this.swarm("getUserZones");
    },

    getAllNotifications:function(showDismissedNotifications, index){
        this.showDismissedNotifications = showDismissedNotifications;
        this.currentIndex = index;
        this.swarm("getUserZones");
    },

    dismissNotification: function (notificationId) {
        this.userId = this.meta.userId;
        this.notificationId = notificationId;
        this.swarm("dismissUserNotification");
    },

    getUserZones: {
        node: "UsersManager",
        code: function () {
            var self = this;
            zonesOfUser(this.meta.userId, S(function (err, zones) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    self.zones = zones.map(function (zone) {
                        return zone.zoneName;
                    });
                    self.swarm("getUserNotifications");
                }
            }))
        }
    },
    getUserNotifications: {
        node: "NotificationUAM",
        code: function () {
            var self = this;
            if (this.showDismissedNotifications) {
                getAllUserNotifications(this.meta.userId, this.zones,S(function(err, notifications){
                    if (err) {
                        self.err = err.message;
                        console.log(err);
                        self.home('failed');
                    }
                    else {
                        self.totalNotificationsCount = notifications.length;
                        if(notifications.length>self.currentIndex){
                            if(notifications.length>self.currentIndex+10){
                                notifications = notifications.splice(self.currentIndex,10);
                            }
                            else{
                                notifications = notifications.splice(self.currentIndex,notifications.length);
                            }
                        }
                        else{
                            notifications = [];
                        }
                        self.notifications = notifications;
                        self.home("gotAllNotifications");
                    }
                }));
            }
            else {
                getNotifications(this.meta.userId, this.zones, S(function (err, notifications) {
                    if (err) {
                        self.err = err.message;
                        console.log(err);
                        self.home('failed');
                    }
                    else {
                        self.notifications = notifications;
                        self.home("gotNotifications");
                    }
                }));
            }
        }
    },

    dismissUserNotification: {
        node: "NotificationUAM",
        code: function () {
            var self = this;
            dismissNotification(this.userId, this.notificationId, S(function (err) {
                if (err) {
                    self.err = err.message;
                    console.log(err);
                    self.home('failed');
                }
                else {
                    self.home("notificationDismissed");
                }
            }));
        }
    },

    sendNotification: function (notification) {
        this.notification = notification;
        if(this.notification.zone){
            this.swarm("getReceiversFromZone")
        }else if(this.notification.users){
            this.swarm('validateUsers')
        }else{
            this.err = "Need to provide either the zone or the intended users in order to send a notification";
            this.home('failed');
        }
    },

    getReceiversFromZone: {
        node: "UsersManager",
        code: function () {
            var self = this;
            usersInZone(this.notification.zone, S(function (err, users) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    self.notification.users = users.map(function (user) {return user.userId;});
                    self.swarm("getUserDevices");
                }
            }))
        }
    },

    retrieveAllNotifications:{
        node:""
    },

    validateUsers:{
        node:"UsersManager",
        code:function() {
            //in case some users are provided with email addresses, here you extract their userIds


            var emailRegex = "@[a-zA-Z0-9]+.";
            var self = this;
            var usersByEmail = [];
            var usersById = [];

            self.notification.users.forEach(function (user) {
                if (user.match(emailRegex) !== null) {
                    usersByEmail.push(user);
                } else {
                    usersById.push(user);
                }
            });

            validateIds(function(err,validIds1){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else {
                    validateEmails(function (err, validIds2) {
                        if(err) {
                            self.err = err.message;
                            self.home('failed');
                        }else{
                            self.notification.users = validIds1.map(function(user){return user.userId}).concat(validIds2.map(function(user){return user.userId}));
                            if(self.notification.users.length===0){
                                self.err = "No valid users provided";
                                self.home('failed');
                            }else{
                                self.swarm("createZoneForNotification")
                            }
                        }
                    })
                }
            });

            function validateEmails(callback) {
                if(usersByEmail.length===0){
                    callback(undefined,[]);
                }else {
                    filterUsers({"email": usersByEmail}, S(callback))
                }
            }

            function validateIds(callback) {
                if(usersById.length===0){
                    callback(undefined,[]);
                }else {
                    filterUsers({"userId": usersById}, S(callback))
                }
            }
        }
    },


    createZoneForNotification:{
        node:"UsersManager",
        code:function(){
            var self = this;
            var newZoneName = "notification-"+new Date().toGMTString();
            createZone(newZoneName,S(function(err,result){
                if(err){
                    self.err = err.message;
                    self.home('failed')
                }else{
                    self.notification.zone = newZoneName;
                    var usersToAdd = self.notification.users.length;

                    self.notification.users.forEach(function (user) {
                        addUserToZone(user,newZoneName,S(function(err,result){
                            usersToAdd--;
                            if(usersToAdd===0){
                                self.swarm("getUserDevices");
                            }
                        }))
                    })
                }
            }))
        }
    },

    getUserDevices: {
        node: "UDEAdapter",
        code: function () {
            var self = this;
            getFilteredDevices({"userId": self.notification.users}, S(function (err, devices) {
                if (err) {
                    self.err = err.message;
                    self.home('failed')
                } else {
                    delete self.notification.users; // so we don't have to carry it anymore
                    
                    self.devicesPushNotificationTokens = devices.map(function (device) {return device.notificationIdentifier});
                    self.devicesPushNotificationTokens = self.devicesPushNotificationTokens.filter(function(token){
                        return token!==-1;
                    });
                    self.swarm('relayNotification')
                }
            }))
        }
    },
    relayNotification: {
        node: "NotificationUAM",
        code: function () {
            var self = this;
            self.notification.sender = this.meta.userId;
            createNotification(self.notification, S(function (err, notification) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    notifyUsers(self.devicesPushNotificationTokens, self.notification, S(function (err) {
                        console.log(arguments);
                        if (err) {
                            self.err = err.message;
                            self.home('failed')
                        } else {
                            self.home('notificationSent');
                        }
                    }))
                }
            }))
        }
    },

    getFilteredNotifications: function (filter) {
        if (!filter) {
            this.filter = {}
        } else {
            this.filter = filter;
        }
        this.swarm('filter');
    },
    filter: {
        node: "NotificationUAM",
        code: function () {
            var self = this;
            filterNotifications(this.filter, S(function (err, result) {
                if (err) {
                    self.err = err.message;
                    self.home('failed')
                } else {
                    self.notifications = result;
                    self.home('gotFilteredNotifications');
                }
            }))
        }
    },

    success: {
        node: "Core",
        code: function () {
            console.log("Returning Notifications");
            this.notifications = [{
                message: "Pellentesque semper augue sed suscipit fringilla. Etiam vitae gravida augue, id tempus enim.",
                title: "Security error FACEBOOK MESSENGER",
                type: "SECURITY",
                action: "UNINSTALL",
                targetId: "com.facebook.orca"
            },
                {
                    message: "Pellentesque semper augue sed suscipit fringilla. Etiam vitae gravida augue, id tempus enim. ",
                    title: "Security error FACEBOOK",
                    type: "PRIVACY",
                    action: "DISABLE",
                    targetId: "com.facebook.katana"
                },
                {
                    message: "Pellentesque semper augue sed suscipit fringilla. Etiam vitae gravida augue, id tempus enim. ",
                    title: "Security error INSTAGRAM",
                    type: "PRIVACY",
                    action: "DISABLE",
                    targetId: "com.instagram.android"
                }];
            this.home("success");
        }
    },

    EULAChange: function (url) {
        var notification = {};
        notification.title = "EULA change";
        notification.zone = "Analysts";
        notification.action = "Access link " + url;
        notification.description = "An EULA change was detected at the url " + url + "\nYou might want to check.";
        notification.creationDate = new Date();
        notification.sender = "Web Crawler";
        this.startSwarm("sendNotification",notification);

    },
    SettingsChange: function (url) {
        var notification = {};
        notification.title = "Settings change";
        notification.zone = "Analysts";
        notification.action = "Access link " + url;
        notification.description = "A setting change was detected at the url " + url + "\nYou might want to check.";
        notification.creationDate = new Date();
        notification.sender = "Web Crawler";
        this.startSwarm("sendNotification",notification);
    },

    registerInZone: function (zoneName) {
        var possibleZones = ['iOS', 'Android', 'Extension','FEEDBACK_SUBMITTED'];
        if (possibleZones.indexOf(zoneName) === -1) {
            this.err = "No such zone name";
            this.home('failed')
        } else {
            this.zone = zoneName;
            this.swarm('attachUserToZone');
        }
    },
    attachUserToZone: {
        node: "UsersManager",
        code: function () {
            var self = this;
            createZone(this.zone, S(function (err, result) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    addUserToZone(self.meta.userId, self.zone, S(function (err, result) {
                        if (err) {
                            self.err = err.message;
                            self.home('failed');
                        } else {
                            self.home('success');
                        }
                    }))
                }
            }))
        }
    }
}

notificationSwarming;