/**
 * Created by ciprian on 18.08.2016.
 */

/*
    'question' and 'setting' are used interchangeably.
    'option' and 'answer' are also used interchangeably.
    In the current context, they pretty much mean the same thing.
 */

var utils = require('./utils');
var optionCooccurences = undefined;
var settingToOptions = undefined;
var optionToSetting = undefined;
var numOptions = undefined;
var optionProbabilities = undefined;
var conditionalProbabilities = undefined;
var cooccurenceProbabilitites = undefined;
var numSuggestions = 3;

exports.initReccomender = function(cooccurenceMatrixFile,ospSettingsFile){

    if(cooccurenceMatrixFile===undefined){
        cooccurenceMatrixFile = "./resources/cooccurence_matrix.json"
    }
    if(ospSettingsFile===undefined){
        ospSettingsFile = "./resources/osp.settings.indexes.json"
    }

    var fs = require('fs');

    optionCooccurences = JSON.parse(fs.readFileSync(cooccurenceMatrixFile));

    optionIndexes = JSON.parse(fs.readFileSync(ospSettingsFile));

    numOptions = optionCooccurences.length;
    settingToOptions = extractOptionsForSettings();
    optionToSetting = new Array(optionCooccurences.length);
    settingToOptions.forEach(function(options,setting){
        options.forEach(function(option){
            optionToSetting[option] = setting;
        })
    });
    optionProbabilities = computeOptionProbabilities();
    conditionalProbabilities = computeConditionalProbabilities();
    cooccurenceProbabilitites = computeCooccurenceProbabilities();

    function extractOptionsForSettings(){
        var settingToOptions = [];
        for(var network in optionIndexes){
            var settings = optionIndexes[network];
            for(var setting in settings){
                var options = settings[setting];
                var arrayOfOptionIndexes = [];

                for (var option in options){
                    var index = options[option];
                    arrayOfOptionIndexes.push(index);
                }
                settingToOptions.push(arrayOfOptionIndexes)
            }
        }
        return settingToOptions
    }

    function computeOptionProbabilities() {
        var optionProbabilities = new Array(numOptions).fill(0);
        for (var option = 0; option < numOptions; option++) {
            for (var otherOption = 0; otherOption < numOptions; otherOption++) {
                optionProbabilities[option] += optionCooccurences[option][otherOption]
            }
        }
        settingToOptions.forEach(function (options) {
            var normalizer = options.reduce(function (prev, currentOption) {
                return prev + optionProbabilities[currentOption]
            }, 0)
            options.forEach(function (option) {
                optionProbabilities[option] /= normalizer;
            })
        })
        return optionProbabilities;
    }

    function computeConditionalProbabilities(){
        var conditionalProbabilities = optionCooccurences.map(function(cooccurences){
            return new Array(numOptions)
        })

        settingToOptions.forEach(function(options,setting){
            options.forEach(function(option){
                settingToOptions.forEach(function(otherOptions,otherSetting){
                    var normalizer = 0;
                    otherOptions.forEach(function(otherOption){
                        normalizer+=optionCooccurences[option][otherOption]
                    })
                    otherOptions.forEach(function(otherOption){
                        conditionalProbabilities[option][otherOption] = optionCooccurences[option][otherOption]/normalizer
                    })
                })
            })
        });
        return conditionalProbabilities
    }

    function computeCooccurenceProbabilities(){
        var cooccurenceProbabilitites = optionCooccurences.map(function(coocurences){
            return coocurences.slice();
        })

        var numberOfInstances = 0;
        settingToOptions[0].forEach(function(option){
            settingToOptions[1].forEach(function(otherOption){
                numberOfInstances+=optionCooccurences[option][otherOption]
            })
        })

        for(var option=0;option<numOptions;option++){
            for(var otherOption=0;otherOption<numOptions;otherOption++){
                cooccurenceProbabilitites[option][otherOption]/=numberOfInstances;
            }
        }
        return cooccurenceProbabilitites
    }
};

function evaluateScoresNaively(currentProbabilities){
    return utils.vecMatrixMultiplication(currentProbabilities,conditionalProbabilities);
}

function modifyOption(currentProbabilities,optionToModify,activate){
    settingToOptions[optionToSetting[optionToModify]].forEach(function(option){
        if(option === optionToModify){
            currentProbabilities[option] = activate?1:optionProbabilities[option]
        }
        else{
            currentProbabilities[option] = activate?0:optionProbabilities[option]
        }
    })
}

function extractSuggestions(optionScores,activations,numSuggestions){
    var suggestions = utils.argSort(optionScores);
    var bestSuggestions = [];
    for(var i=numOptions-1;i>=0;i--){
        if(activations[suggestions[i]]===1 || activations[suggestions[i]]===0){
            continue;
        }
        if (bestSuggestions.some(function(otherSuggestion){
            if(optionToSetting[otherSuggestion]===optionToSetting[suggestions[i]]){
                return true;
            }
                return false;
        })==false) {
            bestSuggestions.push(suggestions[i]);
            if (bestSuggestions.length === numSuggestions) {
                break;
            }
        }
    }

    var confidence = bestSuggestions.reduce(function(prev,option){
        return prev+optionScores[option]
    },0);

    return {
        "suggestions":bestSuggestions,
        "confidence":confidence
    }
}

exports.getMostRelevantQuestionAndSuggestions = function(activeOptions){
    /*
        A question is considered more relevant if it's most likely answers indicate other already likely answers. In other words, if it would confirm the current estimation.
    */

    var activations = optionProbabilities.slice();

    activeOptions.forEach(function(activeOption){
        modifyOption(activations,activeOption,1);
    });

    var unknownSettings = settingToOptions.reduce(function(prev,options,setting){
        var is_known = false;
        options.forEach(function(option){activeOptions.forEach(function(activeOption){if(option===activeOption){is_known = true;}})});
        if(is_known===false){
            prev.push(setting)
        }
        return prev;
    },[]);

    return unknownSettings.reduce(function(prev,setting){
        var options = settingToOptions[setting];
        var simulationResult = options.reduce(function(prev,currentOption){
            modifyOption(activations,currentOption,true);
            var optionScores = evaluateScoresNaively(activations);
            var res = extractSuggestions(optionScores,activations,numSuggestions);
            modifyOption(activations,currentOption,false);

            prev['suggestions'].push(res['suggestions']);
            prev['possible_choices_ids'].push(currentOption);
            prev['confidence']+=optionScores[currentOption]*res['confidence'];

            return prev;
            },
            {"confidence":0, "suggestions":[], "possible_choices_ids":[], "question_id":setting});


        if(simulationResult['confidence']>prev['confidence']){
            return simulationResult
        }else{
            return prev;
        }
    }, {"confidence":0})
};


