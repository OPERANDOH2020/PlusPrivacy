package eu.operando.feedback.repository;

import eu.operando.feedback.entity.DataStoreType;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.feedback.view.SharedPreferencesReader;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackDataRepository implements FeedbackRepository {

    private FeedbackDataStoreFactory feedbackDataStoreFactory;

    public FeedbackDataRepository(SharedPreferencesReader sharedPreferencesReader) {
        this.feedbackDataStoreFactory = new FeedbackDataStoreFactory(sharedPreferencesReader);
    }

    @Override
    public FeedbackQuestionListEntity getFeedbackQuestions(DataStoreType provider, FeedbackRepository.OnFinishedLoadingModelListener onFinishedLoadingModelListener) {
        FeedbackDataStore feedbackDataStore = feedbackDataStoreFactory.create(provider);
        return feedbackDataStore.getFeedbackQuestionList(onFinishedLoadingModelListener);
    }

    @Override
    public FeedbackSubmitEntitty getFeedbackResponse(DataStoreType provider) {
        FeedbackDataStore feedbackDataStore = feedbackDataStoreFactory.create(provider);
        return feedbackDataStore.getFeedbackResponse();
    }

    @Override
    public void setFeedbackResponse(DataStoreType provider, FeedbackSubmitEntitty feedbackSubmitEntitty, OnSubmitFeedbackModelListener listener) {
        FeedbackDataStore feedbackDataStore = feedbackDataStoreFactory.create(provider);
        feedbackDataStore.setFeedbackResponse(feedbackSubmitEntitty, listener);
    }

    @Override
    public void hasUserSubmittedAFeedback(DataStoreType provider, final HasUserSubmittedAFeedbackModelListener listener) {
        FeedbackDataStore feedbackDataStore = feedbackDataStoreFactory.create(provider);
        feedbackDataStore.hasUserSubmittedAFeedback(listener);
    }

}