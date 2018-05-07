operandoCore.factory("i18nService", ["$http", "$q", function ($http, $q) {
    var userLocale = chrome.i18n.getUILanguage();
    console.log(userLocale);
    /*if(userLocale.length == 2){
        userLocale +="-"+userLocale.toUpperCase();
    }*/
    var polyglot = null;

    var load = function () {
        var deferred = $q.defer();


        $http.get("/locales/" + userLocale + ".json").then(function (res) {
            polyglot = new Polyglot({locale: userLocale.substr(0, 2)});
            polyglot.extend(res.data);
            deferred.resolve("success");
        }, function () {
            $http.get("/locales/en-US.json").then(function (res) {
                polyglot = new Polyglot({locale: "en"});
                polyglot.extend(res.data);
                deferred.resolve("success");
            }, function (response) {
                deferred.reject(response);
            });
        });

    }

    var translate = function (key, params) {

        var translationArgs = [];
        translationArgs.push(key);
        if (polyglot !== null) {
            if(params){
                if(params.length == 2 ){
                    var obj = {};
                    obj[params[0]] = params[1];
                    translationArgs.push(obj);
                }
            }
            return polyglot.t.apply(polyglot,translationArgs);

        }
        else{
            console.error("i18nService not initialized");
        }
        return key;
    }

    return {
        load: load,
        _: translate
    }

}]).filter("i18n", function (i18nService) {
    return function (object) {
        var params = Array.prototype.slice.call(arguments);
        params = params.splice(1);
        return i18nService._(object, params);
    }
});