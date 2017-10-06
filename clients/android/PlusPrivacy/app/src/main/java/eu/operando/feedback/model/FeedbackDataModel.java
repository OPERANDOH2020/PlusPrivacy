package eu.operando.feedback.model;

import java.util.List;

import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public interface FeedbackDataModel {

    void getFeedbackResponseFromSharedPreferences();

    void setFeedbackResponseFromSharedPreferences(OnSubmitFeedbackPresenterListener listener);

    void submitFeedback(OnSubmitFeedbackPresenterListener listener);

    void getQuestions(OnFinishedPresenterListener listener);

    boolean areRequiredFieldsCompleted();

    FeedbackSubmitEntitty getFeedbackSubmitEntity();
    FeedbackSubmitEntitty getFeedbackSubmitEntity(List<FeedbackQuestionEntity> items);

    void hasUserSubmittedAFeedback(HasUserSubmittedAFeedbackPresenterListener listener);

    interface OnFinishedPresenterListener {
        void onFinished(List<FeedbackQuestionEntity> items);
    }

    interface OnSubmitFeedbackPresenterListener {
        void onSubmit();
        void onFailed();
    }

    interface HasUserSubmittedAFeedbackPresenterListener {
        void onHasUserSubmittedFeedback();
        void onHasUserNotSubmittedFeedback();
    }

}