operandoCore.service("firstRunService", function () {

    var onFirstRun = function(callback){
        chrome.storage.local.get('firstRunPassed', function (settings) {
            if (!(settings instanceof Object) || Object.keys(settings).length === 0) {
                callback();
            }
        });
    }

    var setupComplete = function (callback) {
        chrome.storage.local.set({firstRunPassed : true}, function () {
            if(callback){
                callback();
            }
        });
    }

    return {
        onFirstRun:onFirstRun,
        setupComplete:setupComplete
    }

});