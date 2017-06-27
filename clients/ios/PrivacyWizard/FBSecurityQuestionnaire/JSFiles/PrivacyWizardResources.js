var questionAndSuggestions = function(unknownSettings, settingsToOptions, num_suggestions) {
	unknownSettings.reduce(function (prev, setting) {
    	var options = settingsToOptions[setting];
        var simulationResult = options.reduce(function (prev, currentOption) {
        	modifyOption(activations, currentOption, true);
            var optionScores = evaluateScoresNaively(activations);
            var res = extractSuggestions(optionScores, activations, num_suggestions);
            modifyOption(activations, currentOption, false);
                                                                                              
            prev['suggestions'].push(res['suggestions']);
            prev['possible_choices_ids'].push(currentOption);
            prev['confidence'] += optionScores[currentOption] * res['confidence'];
                                                                                              
            return prev;
    	}, {
        	"confidence": 0,
            "suggestions": [],
            "possible_choices_ids": [],
            "question_id": setting
        });
                                                        
		if (simulationResult['confidence'] > prev['confidence']) {
			return simulationResult
		} else {
			return prev;
		}
	}, {
       		"confidence": 0
		}
	);
}

var getUnknownSettings = function(settingsToOptions, activeOptions) {
	settingsToOptions.reduce(function (prev, options, setting) {
        var is_known = false;
        options.forEach(function (option) {
            activeOptions.forEach(function (activeOption) {
                if (option === activeOption) {
                    is_known = true;
                }
        	})
        });
        if (is_known === false) {
            prev.push(setting)
        }
        return prev;
    }, []);
}

var evaluateScoresNaively = function(currentProbabilities, conditionalProbabilitiesMatrix) {
    return vecMatrixMultiplication(currentProbabilities, conditionalProbabilitiesMatrix);
}
    
var modifyOption = function(currentProbabilities, optionToModify, activate, initialProbabilities) {
    settingsToOptions[optionsToSettings[optionToModify]].forEach(function (option) {
    	if (option === optionToModify) {
        	currentProbabilities[option] = activate ? 1 : initialProbabilities[option]
        } else {
			currentProbabilities[option] = activate ? 0 : initialProbabilities[option]
		}
	})
};
    
var extractSuggestions = function(optionScores, activations, numSuggestions, optionsToSettings) {
    var suggestions = argSort(optionScores);
    var bestSuggestions = [];
    
    for (var i = num_options - 1; i >= 0; i--) {
        if (activations[suggestions[i]] === 1 || activations[suggestions[i]] === 0) {
            continue;
        }
        
        if (bestSuggestions.some(function (otherSuggestion) {
            if (optionsToSettings[otherSuggestion] === optionsToSettings[suggestions[i]]) {
                return true;
            }
            
        	return false;
        }) == false) {
            bestSuggestions.push(suggestions[i]);
            if (bestSuggestions.length === numSuggestions) {
                break;
            }
        }
    }
        
    var confidence = bestSuggestions.reduce(function (prev, option) {
                        						return prev + optionScores[option]
                                            }, 0);
        
    return {
        "suggestions": bestSuggestions,
        "confidence": confidence
    }
};

var argSort = function(array){
    //the equivalent of argsort from numpy
    var args = new Array(array.length);
    var argsOfValues = {}
    
    array.forEach(function (value,index) {
    	if (argsOfValues[value]) {
        	argsOfValues[value].push(index);
        } else {
            argsOfValues[value] = [index]
        }
    })
    
    array.sort();
    array.forEach(function(value,index) {
    	args[index] = argsOfValues[value].shift();
    });
        
    return args
};

var vecMatrixMultiplication = function(vector, matrix) {
    var result = new Array(matrix[0].length).fill(0);
    
    for (var i = 0; i < vector.length; i++) {
        for (var j = 0; j < vector.length; j++) {
            result[i] += vector[j] * matrix[j][i]
        }
    }
        
    return result;
};