package eu.operando.feedback.repository;

import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public interface FeedbackDataStore {

    FeedbackSubmitEntitty getFeedbackResponse();

    void setFeedbackResponse(FeedbackSubmitEntitty feedbackSubmitEntitty, final FeedbackRepository.OnSubmitFeedbackModelListener listener);

    FeedbackQuestionListEntity getFeedbackQuestionList(FeedbackRepository.OnFinishedLoadingModelListener onFinishedLoadingModelListener);

    boolean hasUserSubmittedAFeedback(final FeedbackRepository.HasUserSubmittedAFeedbackModelListener listener);
}
