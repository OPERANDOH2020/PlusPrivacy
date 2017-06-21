/**
 * Created by Rafa on 6/15/2017.
 */

var userPreferences = {
    meta:{
        name:"UserPreferences.js"
    },
    getPreferences:function(preferenceKey){
        this.preferenceKey = preferenceKey;
        this.swarm("getUserPreferences");
    },
    saveOrUpdatePreferences:function(preferenceKey, preferences){
        this.preferenceKey = preferenceKey;
        this.preferences = JSON.stringify(preferences);
        this.swarm("saveUserPreferences");
    },

    removePreferences:function(preferenceKey){
        this.preferenceKey = preferenceKey;
        this.swarm("removeUserPreferences");
    },

    getUserPreferences:{
        node:"UserPreferencesAdapter",
        code:function(){
            var self = this;
            getPreferences(this.meta.userId,this.preferenceKey,S(function(err, preferences){
                if(err){
                    self.error = err.message;
                    self.home("failed");
                }else{
                    if(preferences.length>0){
                        self.preferences = JSON.parse(preferences[0].preferences);
                    }
                    else{
                        self.preferences = [];
                    }
                    self.home("success");
                }
            }));
        }
    },
    saveUserPreferences:{
        node:"UserPreferencesAdapter",
        code:function(){
            var self = this;
            addOrUpdateUserPreferences(this.meta.userId, this.preferenceKey, this.preferences,S(function(err, preferences){
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                } else {
                    self.preferences = preferences;
                    self.home("success");
                }
                }));
            }
        },
    removeUserPreferences:{
        node:"UserPreferencesAdapter",
        code:function(){
            var self = this;
            deletePreferences(this.meta.userId, this.preferenceKey, S(function(err, result){
                if (err) {
                    self.error = err.message;
                    self.home("failed");
                } else {
                    self.home("success");
                }
            }));
        }
    }

}
userPreferences;