package eu.operando.feedback.model;

import android.util.Log;

import java.util.List;

import eu.operando.feedback.entity.DataStoreType;
import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.feedback.repository.FeedbackDataRepository;
import eu.operando.feedback.repository.FeedbackRepository;

import static eu.operando.feedback.entity.FeedbackSubmitEntitty.MULTIPLE_SELECTION;
import static eu.operando.feedback.entity.FeedbackSubmitEntitty.RADIO;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackDataModelImpl implements FeedbackDataModel,
        FeedbackRepository.HasUserSubmittedAFeedbackModelListener,
        FeedbackRepository.OnFinishedLoadingModelListener,
        FeedbackRepository.OnSubmitFeedbackModelListener {

    private FeedbackSubmitEntitty feedbackSubmitEntitty;
    private List<FeedbackQuestionEntity> questions;

    private FeedbackRepository feedbackRepository;

//    public FeedbackDataModelImpl(SharedPreferencesReader sharedPreferencesReader) {
//        feedbackRepository = new FeedbackDataRepository(sharedPreferencesReader);
//    }

    public FeedbackDataModelImpl() {
        feedbackRepository = new FeedbackDataRepository();
    }

    private HasUserSubmittedAFeedbackPresenterListener hasUserSubmittedAFeedbackPresenterListener;
    private OnFinishedPresenterListener onFinishedListener;
    private OnSubmitFeedbackPresenterListener onSubmitFeedbackPresenterListener;

//  #########################################################
//  FeedbackRepository.HasUserSubmittedAFeedbackModelListener

    @Override
    public void onHasUserSubmittedFeedbackRep(FeedbackSubmitEntitty feedbackSubmitEntitty, final FeedbackRepository.HasUserSubmittedAFeedbackModelListener listener) {

        this.feedbackSubmitEntitty = feedbackSubmitEntitty;
        hasUserSubmittedAFeedbackPresenterListener.onHasUserSubmittedFeedback();
    }

    @Override
    public void onHasUserNotSubmittedFeedbackRep() {
        hasUserSubmittedAFeedbackPresenterListener.onHasUserNotSubmittedFeedback();
    }

//    ######################################################

    @Override
    public void hasUserSubmittedAFeedback(final HasUserSubmittedAFeedbackPresenterListener listener) {

        this.hasUserSubmittedAFeedbackPresenterListener = listener;
        feedbackRepository.hasUserSubmittedAFeedback(DataStoreType.NETWORK, this);
    }

//  ########################################################
//  FeedbackRepository.OnFinishedLoadingModelListener

    @Override
    public void onFinishedLoadingRep(FeedbackQuestionListEntity items) {
        this.questions = items.getFeedbackQuestions();
        onFinishedListener.onFinished(questions);
    }

    @Override
    public void onErrorModel() {

    }
    //  #########################################################

    @Override
    public void getQuestions(final OnFinishedPresenterListener listener) {
        this.onFinishedListener = listener;
        feedbackRepository.getFeedbackQuestions(DataStoreType.NETWORK, this);
    }

//  #########################################################
//    OnSubmitFeedbackModelListener
//  #########################################################

    @Override
    public void onSubmitFeedbackRep() {
        onSubmitFeedbackPresenterListener.onSubmit();
    }

    @Override
    public void onFailedFeedbackRep() {
        onSubmitFeedbackPresenterListener.onFailed();
    }

    //  #########################################################

    @Override
    public void submitFeedback(final OnSubmitFeedbackPresenterListener onSubmitFeedbackListener) {
        this.onSubmitFeedbackPresenterListener = onSubmitFeedbackListener;

        if (!areRequiredFieldsCompleted()) {
            onSubmitFeedbackListener.onFailed();
        } else {
            feedbackRepository.setFeedbackResponse(DataStoreType.NETWORK, feedbackSubmitEntitty, this);
        }
    }

    //  #########################################################

    @Override
    public void getFeedbackResponseFromSharedPreferences() {
        feedbackSubmitEntitty = this.feedbackRepository.getFeedbackResponse(DataStoreType.SHARED_PREFERENCES);
    }

    public void setFeedbackResponseFromSharedPreferences(final OnSubmitFeedbackPresenterListener onSubmitFeedbackListener) {
        this.onSubmitFeedbackPresenterListener = onSubmitFeedbackListener;
        this.feedbackRepository.setFeedbackResponse(DataStoreType.SHARED_PREFERENCES, feedbackSubmitEntitty, this);
    }

    //  #########################################################

    public boolean areRequiredFieldsCompleted() {

        for (FeedbackQuestionEntity question : questions) {
            if (question.isRequired()) {
                switch (question.getType()) {
                    case MULTIPLE_SELECTION:
                        for (String str : feedbackSubmitEntitty.getSubmitTitlesForItems(question)) {
                            if (feedbackSubmitEntitty.getStringValue(str).equals("")) {
                                return false;
                            }
                        }
                        break;
                    case RADIO:
                        if (feedbackSubmitEntitty.getStringValue(question.getTitle()).equals("")) {
                            return false;
                        }
                        break;
                }
            }
        }
        return true;
    }

    @Override
    public FeedbackSubmitEntitty getFeedbackSubmitEntity() {

        if (feedbackSubmitEntitty == null) {
            feedbackSubmitEntitty = new FeedbackSubmitEntitty();
        }
        return feedbackSubmitEntitty;
    }

    @Override
    public FeedbackSubmitEntitty getFeedbackSubmitEntity(List<FeedbackQuestionEntity> items) {

        Log.e("getFeedbackSubmitEntity", "call");
        if (feedbackSubmitEntitty == null || feedbackSubmitEntitty.isEmpty()) {
            feedbackSubmitEntitty = new FeedbackSubmitEntitty(items);
        }
        return feedbackSubmitEntitty;
    }

}