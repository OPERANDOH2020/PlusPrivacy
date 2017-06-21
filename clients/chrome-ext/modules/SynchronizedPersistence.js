
var SynchronizedPersistence = function(){};

SynchronizedPersistence.prototype.get = function(model, key, callback){
    chrome.storage.sync.get(model, function(obj){
        console.log(obj);
        if(obj[model]){
            if(obj[model][key]){
                callback(obj[model][key]);
            }
            else{
                callback(null);
            }
        }else{
            callback(null);
        }
    });
}

SynchronizedPersistence.prototype.set = function(model, key, value){
    chrome.storage.sync.get(model, function(obj){
        if(obj[model] === undefined){
            obj[model] = {};
        }
        if(obj[model][key] === undefined){
            obj[model][key] = [];
        }

        obj[model][key].push(value);
        chrome.storage.sync.set(obj);
    });
}

SynchronizedPersistence.prototype.exists = function(model, key, value, callback){
    this.get(model, key, function(_arr){
        if(_arr && _arr.indexOf(value)>=0){
            callback(true);
        }
        else{
            callback(false);
        }
    })
}

exports.syncPersistence  = new SynchronizedPersistence();
