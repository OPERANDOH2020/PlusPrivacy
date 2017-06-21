var UserPrefs = function () {
    var self = this;

    this.getPrefs = function (callback) {
        if (self.pref) {
            callback(this.prefs);
        }
        else {
            chrome.storage.local.get("UserPrefs", function (items) {

                if (typeof items === "object" && Object.keys(items).length === 0) {
                    self.prefs = {};
                }
                else{
                    self.prefs = JSON.parse(items['UserPrefs']);
                }
                callback(self.prefs);
            });
        }
    }
}

UserPrefs.prototype = {
    getPreferences:function(key, filterObj, callback){
        var filteredPreferences = {};
        this.getPrefs(function(prefs){
            if(key){
                if(prefs[key]){
                    if(filterObj){
                        if(prefs[key] instanceof Array){
                            filteredPreferences =  prefs[key].filter(function(preference){
                                for(i in filterObj){
                                    if(filterObj[i] !== preference[i]){
                                        return false;
                                    }
                                }
                                return true;
                            });
                        }
                    }
                    else{
                        filteredPreferences = prefs[key];
                    }
                }
            }
            callback(filteredPreferences);
        });
    },
    setPreferences:function(key, object){
        this.prefs[key] = object;
        chrome.storage.local.get("UserPrefs", function(prefs){
                prefs[key] = object;
                chrome.storage.local.set({UserPrefs: JSON.stringify(prefs)});
        });
    },
    addPreference:function(key, object){
        chrome.storage.local.get("UserPrefs", function(o){
            var prefs = null;
            if(typeof o === "object" && Object.keys(o).length === 0){
                prefs = {};
            }
            else{
                prefs = JSON.parse(o['UserPrefs']);
            }

            if(!prefs[key]){
                prefs[key] = [];
            }
            prefs[key].push(object);
            chrome.storage.local.set({UserPrefs: JSON.stringify(prefs)});
        });
    }
}

var UserPreferences = (function(){
    var instance;
    return {
        getInstance:function(){
            if(!instance){
                instance = new UserPrefs();
            }
            return instance;
        }
    }
})();
