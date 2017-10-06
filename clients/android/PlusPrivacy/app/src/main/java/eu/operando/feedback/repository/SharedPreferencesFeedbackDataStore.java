package eu.operando.feedback.repository;

import android.content.SharedPreferences;
import android.util.Log;

import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.feedback.view.SharedPreferencesReader;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SharedPreferencesFeedbackDataStore implements FeedbackDataStore {

    private SharedPreferencesReader sharedPreferencesReader;

    public SharedPreferencesFeedbackDataStore(SharedPreferencesReader sharedPreferencesReader) {
        this.sharedPreferencesReader = sharedPreferencesReader;
    }

    public SharedPreferencesFeedbackDataStore() {
    }

    @Override
    public FeedbackSubmitEntitty getFeedbackResponse() {

        SharedPreferences settings = sharedPreferencesReader.getSharedPreferences();
        String jsonFeedbackResponse = settings.getString(
                sharedPreferencesReader.getUserID(),
                ""
        );
        return new FeedbackSubmitEntitty(jsonFeedbackResponse);
    }

    @Override
    public void setFeedbackResponse(FeedbackSubmitEntitty feedbackSubmitEntitty, FeedbackRepository.OnSubmitFeedbackModelListener listener) {
        SharedPreferences settings = sharedPreferencesReader.getSharedPreferences();
        SharedPreferences.Editor editor = settings.edit();

        editor.putString(
                sharedPreferencesReader.getUserID(),
                feedbackSubmitEntitty.getJsonElement().toString()
        );
        editor.apply();

        Log.e("setFeedbackFromShared", feedbackSubmitEntitty.getJsonElement().toString());
    }

    @Override
    public FeedbackQuestionListEntity getFeedbackQuestionList(FeedbackRepository.OnFinishedLoadingModelListener onFinishedLoadingModelListener) {
        return null;
    }

    @Override
    public boolean hasUserSubmittedAFeedback(final FeedbackRepository.HasUserSubmittedAFeedbackModelListener listener) {
        return false;
    }
}
