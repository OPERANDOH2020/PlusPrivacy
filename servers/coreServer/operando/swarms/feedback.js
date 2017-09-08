var feedbackSwarming = {

    getFeedbackQuestions: function () {
        this.swarm("getFeedbackFormQuestions");
    },
    submitFeedback: function (feedback) {
        this.feedback = feedback;
        this.swarm("submitFeedbackValues")
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
                if (err) {
                    console.error(err);
                    self.home("error");
                }
                else {
                    self.home("success");
                }
            }));
        }
    }


};
feedbackSwarming;
