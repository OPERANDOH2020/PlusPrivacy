operandoCore.factory("i18nService", ["$http", "$q", function ($http, $q) {
    var onLoadedCallbacks = [];
    var userLocale = chrome.i18n.getUILanguage();
    console.log(userLocale);
    //if(userLocale.length == 2){
      //  userLocale +="-"+userLocale.toUpperCase();
    //}
    var polyglot = null;

    var notifyObservers = function(){
        onLoadedCallbacks.forEach(function(c){
            c();
        })
    }

    var load = function () {
        //var deferred = $q.defer();
        var sequence = Promise.resolve();

        sequence = sequence.then(function () {
            return new Promise(function (resolve, reject) {
                $http.get("/locales/" + userLocale + ".json").then(function (res) {
                    polyglot = new Polyglot({locale: userLocale.substr(0, 2)});
                    polyglot.extend(res.data);
                    resolve("success");
                }, function () {
                    $http.get("/locales/en-US.json").then(function (res) {
                        polyglot = new Polyglot({locale: "en"});
                        polyglot.extend(res.data);
                        resolve("success");
                    }, function (response) {
                        reject(response);
                    });
                });
            });
        });

        sequence = sequence.then(function(status){
           if(status === "success"){
               notifyObservers();
           }
        });
        return sequence;
    }

    var onLoaded = function(callback){
        if(polyglot!==null){
            callback();
        }
        else{
            onLoadedCallbacks.push(callback);
        }
    }

    var isInitialized = function () {
        return polyglot !== null;
    }

    var translate = function (key, params) {

        var translationArgs = [];
        translationArgs.push(key);
        if (polyglot !== null) {

            if(Array.isArray(params)){
                if(params.length == 2 ){
                    var obj = {};
                    obj[params[0]] = params[1];
                    translationArgs.push(obj);
                }
            }
            else{
                translationArgs.push(params);
            }
            return polyglot.t.apply(polyglot,translationArgs);

        }
        else{
            //console.error("i18nService not initialized");

            var toBeCalledLater = function(){
                var seq = Promise.resolve();
                seq = seq.then(function(){

                    return new Promise(function(resolve, reject){
                        onLoadedCallbacks.push(function(){
                            resolve();
                        });

                    });

                });

                return seq;
            }

            return toBeCalledLater();
        }
        return key;
    };

    return {
        load: load,
        onLoaded:onLoaded,
        _: translate,
        isInitialized:isInitialized

    }

}]).filter("i18n", function (i18nService) {

    var data = {}; // DATA RECEIVED ASYNCHRONOUSLY AND CACHED HERE
    var invoked = false;


    function realFilter(value) {
        if(data[value]){
            return data[value];

        }
    }


   filterStub.$stateful = true;

  function filterStub (object) {
      var params = Array.prototype.slice.call(arguments);
      params = params.splice(1);

        if(data[object] === undefined){
            if (!invoked){
                var translation = i18nService._(object, params);

                if(typeof translation === "object"){
                    translation.then(function(){
                        invoked = true;
                        var tr = i18nService._(object, params);
                        data[object] = tr;
                    })
                }
                else{
                    return translation;
                }

            }else{ var result = i18nService._(object, params);
                data[object] = result;

            }

            return " ";
        }else{
            return realFilter(object);
        }

    }

    return filterStub;

});