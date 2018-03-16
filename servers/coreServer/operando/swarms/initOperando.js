/**
 * Created by ciprian on 06.12.2016.
 */


//TO DO: verify first that the users are not already created!!!!

var initOperando = {
    meta: {
        name: "initOperando.js"
    },
    init:function(){
        console.log("Initializing operando");
        this.swarm("createDefaultOrganisations");
        this.swarm("addDefaultNotificationsInSystem");
    },
    createDefaultOrganisations:{
        node:"UsersManager",
        code:function(){
            var self = this;

            function createDefaultOrganisations(callback) {

                var defaultOrganisations = [
                    {
                        organisationId: "SystemAdministrators",
                        displayName: "System Administrators"
                    },
                    {
                        organisationId: "Public",
                        displayName: "OEPRANDO PUBLIC"
                    },
                    {
                        organisationId: "Analysts",
                        displayName: "Analysts"
                    },
                    {
                        organisationId: "OSP",
                        displayName: "OSP"
                    },
                    {
                        organisationId: "PSP",
                        displayName: "PSP"
                    }
                ];
                var createdOrganisations = [];
                var errors = [];
                defaultOrganisations.forEach(function (organisation) {
                    createOrganisation(organisation, S(organisationsCallback));
                });

                function organisationsCallback(err, result) {
                    if (err && !err.message.match("already exists")) {
                        errors.push(err)
                    } else {
                        createdOrganisations.push(result);
                    }
                    if (createdOrganisations.length+errors.length === defaultOrganisations.length) {
                        if(errors.length>0){
                            callback(errors);
                        }
                        else {
                            callback(undefined,createdOrganisations);
                        }
                    }
                }
            }

            createDefaultOrganisations(function(err,result){
                if(err){
                    console.log("Could not create the default organisations\nErrors:",err,"\nAborting init swarm...")
                }else{
                    console.log("The default organisations were created");

                    self.swarm("createDefaultZones");
                }
            })
        }
    },
    createDefaultZones:{
        node:"UsersManager",
        code:function(){
            var self = this;
            function createDefaultZones(callback) {
                var defaultZones = [
                         "ALL_USERS",
                         "iOS",
                         "Android",
                         "Extension",
                         "Analysts",
                         "Admin"
                ];
                var createdZones = [];
                var errors = [];
                defaultZones.forEach(function (zone) {
                    createZone(zone, S(zoneCallback));
                });

                function zoneCallback(err, result) {
                    if (err && !err.message.match("already exists")) {
                        errors.push(err)
                    } else {
                        createdZones.push(result);
                    }
                    if (createdZones.length+errors.length === defaultZones.length) {
                        if(errors.length>0){
                            callback(errors);
                        }
                        else {
                            callback(undefined,createdZones);
                        }
                    }
                }
            }
            createDefaultZones(function(err,result){
                if(err){
                    console.log("Could not create the default zone\nErrors:",err,"\nAborting init swarm...")
                }else{
                    console.log("The default zones were created");
                    self.swarm("createDefaultUsers");
                }
            })
        }
    },
    createDefaultUsers: {
        node: "UsersManager",
        code: function () {
            var self = this;

            function createDefaultUsers(callback) {
                var uuid = require('node-uuid');
                var users = [
                    {
                        password: "swarm",
                        email: "admin@"+thisAdapter.config.Core.operandoHost,
                        organisationId: "SystemAdministrators",
                        activationCode:"0"
                    },
                    {
                        password: "operando",
                        email: thisAdapter.config.Core.adminEmail,
                        organisationId: "SystemAdministrators",
                        activationCode:"0"
                    },
                    {
                        password: "guest",
                        email: "guest@operando.eu",
                        organisationId: "Public",
                        activationCode:"0"
                    },
                    {
                        password: "analyst",
                        email: "analyst@rms.ro",
                        organisationId: "Analysts",
                        activationCode:"0"
                    },
                    {
                        password: "psp4",
                        email: "psp@rms.ro",
                        organisationId: "PSP",
                        activationCode:"0"
                    },
                    {
                        password: "wizard",
                        email: "privacy_wizard@rms.ro",
                        organisationId: "Public",
                        activationCode:"0"
                    },
                    {
                        password: "haraka",
                        email: "iAmAnEmailServer@plusprivacy.com",
                        organisationId: "Public",
                        activationCode:"0"
                    },
                    {
                        password: "test",
                        email: "test@"+thisAdapter.config.Core.operandoHost,
                        organisationId: "Public",
                        activationCode:"0"
                    }
                ];

                var createdUsers = [];
                var errors = [];

                users.forEach(function (userData) {
                    createUser(userData, S(usersCallback))
                });

                function usersCallback(err, result) {

                    if (err && (err.message.match("already exists")===null)) {
                        errors.push(err)
                    } else {
                        createdUsers.push(result);
                    };
                    
                    if ((createdUsers.length + errors.length) === users.length){
                        if (errors.length > 0) {
                            callback(errors);
                        }
                        else {
                            callback(undefined, createdUsers);
                        }
                    }
                }
            }
            
            
            console.log("CREATING DEFAULT USERS");
            
            createDefaultUsers(function (errors, result) {
                
                if (errors && errors.length>0) {
                    console.log("Could not create the default users\nErrors:",errors,"\nAborting init swarm...")
                } else {
                    console.log("The default users were created");
                    self.swarm("getAdminId");
                }
            });
        }
    },
    getAdminId:{
        node:"UsersManager",
        code:function(){
            var self = this;
            getUserId(thisAdapter.config.Core.adminEmail,S(function(err,adminId){
                if(err){
                    console.log("Could not retrieve the ID of the admin")
                }else{
                    self.adminId = adminId;
                    self.swarm("createDefaultIdentities");
                }
            }))
        }
    },
    createDefaultIdentities:{
        node:"IdentityManager",
        code:function(){
            var self = this;
            function createDefaultIdentities(callback) {
                var identities = ["help", "info", "webmaster", "web", "contact","support","pressrelease"].map(function (halfAlias, index) {
                    var identity = {
                        "email": halfAlias + "@" + thisAdapter.config.Core.operandoHost,
                        "userId": self.adminId,
                        "isReal": false,
                        "isDefault": false,
                        "deleted": false
                    };

                    if (index === 0) {
                        identity.isDefault = true;
                    }
                    return identity;
                });


                identities.push({
                    "email": thisAdapter.config.Core.adminEmail,
                    "userId": self.adminId,
                    "isReal": true,
                    "isDefault": false,
                    "deleted": false
                });


                var errors=[];
                var createdIdentities = [];
                identities.forEach(function(identity){
                    createIdentity(identity,S(function(err,result){
                        if(err && (err.message.match("already exists")===null)){
                            errors.push(err);
                        }else{
                            createdIdentities.push(result);
                        }

                        if(errors.length+createdIdentities.length === identities.length){
                            if(errors.length>0){
                                callback(errors,createdIdentities);
                            }else{
                                callback(undefined,createdIdentities);
                            }
                        }
                    }))
                });
            }

            createDefaultIdentities(function(errors, results){
                if(errors && errors.length>0){
                    console.log("Could not create admin identities\nErrors:",errors);
                }else{
                    console.log("The admin identities were created");
                }
            })
        }
    },

    addDefaultNotificationsInSystem:{
        node:"NotificationUAM",
        code:function(){
            generateSignupNotifications(function(err, notifications){
                if(err){
                    console.log(err.message);
                }
                else{
                    console.log("Generated ", notifications.length +" default notifications");
                }
            });
        }
    }
};

initOperando;