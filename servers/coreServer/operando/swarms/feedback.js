var feedbackSwarming = {

    getFeedbackQuestions: function (myRequestId) {
        if(myRequestId){
            this.myRequestId = myRequestId;
        }
        this.swarm("getFeedbackFormQuestions");
    },
    submitFeedback: function (feedback, myRequestId) {

        if(myRequestId){
            this.myRequestId = myRequestId;
        }
        this.feedback = JSON.parse(feedback);
        this.swarm("submitFeedbackValues");
    },
    //TODO remove it. not used anymore
    /*hasUserSubmittedAFeedback:function(){
        this.userId = this.meta.userId;
        this.swarm("checkUserFeedback");
    },*/

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
                    self.swarm("returnFeedbackQuestions");
                }
            }));
        }
    },



    returnFeedbackQuestions :{
        node: "WSServer",
        code: function () {
            if(this.myRequestId){
                var swarmDispatcher = getSwarmDispatcher();
                swarmDispatcher.notifySubscribers(this.myRequestId, this.feedbackQuestions);
            }else{
                this.home("success");
            }
        }
    },


    submitFeedbackValues: {
        node: "FeedbackAdapter",
        code: function () {
            var self = this;
            submitFeedbackAnswer(this.feedback,S(function(err, feedback){
                self.feedbackId = feedback['feedbackId'];
                delete self.feedback;
                if (err) {
                    console.error(err);
                    self.home("error");
                }
                else {
                    self.swarm("returnFeedbackCompletion");
                }
            }));
        }
    },

    returnFeedbackCompletion:{
        node: "WSServer",
        code: function () {
            if(this.myRequestId){
                var swarmDispatcher = getSwarmDispatcher();
                swarmDispatcher.notifySubscribers(this.myRequestId,{"feedbackId":this.feedbackId});
            }else{
                this.home("success");
            }
        }
    },

    /**TODO To be removed - not used anymore
    /*checkUserFeedback:{
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
    },*/
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
