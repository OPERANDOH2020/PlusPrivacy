
/*
    The purpose is to map a swarm-phase-arguments combination to some value (analytic).

    Each rule has 5 fields:
        swarmName - name of the swarm to match
        swarmConstructor - name of the swarmConstructor to match
        argumentPatterns - a function that uses the meta field of each swarm and the arguments with which the constructor is called to decide wheter the rule can be applied (returns true or false)
        analytics - a function that is called if the rule applies; it receives the meta and the arguments and runs some asynchronous function (e.g. updates database)
        toBeLogged - simmilar to analytics; however this function runs synchronously and produces a string that will be logged in the analytycsFile - basically raw logs

    The user needs to define rules and register them using the global function registerAnalyticsRule;
 */

var logs = "";
var num_rows = 0;
const rowsThreshold = 1;
var analyticsFile = global_swarmSystem_config.Core.rawAnalyticsFile;
var fs = require('fs');
var lockFile = require('lockfile');
var lockParameters = {
    retries: 5,
    retryWait: 100  //try 5 times to aquire lock 100ms apart from each other;
};
var analyticMatchFunctions = {};
var container = require('safebox').container;

function ruleMatcher(rule){
    return function(){
        if(!rule.argumentPatterns || rule.argumentPatterns.apply(undefined,arguments)){
            if(rule.analytics) {
                rule.analytics.apply(undefined, arguments);
            }
            if(rule.toBeLogged) {
                return rule.toBeLogged.apply(undefined,arguments);
            }
        }
    }
}

registerAnalyticsRule = function(rule){
    if(!rule.swarmName || !rule.swarmConstructor){
        throw new Error("Invalid rule. Each rule should have a swarmName and swarmConstructor");
    }
    var swarmKey = rule.swarmName+rule.swarmConstructor;
    if(!analyticMatchFunctions[swarmKey]){
        analyticMatchFunctions[swarmKey] = []
    }
    analyticMatchFunctions[swarmKey].push(ruleMatcher(rule))
}

performAnalytics = function(userId,swarmName,swarmConstructor,meta,swarmArguments){
    var swarmKey = swarmName+swarmConstructor;
    if(analyticMatchFunctions[swarmKey]){
        var temp = analyticMatchFunctions[swarmKey].map(function(analyticFunction){
                        var requiredLogs = analyticFunction(meta,swarmArguments);
                        if (requiredLogs!==undefined){
                            return userId+","+new Date()+","+requiredLogs+",\n";  // row in csv file
                        }
                    }).filter(function(log){
                        return log!=undefined;  //undefined values correspond to not matching the rules
                    });

        num_rows+=temp.length;

        logs+=temp.reduce(function(prev,current){
                return prev+current;
            },"");

        if(num_rows>=rowsThreshold){
            tryToPersist()
        }
    }
};

function tryToPersist(){
    lockFile.lock(analyticsFile+".lock",lockParameters,function(err){
        if(!err) {
            var temp = logs;
            var currentNrOfRows = num_rows;
            logs = "";
            num_rows=0;

            fs.appendFile(analyticsFile,temp,function (err,result){
                if(err){
                    logs =temp+logs;
                    num_rows +=currentNrOfRows
                }
                lockFile.unlock(analyticsFile + ".lock", function (err) {
                    if (err) {
                        console.error("Analytics error on unlocking!", err);
                    }
                });
            });
        }
    });
}


container.resolve("analytics","analytics"); 