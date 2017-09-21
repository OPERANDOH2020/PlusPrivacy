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

var emailsSwarming = {
    sendEmail:function(from,to,subject,content,swarmId){
        this['from'] = from;
        this['to'] = to;
        this['subject'] = subject;
        this['content'] = content;
        //Temporary until Sanica deals with the swarms
        if(swarmId) {
            this.meta['swarmId'] = swarmId;
        }
        this.swarm('deliverEmail');
    },
    deliverEmail:{
        node: "EmailAdapter",
        code: function () {
            var self = this;
            sendEmail(self['from'], self['to'], self['subject'], self['content'], S(function (err, deliveryResult) {
                delete self['from'];
                delete self['to'];
                delete self['subject'];
                delete self['content'];
                delete self['receiverId'];

                if (err) {
                    self.error = err.message;
                    self.home('emailDeliveryUnsuccessful');
                } else {
                    self.deliveryResult = deliveryResult;
                    self.home('emailDeliverySuccessful');
                }
            }))
        }
    },    
    getEmailHost:function(){
        this.swarm("getHost")    
    },
    getHost:{
        node:"EmailAdapter",
        code:function(){
            try {
                this.host = thisAdapter.config.Core.operandoHost;
                this.home("gotEmailHost")
            }catch(err){
                console.log(err);
                
                this.err = e.message;
                this.home('failed');
            }
        }
    },

    sendMultipleEmails:function(from,to,subject,content,swarmId){
        this['from'] = from;
        this['subject'] = subject;
        this['content'] = content;
        if(swarmId) {
            this.meta['swarmId'] = swarmId
        }
        if (Array.isArray(to)) {
            var emailRegex = "@[a-zA-Z0-9]+.";
            this.addresses = to.filter(function (user) {
                return user.match(emailRegex) !== null;
            });

            if (this.addresses.length === to.length) {
                this.swarm('deliverToMultipleAddresses');
            } else {
                this.users = to.filter(function (user) {
                    return user.match(emailRegex) === null;
                });
                this.swarm("getUserEmails");
            }
        } else {
            this.zone = to;
            this.swarm("getUsersInZone");
        }
    },
    getUsersInZone:{
        node:"UsersManager",
        code:function(){
            var self = this;
            usersInZone(this.zone, S(function (err, users) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    self.addresses = users.map(function (user) {return user.email;});
                    self.swarm("deliverToMultipleAddresses");
                }
            }))
        }
    },
    getUserEmails:{
        node:"UsersManager",
        code:function(){
            var self = this;

            filterUsers({"userId":this.users},S(function(err,users){
                if(err){
                    self.err = err.message;
                    self.home("emailDeliveryUnsuccessful")
                }else{
                    self.addresses = self.addresses.concat(users.map(function(user){
                        return user.email;
                    }))
                    self.swarm("deliverToMultipleAddresses");
                }
            }));
        }
    },
    deliverToMultipleAddresses:{
        node: "EmailAdapter",
        code: function () {
            var self = this;
            var remainingToDeliver = self.addresses.length;
            this.failures = [];

            this.addresses.forEach(function(address){
                sendEmail(self['from'], address, self['subject'], self['content'], S(function (err, deliveryResult) {
                    if (err) {
                        self.failures.push(address);
                    }
                    remainingToDeliver--;
                    if (remainingToDeliver === 0) {
                        self.home("emailDeliverySuccessful")
                    }
                }))    
            });
        }
    }
};

emailsSwarming;
