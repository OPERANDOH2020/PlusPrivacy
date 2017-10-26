/**
 * Created by ciprian on 4/20/17.
 */

var zonesSwarming = {
    getAllZones: function () {
        this.swarm("getZones");
    },
    getZones:{
        node:"UsersManager",
        code:function(){
            var self = this;
            getAllZones(S(function(err,zones){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.zones = zones.map(function(zone){
                        return zone.zoneName;
                    });
                    self.home("gotAllZones");
                }
            }))
        }
    },

    createZone:function(zoneName){
        this.zoneName = zoneName;
        this.swarm('create');
    },
    create:{
        node:"UsersManager",
        code:function(){
            var self = this;
            createZone(self.zoneName,S(function(err,result){console.log(arguments);
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home('zoneCreated');
                }
            }))
        }
    },

    getUsersInZone:function(zoneName,requiredFields){
        this.zone = zoneName;
        this.requiredFields = requiredFields;
        this.swarm("getUsers");
    },
    getUsers:{
        node:"UsersManager",
        code:function(){
            var self = this;
            usersInZone(self.zone,S(function(err,users){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    if(self.requiredFields){
                        users = users.map(function(user){
                            var reqFields = {};
                            self.requiredFields.forEach(function(field){
                                reqFields[field] = user[field];
                            })
                            return reqFields
                        })

                        self.users = users;
                        self.home('gotUsersInZone');
                    }
                }
            }))
        }
    },

    updateZone:function(updatedZone){
        this.updatedZone = updatedZone;

        this.swarm('update');
    },
    update:{
        node:"UsersManager",
        code:function(){
            var self = this;
            usersInZone(self.updatedZone.zoneName,S(function(err,users){

                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    var newUsersInZone = self.updatedZone.users.filter(function(userEmail){
                        return !users.some(function(user){
                            return userEmail===user.email;
                        })
                    });

                    var existingUsers = users.map(function(user){return user.email})


                    filterUsers({"email":newUsersInZone, "REQUIRED_FIELDS":["userId","email"]},S(function(err,users){

                        if(err){
                            self.err = err.message;
                            self.home('failed');
                        }else{
                            var remainingUsers = users.length;
                            var errs = [];
                            users.forEach(function(user){
                                addUserToZone(user.userId,self.updatedZone.zoneName,S(function(err,result){
                                    remainingUsers--;
                                    if(err){
                                        errs.push(err);
                                    }else{
                                        existingUsers.push(user.email)
                                    }
                                    
                                    if(remainingUsers===0){
                                        self.err = errs.length>0?errs:undefined;
                                        self.updatedZone.users = existingUsers;
                                        self.home('zoneUpdated');
                                    }
                                }))
                            })
                        }
                    }))
                }
            }))
        }
    }
};
zonesSwarming;
