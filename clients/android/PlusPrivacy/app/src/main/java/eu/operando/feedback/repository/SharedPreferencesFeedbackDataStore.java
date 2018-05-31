package eu.operando.feedback.repository;

import android.content.SharedPreferences;
import android.util.Log;

import com.google.gson.JsonElement;

import javax.inject.Inject;

import eu.operando.PlusPrivacyApp;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackResultSwarmModel;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.feedback.repository.di.MySharedPreferences;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SharedPreferencesFeedbackDataStore implements FeedbackDataStore {

    private final String HAS_SUBMITTED_FEEDBACK = "hasSubmitted";
    private final String RESPONSE = "responses";

    @Inject
    public MySharedPreferences mySharedPreferences;

    public SharedPreferencesFeedbackDataStore() {
        PlusPrivacyApp.getMyComponent().inject(this);
    }

    @Override
    public FeedbackSubmitEntitty getFeedbackResponse() {

        SharedPreferences settings = mySharedPreferences.getmSharedPreferences();
        String jsonFeedbackResponse = settings.getString(
                RESPONSE,
                ""
        );
        return new FeedbackSubmitEntitty(jsonFeedbackResponse);
    }

    @Override
    public void setFeedbackResponse(FeedbackSubmitEntitty feedbackSubmitEntitty, FeedbackRepository.OnSubmitFeedbackModelListener listener) {

        submitFeedback();
        SharedPreferences settings = mySharedPreferences.getmSharedPreferences();
        SharedPreferences.Editor editor = settings.edit();

        editor.putString(
                RESPONSE,
                feedbackSubmitEntitty.getJsonElement().toString()
        );
        editor.apply();

        Log.e("setFeedbackFromShared", feedbackSubmitEntitty.getJsonElement().toString());
    }

    @Override
    public void getFeedbackQuestionList(FeedbackRepository.OnFinishedLoadingModelListener onFinishedLoadingModelListener) {
    }

    @Override
    public boolean hasUserSubmittedAFeedback(final FeedbackRepository.HasUserSubmittedAFeedbackModelListener listener) {

        SharedPreferences settings = mySharedPreferences.getmSharedPreferences();
        boolean hasSubmitted = settings.getBoolean(
                HAS_SUBMITTED_FEEDBACK,
                false
        );

        if (hasSubmitted) {
            listener.onHasUserSubmittedFeedbackRep(null, listener);
        } else {
            listener.onHasUserNotSubmittedFeedbackRep();
        }

        return false;
    }

    public void submitFeedback() {

        SharedPreferences settings = mySharedPreferences.getmSharedPreferences();
        SharedPreferences.Editor editor = settings.edit();

        editor.putBoolean(HAS_SUBMITTED_FEEDBACK, true);
        editor.apply();
    }
}
