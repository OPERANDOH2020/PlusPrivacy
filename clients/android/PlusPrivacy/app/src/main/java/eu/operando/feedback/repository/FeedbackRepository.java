package eu.operando.feedback.repository;

import eu.operando.feedback.entity.DataStoreType;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public interface FeedbackRepository {

    FeedbackQuestionListEntity getFeedbackQuestions(DataStoreType provider, FeedbackRepository.OnFinishedLoadingModelListener onFinishedLoadingModelListener);

    void setFeedbackResponse(DataStoreType provider, FeedbackSubmitEntitty feedbackSubmitEntitty, OnSubmitFeedbackModelListener listener);

    FeedbackSubmitEntitty getFeedbackResponse(DataStoreType provider);

    void hasUserSubmittedAFeedback(DataStoreType provider, final HasUserSubmittedAFeedbackModelListener listener);

    interface HasUserSubmittedAFeedbackModelListener {
        void onHasUserSubmittedFeedbackRep(FeedbackSubmitEntitty feedbackSubmitEntitty, final HasUserSubmittedAFeedbackModelListener listener);
        void onHasUserNotSubmittedFeedbackRep();
    }

    interface OnFinishedLoadingModelListener {
        void onFinishedLoadingRep(FeedbackQuestionListEntity items);
        void onErrorModel();
    }

    interface OnSubmitFeedbackModelListener {
        void onSubmitFeedbackRep();
        void onFailedFeedbackRep();
    }

}
