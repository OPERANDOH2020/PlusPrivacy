var core = require ("swarmcore");
core.createAdapter("FeedbackAdapter");
var persistence = undefined;
var  container = require("safebox").container;
var flow = require("callflow");
var uuid = require('uuid');
var apersistence = require('apersistence');
var fs = require('fs');
var feedbackJSON = null;
var feedbackJSONFile =  process.env.SWARM_PATH+"/operando/adapters/uam/resources/Feedback.json";


function registerModels(callback){
    var models = [
        {
            modelName:"UserFeedback",
            dataModel : {
                feedbackId:{
                    type: "string",
                    length:255,
                    index:true,
                    pk:true
                },
                userId:{
                    type: "string",
                    length:255,
                    index:true
                },
                feedback:{
                    type: "string",
                    length:8096
                }
            }
        }
    ];

    flow.create("registerModels",{
        begin:function(){
            this.errs = [];
            var self = this;
            models.forEach(function(model){
                persistence.registerModel(model.modelName,model.dataModel,self.continue("registerDone"));
            });

        },
        registerDone:function(err,result){
            if(err) {
                this.errs.push(err);
            }
        },
        end:{
            join:"registerDone",
            code:function(){
                if(callback && this.errs.length>0){
                    callback(this.errs);
                }else{
                    callback(null);
                }
            }
        }
    })()
}


container.declareDependency("FeedbackAdapter", ["mysqlPersistence"], function (outOfService, mysqlPersistence) {
    if (!outOfService) {
        persistence = mysqlPersistence;
        registerModels(function(errs){
            if(errs){
                console.error(errs);
            }else{
                try{
                    feedbackJSON = JSON.parse(fs.readFileSync(feedbackJSONFile));
                }catch(e){
                    throw new Error("You must put the settings file in resources using the JSON format. ");
                }
                console.log("FeedbackAdapter available!");
            }
        })

    } else {
        console.log("Disabling persistence...");
    }
});

getFeedbackQuestions = function(callback){
    if(feedbackJSON !== null){
        callback(undefined, feedbackJSON);
    }
    else {
        callback(new Error("FeedbackJSONIsNull"));
    }
};

submitFeedbackAnswer = function(userId, feedback, callback){
    flow.create("submitFeedbackFlow", {
        begin: function () {
            persistence.filter("FeedbackAdapter", {userId: userId}, this.continue("checkPreviousFeedback"));
        },
        checkPreviousFeedback: function (err, userFeedback) {
            if (err) {
                callback(err);
            }
            else if (userFeedback.length > 0) {
                userFeedback[0]['feedback'] = feedback;
                persistence.save(userFeedback[0], callback);
            }
            else {
                var feedbackRawObj = persistence.createRawObject("Form", uuid.v1());
                feedbackRawObj["userId"] = userId;
                feedbackRawObj["feedback"] = feedback;
                persistence.save(feedbackRawObj, callback);
            }
        }
    })();
};

