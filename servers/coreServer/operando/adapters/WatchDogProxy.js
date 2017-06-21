var core = require("swarmcore");
thisAdapter = core.createAdapter("WatchDog");


function saveOSPPreferences(preferences){
  var userId = getCurrentUser();// in swarm     phase.getUserId

}


function checkPreferences(newPreferences, callback){

}

function onNewUser(userId){
    startSwarm("notification.js", "create", userId, "CHECK_OSP_SETTINGS", "Watchdog: Please allow OPERANDO to read your social network settings");
}

function modifyPreferences(userId){
    startSwarm("notification.js", "create", userId, "CHECK_OSP_SETTINGS", "Watchdog: Please allow OPERANDO to adjust social network settings");
}



apersistence.registerModel("OSPSettingsForUser","Redis",{
    userId:{
        type:"string",
        pk:true,
        index:true
    },
    currentValue:{
        type: "string",
        index: true
    },
    oldValues:{
        type: "string"
    }
});



function securityNotification(userId){
    startSwarm("notification.js", "create", userId, "CHECK_OSP_SETTINGS", "Watchdog: Please allow OPERANDO to adjust social network settings");
}