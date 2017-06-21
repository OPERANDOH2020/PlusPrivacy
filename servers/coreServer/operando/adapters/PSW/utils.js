/**
 * Created by ciprian on 16.08.2016.
 */


var fs = require('fs')

var ospSettingsFile = process.env.SWARM_PATH+"/operando/adapters/PSW/resources/OSP.settings.json";

var ospSettings = JSON.parse(fs.readFileSync(ospSettingsFile));

exports.conditionalProbabilities = undefined;
exports.optionProbabilties = undefined;
exports.optionToSetting = undefined;
exports.settingToOptions = undefined;
exports.ospSettings = ospSettings;
var numOptions ;
var numSettings ;

exports.indexOSPSettings = function(){
    try{
        ospSettings = JSON.parse(fs.readFileSync(ospSettingsFile));
    }catch(e){
        throw new Error("You must put the settings file in resources using the JSON format. ");
    }

    var max_index = -1;

    forEachOption(function(optionObject){
        optionObject.index = ++max_index
    });

    var current_setting_id = 0;
    forEachSetting(function(settingObject,settingName){
        if(settingObject['read']['availableSettings']){
            if(Array.isArray(settingObject['read']['availableSettings'])!==true){
                settingObject.id = current_setting_id++;
            }
        }
    });

    fs.writeFileSync(process.env.SWARM_PATH+"/operando/adapters/PSW/resources/OSP.settings.json",JSON.stringify(ospSettings,null,4));
    init();
};

init();

function init(){
    exports.settingToOptions = extractOptionsForSettings();

    exports.settingToNetwork = [];
    forEachSetting(function(settingObj,settingName,networkName){
        if (settingObj['read']['availableSettings']&& Array.isArray(settingObj['read']['availableSettings'])!==true) {
            exports.settingToNetwork.push(networkName);
        }
    });

    numOptions = exports.settingToOptions.reduce(function(prev,options){return prev+options.length;},0);

    numSettings = exports.settingToOptions.length;

    exports.optionToSetting = new Array(numOptions);

    exports.settingToOptions.forEach(function(options,setting) {
        options.forEach(function(option){
            exports.optionToSetting[option] = setting;
        })
    });

    exports.optionProbabilties = exports.settingToOptions.reduce(function(prev,optionsArray){return prev.concat(new Array(optionsArray.length).fill(1/optionsArray.length));},[]);

    exports.conditionalProbabilities = JSON.parse(fs.readFileSync(process.env.SWARM_PATH+"/operando/adapters/PSW/resources/conditionalProbabilities.json")).map(function(arr){
        return arr.map(function(nr){
            return parseFloat(nr);
        })
    });

    function extractOptionsForSettings(){
        var settingToOptions = [];
        for(var network in ospSettings){
            var settings = ospSettings[network];
            for (var setting in settings) {
                var settingObj = settings[setting];
                if (settingObj['read']['availableSettings']&& Array.isArray(settingObj['read']['availableSettings'])!==true) {
                    var arrayOfOptionIndexes = [];
                    for (var option in settingObj['read']['availableSettings']) {
                        arrayOfOptionIndexes.push(settingObj['read']['availableSettings'][option].index);
                    }
                    settingToOptions.push(arrayOfOptionIndexes)
                }
            }
        }
        return settingToOptions
    }
}



exports.recomputeConditionalProbabilitites = function(){
    var correlation_matrix = computeCorrelationMatrix();
    var conditionalProbabilities = computeConditionalProbabilities().map(function(arr){
        return arr.map(function(nr){
            return nr.toFixed(3);
        })
    });

    fs.writeFileSync(process.env.SWARM_PATH+"/operando/adapters/PSW/resources/conditionalProbabilities.json",JSON.stringify(conditionalProbabilities));

    function computeCorrelationMatrix() {
        var jaccardDistances = computeJaccardTagDistances();
        var privacyIndexes = computePrivacyIndexes();//.map(function(x){return x-0.5});
        return combineJaccardAndPrivacyIndex(jaccardDistances,privacyIndexes);

        function computeJaccardTagDistances() {
            var tags = {};
            var nr_of_tags = 0;

            forEachSetting(function (settingObj) {
                if (settingObj.tags) {
                    settingObj.tags.forEach(function (tag) {
                        if (!tags[tag]) {
                            tags[tag] = []
                        }
                        tags[tag].push(settingObj.id)
                    })
                }
            });

            for (tag in tags) {
                nr_of_tags++;
            }

            var intersectionCardinals = [], psedoReunionCardinals = [], jaccardDistances = []; //jaccard index between sets of tags
            for (var row = 0; row < numSettings; row++) {
                intersectionCardinals.push([]);
                psedoReunionCardinals.push([]);
                jaccardDistances.push([]);
                for (var column = 0; column < numSettings; column++) {
                    intersectionCardinals[row].push(0);
                    psedoReunionCardinals[row].push(0);
                    jaccardDistances[row].push(0);
                }
            }

            for (tag in tags) {
                tags[tag].forEach(function (setting) {
                    tags[tag].forEach(function (otherSetting) {
                        intersectionCardinals[setting][otherSetting]++
                    });
                })
            }
            for (tag in tags) {
                tags[tag].forEach(function (setting) {
                    for (var otherSetting = 0; otherSetting < numSettings; otherSetting++) {
                        psedoReunionCardinals[setting][otherSetting]++;
                        psedoReunionCardinals[otherSetting][setting]++;
                    }
                })
            }
            for (var setting = 0; setting < exports.settingToOptions.length; setting++) {
                for (var otherSetting = 0; otherSetting < exports.settingToOptions.length; otherSetting++) {
                    var intCard = intersectionCardinals[setting][otherSetting];
                    var reuCard = psedoReunionCardinals[setting][otherSetting] - intCard;
                    jaccardDistances[setting][otherSetting] = (intCard / reuCard)
                }
            }
            return jaccardDistances
        }

        function computePrivacyIndexes(){
            var privacyIndexes = new Array(numOptions);
            exports.settingToOptions.forEach(function(optionArray){
                var privacyStep = 1/(optionArray.length-1);
                optionArray.forEach(function(option,optionIndex){
                    privacyIndexes[option] = privacyStep*optionIndex;
                })
            })
            return privacyIndexes
        }

        function combineJaccardAndPrivacyIndex(jaccardDistances,privacyIndexes){
            var correlationMatrix = [];
            for(var option=0;option<numOptions;option++){
                correlationMatrix.push([]);
                for(var other_option=0;other_option<numOptions;other_option++){
                    var correlation = jaccardDistances[exports.optionToSetting[option]][exports.optionToSetting[other_option]];
                    correlation *= 1-Math.abs(privacyIndexes[option]-privacyIndexes[other_option])
                    correlationMatrix[option].push(correlation);
                }
            }

            return correlationMatrix;
        }
    }


    function computeConditionalProbabilities(){
        var conditionalProbabilities = [];
        var allNormalizers = [];

        for(var option=0;option<numOptions;option++) {
            conditionalProbabilities.push(correlation_matrix[option]);
            var normalizers = new Array(numSettings).fill(0);
            for (var otherOption = 0; otherOption < numOptions; otherOption++) {
                normalizers[exports.optionToSetting[otherOption]]+=correlation_matrix[option][otherOption]
            }
            allNormalizers.push(normalizers);
        }

        for(var option=0;option<numOptions;option++) {
            for (var otherOption = 0; otherOption < numOptions; otherOption++) {
                if(option===otherOption){
                    conditionalProbabilities[option][otherOption]=1;
                    continue;
                }
                if(exports.optionToSetting[option]===exports.optionToSetting[otherOption]){
                    conditionalProbabilities[option][otherOption]=0;
                    continue;
                }

                var normalizer = allNormalizers[option][exports.optionToSetting[otherOption]];
                if(normalizer===0){
                    conditionalProbabilities[option][otherOption] = exports.optionProbabilties[option];
                }else {
                    conditionalProbabilities[option][otherOption] /= normalizer
                }
            }
        }

        return conditionalProbabilities;
    }

    return conditionalProbabilities;
}

function forEachSetting(applyOnSetting){
    for(var network in ospSettings){
        var settings = ospSettings[network];
        for(var setting in settings){
            applyOnSetting(settings[setting],setting,network);
        }
    }
}

function forEachOption(applyOnOption){
    forEachSetting(function(settingObj){
        var options = settingObj['read']['availableSettings'];
        if(Array.isArray(options)!==true){
            for(var option in options){
                applyOnOption(options[option],option)
            }
        }
    })
}
