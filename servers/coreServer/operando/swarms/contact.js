/*
 * Copyright (c) 2017 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var contactSwarmming = {

    sendMessage:function(messageData){
        this.subject = messageData.subject;
        this.message = messageData.message;
        this.swarm("getUserEmail");
    },

    getUserEmail:{
        node:"UsersManager",
        code:function(){
            var self = this;
            getUserInfo(this.meta.userId,S(function(err,user){
               if(err){
                   self.error = err.message;
                   self.home("error");
               }
                else{
                   self.userEmail = user['email'];
                   self.swarm("deliverMessage");
               }
            }));
        }
    },

    deliverMessage:{
        node:"EmailAdapter",
        code:function(){
            var self = this;
            sendContactEmail(self.subject,self.message,self.userEmail,S(function(err, deliveryResult){
                if (err) {
                    self.error = err.message;
                    self.home('error');
                } else {
                    self.home('success');
                }
            }))
        }
    }
};

contactSwarmming;
