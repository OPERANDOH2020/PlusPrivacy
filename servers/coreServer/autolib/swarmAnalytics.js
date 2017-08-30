
/*
    The purpose is to map a swarm-phase-arguments combination to some value (analytic).

     argumentPatterns can be:
        - array -> if looks through all the swarm constructor parameters and it matches if the parameters are equal to the values in the array; if an argument parameter is "_" is matches anything
        - function -> the function receives the swarm constructor arguments and returns true if the rule applies and false otherwise




     Analytic is the actual string that should be returned as corresponding to the log.
     Possible values:
        string -- the value returned for a combination of parameters
        function -- function that takes as arguments the swarmName,swarmConstructor and the arguments used at runtime and returns a string


    Basically each rule is transformed in a function that receives the swarmName,constructor and arguments and,
    if the rule applies, it returns the result of the analytic function. Otherwise it returns undefined;

    The analytics are temporarily stored in a comma-separated string and once in a while they are dumped in the
    analytics file. This is done for optimization purposes.

    The job of the user is to define the rules.
 */

var logs = "";
var num_rows = 0;
const rowsThreshold = 1;
var analyticsFile = "/home/Storage/Workspace/PlusPrivacy/servers/coreServer/analyticsFile.csv";
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
        if(rule.argumentPatterns.apply(undefined,arguments)){
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