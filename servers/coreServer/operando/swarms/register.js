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

var registerSwarming = {

    registerNewUser: function (newUserData) {
        this.newUser = newUserData;
        this.swarm("verifyUserData");
    },


    verifyUserData: {
        node: "UsersManager",
        code: function () {
            var self = this;
            newUserIsValid(self.newUser, S(function (err, user) {
                if (err) {
                    console.log(err);
                    self.status = "error";
                    self.error = err.message;
                    self.newUser = {};
                    self.home("error");
                } else {
                    subscribeUserToNewsletter(user['email']);
                    self.user = user;
                    var activationLink = "https://" + thisAdapter.config.Core.operandoHost + "/activate/?confirmation_code=" + user.activationCode;
                    startSwarm("emails.js", "sendEmail", "no-reply@" + thisAdapter.config.Core.operandoHost,
                        user['email'],
                        "Activate account",
                        "<p>Your account has been registered <br/>To activate it, please access the following link:<a href='"+activationLink+"'>"+activationLink+"</a></p>");

                    startSwarm("analytics.js","addRegistration",user.email,user.userId);

                    self.swarm("setRealIdentity");
                }    
            }))
        }
    },

    setRealIdentity :{
        node:"IdentityManager",
        code:function(){
            var self = this;
            setRealIdentity(this.user, S(function(err, identity){
                if(err){
                    console.log(err);
                    self.error = err.message;
                    self.home('error');
                }
                else{
                    console.log("Real identity added", identity);
                    self.home("success");
                }
            }));
        }
    },

    verifyValidationCode: function (validationCode) {
        this.validationCode = validationCode;
        this.swarm("validateCode");
    },

    validateCode:{
        node:"UsersManager",
        code:function(){
            var self = this;
            activateUser(this.validationCode, S(function (err, user) {
                if (err) {                      
                    console.log(err);
                    self.error = err.message;
                    self.home("failed");
                } else {
                    self.activatedUserId = user.userId;
                    self.swarm("createUserSession");
                }
            }))
        }
    },

    createUserSession:{
        node:"SessionManager",
        code:function(){
            var self = this;
            var sessionData = {
                userId: this.activatedUserId,
                sessionId: this.getSessionId()
            };
            createOrUpdateSession(sessionData, S(function (error, session) {
                if (error) {
                    console.log(error);
                }
                else {
                    self.validatedUserSession = session;
                    self.home("success");
                }
            }));
        }
    },
    
    sendActivationCode:function (userEmail) {
        this.email = userEmail;
        this.swarm("getActivationCode");
    },
    getActivationCode:{
        node:"UsersManager",
        code:function(){
            var self = this;
            getUserId(self.email,S(function(err,userId){
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                } else {
                    getUserInfo(userId,S(function(err,user){
                        if (err) {
                            self.error = err.message;
                            self.home("failed");
                        }else if(user.activationCode=="0"){   //  0=="0"  is true
                            self.error = "Account already activated";
                            self.home("failed");
                        }else {
                                var activationUrl = "https://" + thisAdapter.config.Core.operandoHost + "/activate/?confirmation_code=" + user.activationCode;
                                startSwarm("emails.js", "sendEmail", "no-reply@" + thisAdapter.config.Core.operandoHost,
                                    user['email'],
                                    "Activate account",
                                    "<p>Your account has been registered <br/>To activate it, please access the following link:<br/><a href=\""+activationUrl+"\">"+activationUrl+"</a></p>");
                                self.home("success");
                            }
                        }
                    ))
                }
            }))
        }
    }
}


registerSwarming;