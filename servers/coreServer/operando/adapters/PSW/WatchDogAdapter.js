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

recalculateTheRecomenderParameters = utils.recomputeConditionalProbabilitites
