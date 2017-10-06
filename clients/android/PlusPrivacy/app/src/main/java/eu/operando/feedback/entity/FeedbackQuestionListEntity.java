package eu.operando.feedback.entity;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackQuestionListEntity extends Swarm {
    public FeedbackQuestionListEntity(List<FeedbackQuestionEntity> feedbackQuestions, String swarmingName, String ctor, Object... commandArguments) {
        super(swarmingName, ctor, commandArguments);
        this.feedbackQuestions = feedbackQuestions;
    }

    @SerializedName("feedbackQuestions")
    private List<FeedbackQuestionEntity> feedbackQuestions;

    public List<FeedbackQuestionEntity> getFeedbackQuestions() {
        return feedbackQuestions;
    }

    public void setFeedbackQuestions(List<FeedbackQuestionEntity> feedbackQuestions) {
        this.feedbackQuestions = feedbackQuestions;
    }
}
