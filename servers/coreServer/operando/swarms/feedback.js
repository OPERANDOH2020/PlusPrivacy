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
    }

};
feedbackSwarming;
