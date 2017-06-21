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

    }
};

emailsSwarming;
