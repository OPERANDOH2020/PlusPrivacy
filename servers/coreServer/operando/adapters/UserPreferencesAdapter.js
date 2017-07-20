var core = require("swarmcore");
thisAdapter = core.createAdapter("UserPreferencesAdapter");
var container = require('safebox').container;
var uuid = require('node-uuid');
var persistence = undefined;
var flow = require('callflow');

function registerModels(callback){
    var models = [{
        modelName:"UserPreferences",
        dataModel:{
            id:{
                type:"string",
                pk:true,
                length:255
            },
            userId: {
                type: "string",
                index: true,
                length:254
            },
            preference_key:{
                type:"string",
                index:true,
                length:64
            },
            preferences:{
                type:"string",
                length:8096
            }
        }
    }];

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
    })();

}

container.declareDependency("UserPreferences", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
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


addOrUpdateUserPreferences = function(userId, preference_key, preferences, callback){

    flow.create("addOrUpdateUserPreferences",{
        begin:function(){
            persistence.filter("UserPreferences",{userId:userId, preference_key:preference_key}, this.continue("checkPreferences"));
        },
        checkPreferences:function(err, sn_preferences){
            if(err){
                callback(err);
            }else{
                if(sn_preferences.length>0){
                    var prefs = sn_preferences[0];
                    prefs['preferences'] = preferences;
                    persistence.saveObject(prefs, callback);
                }else{
                    persistence.lookup("UserPreferences",uuid.v1(), this.continue("savePreferences"));
                }
            }
        },
        savePreferences:function(err, prefs){
            prefs['userId'] = userId;
            prefs['preference_key'] = preference_key;
            prefs['preferences'] = preferences;
            persistence.saveObject(prefs, callback);
        }
    })();

};

getPreferences = function(userId,preference_key,callback){
    flow.create("addOrUpdateUserPreferences",{
        begin:function(){
            persistence.filter("UserPreferences",{userId:userId, preference_key:preference_key}, callback);
        }

    })();
};

deletePreferences = function(userId, preferenceKey, callback){

    flow.create("deletePreferences",{
        begin:function(){
            this.results = [];
            persistence.filter("UserPreferences",{userId:userId, preference_key:preferenceKey}, this.continue("removePreferences"));
        },
        removePreferences:function(err, preferences){
            var self = this;
            if(err){
                callback(err);
            }
            else{
                preferences.forEach(function(preference){
                    persistence.delete(preference, self.continue("finish"));
                })
            }
        },
        finish:function(err, result){
            this.results.push(result);
        },
        end:{
            join:"finish",
            code:function(){
                callback(undefined,this.results);
            }
        }

    })();
}


deleteAllPreferences = function(userId, callback){

    flow.create("deletePreferences",{
        begin:function(){
            this.results = [];
            persistence.filter("UserPreferences",{userId:userId}, this.continue("removePreferences"));
        },
        removePreferences:function(err, preferences){
            var self = this;
            if(err){
                callback(err);
            }
            else{
                if(preferences.length>0){
                    preferences.forEach(function(preference){
                        persistence.delete(preference, self.continue("finish"));
                    })
                }
                else{
                    callback(undefined);
                }

            }
        },
        finish:function(err, result){
            this.results.push(result);
        },
        end:{
            join:"finish",
            code:function(){
                callback(undefined,this.results);
            }
        }

    })();
}


