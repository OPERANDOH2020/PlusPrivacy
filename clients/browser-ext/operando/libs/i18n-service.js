var bus = require("bus-service").bus;
var polyglot = null;
var i18nService = exports.i18nService = {

    loadTranslations: function () {

        var userLocale = chrome.i18n.getUILanguage();
        console.log(userLocale);

        var sequence = Promise.resolve();
        var performXhrRequest = function(url,callback){

            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == XMLHttpRequest.DONE) {
                    callback(null, xhr.responseText);
                }
            };

            xhr.open("GET",url);
            xhr.send();


        };


        sequence = sequence.then(function () {
            return new Promise(function (resolve, reject) {

                performXhrRequest("/locales/" + userLocale + ".json",function(err, res){
                    if(err){
                        performXhrRequest("/locales/en-US.json", function(err, res){
                            polyglot = new Polyglot({locale: "en"});
                            polyglot.extend(JSON.parse(res));
                            resolve("success");

                        })
                    }
                    else{
                        polyglot = new Polyglot({locale: userLocale.substr(0, 2)});
                        polyglot.extend(JSON.parse(res));
                        resolve("success");
                    }
                });



               /* $http.get("/locales/" + userLocale + ".json").then(function (res) {
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
                });*/
            });
        });

        return sequence;
    },


    translate: function (key, params, callback) {

        var translationArgs = [];
        translationArgs.push(data.key);
        if (polyglot !== null) {
            if (data.params) {
                if (data.params.length == 2) {
                    var obj = {};
                    obj[data.params[0]] = data.params[1];
                    translationArgs.push(obj);
                }
            }
            callback(polyglot.t.apply(polyglot, translationArgs));

        }
        else {
            console.error("i18nService not initialized");
        }
        callback(key);
    }


};
bus.registerService(i18nService);