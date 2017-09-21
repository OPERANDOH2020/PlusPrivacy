var feedbackSwarming = {

    getFeedbackQuestions: function () {
        this.swarm("getFeedbackFormQuestions");
    },
    submitFeedback: function (feedback) {
        this.feedback = feedback;
        this.swarm("submitFeedbackValues")
    },
    hasUserSubmittedAFeedback:function(){
        this.userId = this.meta.userId;
        this.swarm("checkUserFeedback");
    },

    getAllFeedback:function(){
        this.userId = this.meta.userId;
        this.swarm("checkUserAuthorisation");
    },

    getFeedbackFormQuestions: {
        node: "FeedbackAdapter",
        code: function () {
            var self = this;
            getFeedbackQuestions(S(function (err, feedbackQuestions) {
                if (err) {
                    console.error(err);
                    self.home("error");
                }
                else {
                    self.feedbackQuestions = feedbackQuestions;
                    self.home("success");
                }
            }));
        }
    },

    submitFeedbackValues: {
        node: "FeedbackAdapter",
        code: function () {
            var self = this;

            submitFeedbackAnswer(this.meta.userId, this.feedback,S(function(err, feedback){
                delete self.feedback;
                if (err) {
                    console.error(err);
                    self.home("error");
                }
                else {
                    self.home("success");
                }
            }));
        }
    },
    checkUserFeedback:{
        node:"FeedbackAdapter",
        code:function(){
            var self = this;
            checkIfUserSubmittedFeedback(this.meta.userId, S(function (err, feedback) {
                if (err) {
                    console.log(err);
                    self.error = err;
                    self.home("error");
                }
                else {
                    self.feedback = feedback;
                    self.home("success");
                }
            }));
        }
    },
    checkUserAuthorisation:{
      node:"UsersManager",
        code: function () {
            var self = this;
            zonesOfUser(this.meta.userId, S(function (err, zones) {
                if (err) {
                    console.error(err);
                    self.error = err.message;
                    self.home("error");
                }
                else {
                    var zonesNames = zones.map(function(zone){
                        return zone.zoneName;
                    });
                    if (zonesNames.indexOf("Admin") === -1) {
                        self.error = "NotAllowed";
                        self.home("notAllowed");
                    }
                    else {
                        self.swarm("retrieveAllFeedback");
                    }
                }
            }));
        }
    },
    retrieveAllFeedback:{
        node:"FeedbackAdapter",
        code:function(){
            var self = this;
            retrieveAllFeedback(S(function(err, feedbackResponses){
                if (err) {
                    console.error(err);
                    self.error = err.message;
                    self.home("error");
                }else{
                    var feedbackResponses = feedbackResponses.map(function(f){
                       return JSON.parse(f.feedback);
                    });
                    self.feedbackResponses = feedbackResponses;
                    self.home("success");
                }
            }));
        }
    }
};
feedbackSwarming;
