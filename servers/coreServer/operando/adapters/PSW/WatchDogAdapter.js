/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    CIPRIAN TALMACEL (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var core = require("swarmcore");

thisAdapter = core.createAdapter("WatchDogAdapter");

var fs = require('fs');
var storageFile = process.env.SWARM_PATH+"/operando/adapters/PSW/resources/userAnswers";
var utils = require('./utils');


getOspSettings = function(){
    return utils.ospSettings;
};

updateOspSettings = function(newOspSettingsObject){
    try {
        fs.writeFileSync(process.env.SWARM_PATH+"/operando/adapters/PSW/resources/resources/OSP.settings.json", JSON.stringify(newOspSettingsObject, null, 4));
        ospSettings = newOspSettingsObject;
    }catch(error){
        console.log("Update unsuccessful");
        return error;
    }
    return "success";
};

getRecommenderParams = function(){
    return {
        "optionsToSettings":utils.optionToSetting,
        "settingsToOptions":utils.settingToOptions,
        "conditionalProbabilitiesMatrix":utils.conditionalProbabilities,
        "initialProbabilities":utils.optionProbabilties,
        "settingToNetwork":utils.settingToNetwork
    }
}

storeUserPreferences = function(current_settings){
    fs.appendFile(storageFile,current_settings,function(err){
        if(err){
            console.log("Error: "+err+" occured for user choices: "+current_settings);
        }
    });
};

savePrivacySettings = function(settings, callback){
    var timestamp = Date.now();

    var filePath = process.env.SWARM_PATH+"/operando/adapters/PSW/resources/privacy_settings_versions/OSP.settings_"+timestamp+".json";
    fs.open(filePath, "wx", function (err, fd) {
        if (err) {
            console.error(err);
            callback(err);
        }
        else {
            fs.close(fd, function (err) {
                if (err) {
                    console.error(err);
                    callback(err);
                }
                else {
                    fs.writeFile(filePath, JSON.stringify(settings, null, 4), function (err) {
                        if (err) {
                            console.error(err);
                            callback(err);
                        }
                        else {
                            callback(null, true);
                        }
                    });
                }
            });

        }

    });

};

retrieveSocialNetworksHistory = function(callback){
    var history = [];
    var folderPath = process.env.SWARM_PATH+"/operando/adapters/PSW/resources/privacy_settings_versions";

    if(fs.existsSync(folderPath)){
        fs.readdir(folderPath, function(err, files){
            files.forEach(function(file){
                try{
                var timestamp = file.split("OSP.settings_")[1].split(".json")[0];
                    history.push({filename:file,
                    date:new Date(parseInt(timestamp)).toGMTString()})
                }
                catch(e){
                    console.log(e);
                }
            });
            callback(null,history);
        })
    }
    else{
        callback(null,history);
    }

};

recalculateTheRecomenderParameters = utils.recomputeConditionalProbabilitites;
