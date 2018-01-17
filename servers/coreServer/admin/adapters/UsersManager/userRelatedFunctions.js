/**
 * Created by ciprian on 3/23/17.
 */


const crypto = require('crypto');
var container = require("safebox").container;
var flow = require("callflow");
var uuid = require('uuid');
var passwordMinLength = 4;
var persistence = undefined;
var saltLength = 48;
var apersistence = require('apersistence');
var md5 = crypto.createHash('md5');


container.declareDependency("userFunctionality",["mysqlPersistence",'userRelatedTypes'],function(outOfService,mysqlPersistence,types){
    if(outOfService){
        console.log("Could not provide users-related functionality");
    }else{
        persistence = mysqlPersistence;
        console.log("User-related functionality available in UsersManager");
        return exports;
    }
});

exports.createUser = function (userData, callback) {
    persistence.filter("DefaultUser",{"email":userData.email},function(err,result){
        if(err){
            callback(err)
        }else if(result.length>0){
            callback(new Error("User with email "+userData.email+" already exists"));
        }else{
            var user = apersistence.createRawObject("DefaultUser",uuid.v1());

            if(userData.activationCode){
                user.activationCode = userData.activationCode
            }else{
                user.activationCode = new Buffer(user.userId).toString('base64');
            }
            if(thisAdapter.config.development === true){
                user.activationCode = "0";
            }
            

            userData.salt = crypto.randomBytes(saltLength).toString('base64');
            hashThisPassword(userData.password,userData.salt,function(err,hashedPassword){
                userData.password = hashedPassword;
                persistence.externalUpdate(user,userData);
                persistence.save(user,function(err,newUser){
                    if(err){
                        callback(err)
                    }else{
                        exports.addUserToZone(user.userId,"ALL_USERS",function(err,result){
                            if(err){
                                callback(err);
                            }else{
                                callback(undefined,user);
                            }
                        });
                    }
                })
            });
        }
    });
};

exports.filterUsers = function(conditions,callback){
    persistence.filterJson("DefaultUser",conditions,function(err,result){
         if(result.length>0){
             result = result.map(function (user) {
                 if(user.password) {
                     delete user.password;
                 }
                 if(user.salt) {
                     delete user.salt;
                 }
                 return user;
             })
         }
        callback(err,result)
    });
};

exports.deleteUser = function (userData,callback) {
    flow.create("delete user", {
        begin: function () {
            persistence.findById("DefaultUser", userData.userId, this.continue("info"))
        },
        info: function (err, user) {
            console.log(user['email']);
            if(err){
                callback(err);
            }
            else if(user['email'] === "guest@operando.eu"){
                callback(new Error("Guest cannot be deleted! Aborting..."));
            }
            else{
                persistence.deleteById("DefaultUser", userData.userId, this.continue("deleteReport"));
            }
        },
        deleteReport: function (err, obj) {
            callback(err, obj);
        }
    })();
};

exports.updateUser = function (userJsonObj, callback) {
    flow.create("update user", {
        begin: function () {
            persistence.lookup("DefaultUser", userJsonObj.userId, this.continue("updateUser"));
        },
        updateUser: function (err, user) {
            if (err) {
                callback(err, null);
            }
            else {
                if (persistence.isFresh(user)) {
                    callback(new Error("User with id " + userJsonObj.userId + " does not exist"), null);
                }
                else {
                    persistence.externalUpdate(user, userJsonObj);
                    persistence.saveObject(user, this.continue("updateReport"));
                }
            }
        },
        updateReport: function (err, user) {
            callback(err, user);
        }
    })();
};

exports.activateUser = function(activationCode,callback){
    var userId = new Buffer(activationCode,'base64').toString();
    persistence.findById("DefaultUser", userId, function(err,user){
        if(err){
            callback(err);
        }else if(!user){
            callback(new Error("No user with activation code "+activationCode));
        }else{
            user.activationCode = "0";
            persistence.saveObject(user,callback)
        }
    })
};

exports.newUserIsValid = function (newUser, callback) {
    //TO DO: Change name of the function. Something like : "createPublicUser"

    function emailIsValid(email){
        if(!email){
            return false;
        }
        else{
            var re = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
            return re.test(email);
        }
        return false;
    }

    function emailDomainIsAllowed(email){
        var systemDomain = thisAdapter.config.Core.operandoHost;
        if(email.indexOf(systemDomain) === -1){
            return false;
        }
        return true;
    }

    flow.create("user is valid", {
        begin: function () {
            if(emailIsValid(newUser.email) === false ){
                callback(new Error("emailIsInvalid"));
            }
            else if(emailDomainIsAllowed(newUser.email)){
                callback(new Error("This email address is not allowed"));
            }
            else if(!newUser.password || newUser.password.length < passwordMinLength){
                callback(new Error("Password must contain at least "+passwordMinLength+" characters"));
            }
            else{
                persistence.filter("DefaultUser", {email:newUser.email}, this.continue("verifyPasswords"))
            }
        },
        verifyPasswords: function (err, users) {
            if (err) {
                callback(err);
            }
            else if (users.length > 0) {
                callback(new Error("emailIsUnavailable"));
            }
            else {
                if (newUser.password != newUser.repeat_password) {
                    callback(new Error("passwordsNotMatch"));
                }
                else {
                    createUser({
                        password: newUser.password,
                        email: newUser.email,
                        organisationId: "Public"
                    }, function (err, user) {
                        delete user['password'];
                        delete user['salt'];
                        delete user['__meta'];
                        callback(err, user);
                    });
                }
            }
        }
    })();
};

exports.getUserInfo = function (userId, callback) {
    flow.create("retrieve user info", {
        begin: function () {
            persistence.findById("DefaultUser", userId, this.continue("info"));
        },
        info: function (err, user) {
            if (err) {
                callback(err, null);
            } else if (user) {
                delete user['__meta'];
                delete user['password'];
                delete user['salt'];
                callback(null, user);
            }
            else {
                callback(null, null);
            }
        }
    })();
};

exports.validateUser = function (email, pass, organisationPretender, callback) {
    flow.create("Validate Password", {
        begin: function () {
            persistence.filter("DefaultUser", {email: email}, this.continue("validatePassword"));
        },
        validatePassword: function (err, users) {
            if(err){
                callback(err);
            }else if(users.length === 0 || !pass){
                callback( new Error("invalidCredentials"));
            }
            else {
                var user = users[0];

                if (user.organisationId !== organisationPretender && organisationPretender!=="Public") {
                    callback(new Error("accessDenied"));
                }
                else {
                    hashThisPassword(pass, user.salt, function (err, hashedPassword) {
                        if (err)
                            callback(err);
                        else if (hashedPassword !== user.password)
                            callback(new Error("invalidCredentials"));
                        else if (user.activationCode !== "0")
                            callback(new Error("accountNotActivated"));
                        else
                            callback(null, user.userId);
                    });
                }

            }
        }
    })();
};

exports.getUserId = function(email, callback){
    persistence.filter("DefaultUser",{"email":email},function(err,result){
        if(err){
            callback(err);
        }else if(result.length>1){
            callback(new Error("Multiple users with email "+email));
        }else if(result.length===0){
            callback(new Error("No user with the specified email"))
        }
        else{
            callback(undefined,result[0].userId);
        }
    });
};

exports.genereateResetPasswordToken = function(userId,callback){
    flow.create("Create reset link", {
        begin: function () {
            persistence.lookup("PasswordResetRequest", crypto.createHash('md5').update(uuid.v4()).digest('hex'), this.continue("createLink"));
        },
        createLink: function (err, obj) {
            if(err){
                throw err;
            }else if(obj.__meta.freshRawObject===false){
                this.begin();
            }else{
                obj.issueDate = new Date();
                obj.user = userId;
                persistence.save(obj,callback)
            }
        },
        error:function(err){
            console.error(err);
            callback(err);
        }
    })();
}

exports.validateResetPasswordToken = function(token,callback){
    flow.create("Validate reset token", {
        begin: function () {
            persistence.findById("PasswordResetRequest", token, this.continue("validate"));
        },
        validate: function (err, obj) {
            var oneDay = 24*60*60*1000 //in ms

            if (err) {
                throw err //this error has to do with the flow and so it could be treated internally by the 'error' function

            } else if (!obj || obj.alreadyUsed || ((new Date() - obj.issueDate) > oneDay)){
                callback(new Error("The reset token is invalid"))

            } else {
                this.request = obj;
                this.next("getUser");
            }
        },
        getUser:function(){
            persistence.findById("DefaultUser", this.request.user,this.continue("validateUser"));
        },
        validateUser:function(err, user){
            if(err){
                callback(err);
            }
            else{
                if(!user){
                    callback(new Error("No user found!"))
                }
                else{
                    callback(null, user);
                }
            }
        },
        error: function (err) {
            console.error(err);
            callback(err);
        }
    })();
}

exports.invalidateResetPasswordToken = function(token,callback){
    flow.create("Validate reset token", {
        begin: function () {
            persistence.findById("PasswordResetRequest", token, this.continue("validate"));
        },
        validate: function (err, obj) {
            if (err) {
                throw err //this error has to do with the flow and so it could be treated internally by the 'error' function
            } else if (!obj) {
                callback(new Error("The reset token does not exist"))
            } else {
                obj.alreadyUsed = true;
                persistence.save(obj,callback);
            }
        },
        error: function (err) {
            console.error(err);
            callback(err);
        }
    })();
}

exports.changeUserPassword = function(userId, currentPassword, newPassword, callback){
    flow.create("Validate Password", {
        begin: function () {

            if (newPassword === currentPassword) {
                callback(new Error("You should enter different passwords"), false);
            }
            else if (newPassword.length < passwordMinLength) {
                callback(new Error("Your new password it too short! It should have at least " + passwordMinLength + " characters "), false);
            }
            else{
                persistence.findById("DefaultUser", userId, this.continue("validatePassword"));
            }
        },
        validatePassword: function (err, user) {
            var self = this;
            if (err || ! user) {
                callback(err, null);
            }
            else{
                hashThisPassword(currentPassword,user.salt,function(err,hashedPassowrd){
                    if(hashedPassowrd===user.password){
                        user.activationCode = "0";
                        setNewPassword(user,newPassword,callback);
                    }else{
                        callback(new Error("The password you provided does not match our records"));
                    }
                })
            }
        }
    })();
};

exports.setNewPassword = function(user,newPassword,callback){
    user.salt = crypto.randomBytes(48).toString('base64');
    hashThisPassword(newPassword,user.salt,function(err,hashedPassword){
        user.password = hashedPassword;
        persistence.saveObject(user,callback);
    });
};

function hashThisPassword(plainPassword,salt,callback){
    crypto.pbkdf2(plainPassword, salt, 20000, 512, 'sha512',function(err,res){
        if(err){
            callback(err)
        }
        else{
            callback(undefined,res.toString('base64'));
        }
    });
}

exports.createOrganisation = function (organisationDump, callback) {
    flow.create("create organisation", {
        begin: function () {
            persistence.lookup("Organisation", organisationDump.organisationId, this.continue("createOrganisation"));
        },
        createOrganisation: function (err, organisation) {
            if (err) {
                callback(err, null);
            }
            else {
                if (!persistence.isFresh(organisation)) {
                    callback(new Error("Organisation with id " + organisationDump.organisationId + " already exists"), null);
                }
                else {
                    persistence.externalUpdate(organisation, organisationDump);
                    persistence.saveObject(organisation, this.continue("createReport"));
                }
            }
        },
        createReport: function (err, organisation) {
            callback(err, organisation);
        }
    })();
};

exports.deleteOrganisation = function (organisationId,callback) {
    flow.create("delete organisation", {
        begin: function () {
            persistence.deleteById("Organisation", organisationId, this.continue("deleteReport"));
        },
        deleteReport: function (err, obj) {
            callback(err, obj);
        }
    })();
};

exports.getOrganisations = function (callback) {
    flow.create("get all organizations", {
        begin: function () {
            persistence.filter("Organisation",{}, this.continue("info"));
        },
        info: function (err, result) {
            callback(err, result);
        }
    })();
};

exports.updateOrganisation = function (organisationDump, callback) {
    flow.create("update organization", {
        begin: function () {
            persistence.lookup("Organisation", organisationDump.organisationId, this.continue("updateOrganisation"));
        },

        updateOrganisation: function (err, organisation) {
            if (err) {
                callback(err, null);
            }
            else if (persistence.isFresh(organisation)) {
                callback(new Error("Organisation with id " + organisationDump.organisationId + " was not found"), null);
            }
            else {
                persistence.externalUpdate(organisation, organisationDump);
                persistence.saveObject(organisation, this.continue("updateReport"));
            }
        },
        updateReport: function (err, organisation) {
            callback(err, organisation);
        }
    })();
};


exports.addUserToZone = function(userId,zoneName,callback){
    flow.create("addUserToZone",{
        begin:function(){
            persistence.filter("UserZoneMapping",{"userId":userId},this.continue("verifyDuplicates"))
        },
        verifyDuplicates:function(err,zoneMappings){
            if(err){
                callback(err)
            }else {
                var userAlreadyBelongs = zoneMappings.some(function (zoneMapping) {
                    return zoneMapping.zoneName === zoneName;
                });
                if (userAlreadyBelongs) {
                    callback();
                } else {
                    this.next("addToZone");
                }
            }
        },
        addToZone:function(){
            var newAssociation = apersistence.modelUtilities.createRaw("UserZoneMapping",uuid.v1().split("-").join(""));
            newAssociation.zoneName = zoneName;
            newAssociation.userId = userId;
            persistence.save(newAssociation,callback);
        }
    })()
};

exports.removeUserFromZone = function(userId,zoneName,callback){
    flow.create("removeUserFromZone",{
        begin:function(){
            var self = this;
            persistence.filter("UserZoneMapping",{"userId":userId,"zoneName":zoneName},this.continue("remove"))
        },
        remove:function(err,userZoneAssociation){
            if(err || userZoneAssociation.length===0){
                callback(err);
            }else{
                persistence.delete(userZoneAssociation[0],callback)
            }
        }
    })()
};

exports.zonesOfUser = function(user,callback){
    filteredMappings({"userId":user},function(err,result){
        if(err){
            callback(err);
        }else{
            callback(undefined,result.map(function(mapping){
                return mapping.zone
            }))
        }
    })
}
exports.usersInZone = function(zoneName,callback){
    filteredMappings({zoneName:zoneName},function(err,result){
        if(err){
            callback(err);
        }else{
            callback(undefined,result.map(function(mapping){
                return mapping.user
            }).filter(function(user){
                return user!==undefined;
            }));
        }
    })
};
function filteredMappings(filter,callback){
    flow.create("filterMappings",{
        begin:function(){
            persistence.filter("UserZoneMapping",filter,this.continue("loadMappings"))
        },
        loadMappings:function(err,zoneMappings){
            var self = this;
            if(err){
                callback(err)
            }else if(zoneMappings.length === 0) {
                callback(undefined,[])
            }
            else{
                this.errors = [];
                this.mappings = [];
                zoneMappings.forEach(function (zoneMapping) {
                    zoneMapping.__meta.loadLazyFields(self.continue('fieldLoaded'));
                })
            }
        },
        fieldLoaded:function(err,filledMapping){
            if(err){
                this.errors.push(err);
            }else{
                this.mappings.push(filledMapping)
            }
        },
        fieldsLoaded:{
            join:"fieldLoaded",
            code:function(){
                if(this.errors.length>0){
                    callback(this.errors,this.mappings);
                }else{
                    callback(undefined,this.mappings);
                }
            }
        }
    })()
}


exports.getAllZones = function(callback){
    persistence.filter('Zone',{},callback)
}

exports.createZone = function(zoneName,callback){
    flow.create("createZone",{
        begin:function(){
            persistence.lookup("Zone",zoneName,this.continue("gotZoneObject"));
        },
        gotZoneObject:function(err, zoneObj){
            if(err){
                callback(err);
            }else{
                if(zoneObj.__meta.freshRawObject===true){
                    persistence.save(zoneObj,callback)
                }else{
                    callback(undefined,zoneObj);
                }
            }
        },
        error:callback
    })();
};

exports.removeZone = function(zoneName,callback){
    persistence.deleteById("Zone",zoneName,callback);
};

exports.subscribeUserToNewsletter = function(email){

    var host = thisAdapter.config.Core.operandoHost;
    var protocol = thisAdapter.config.Core.operandoProtocol;
    var website_url = protocol+"://" + host;
    var url = protocol+"://" + host + "/?es=subscribe";

    var request = require('request');
    var data = "es_email="+email+"&es_group=PlusPrivacyUsers";

    request({
        url: url,
        method: "POST",
        headers: {
            "content-type": "application/x-www-form-urlencoded",
            "access-control-allow-origin":"*",
            "referer":website_url,
            "origin":website_url,
            "host":host,
            "cache-control":"no-cache"

        },
        body: data
    }, function (error, response, body){
       //don't care about the response...
    });
}

