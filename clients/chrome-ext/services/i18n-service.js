operandoCore.factory("i18nService", ["$http", "$q", function ($http, $q) {
    var userLocale = chrome.i18n.getUILanguage();
    console.log(userLocale);
    var polyglot = null;

    var load = function () {
        var deferred = $q.defer();


        $http.get("/operando/locales/" + userLocale + ".json").then(function (res) {
            polyglot = new Polyglot({locale: userLocale.substr(0, 2)});
            polyglot.extend(res.data);
            deferred.resolve("success");
        }, function () {
            $http.get("/operando/locales/en-US.json").then(function (res) {
                polyglot = new Polyglot({locale: "en"});
                polyglot.extend(res.data);
                deferred.resolve("success");
            }, function (response) {
                deferred.reject(response);
            });
        });

    }

    var translate = function (key) {

        if (polyglot !== null) {
            return polyglot.t(key);
        }
        else{
            console.error("i18nService not initialized");
        }
    }

    return {
        load: load,
        _: translate
    }

}]).filter("i18n", function (i18nService) {
    return function (object) {
        return i18nService._(object);
    }
});