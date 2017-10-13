package eu.operando.feedback.repository;

import android.content.SharedPreferences;
import android.util.Log;

import javax.inject.Inject;

import eu.operando.PlusPrivacyApp;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.feedback.repository.dagger.MySharedPreferences;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SharedPreferencesFeedbackDataStore implements FeedbackDataStore {

    @Inject
    public MySharedPreferences mySharedPreferences;

    public SharedPreferencesFeedbackDataStore() {
        PlusPrivacyApp.getMyComponent().inject(this);
    }

    @Override
    public FeedbackSubmitEntitty getFeedbackResponse() {

        SharedPreferences settings = mySharedPreferences.getmSharedPreferences();
        String jsonFeedbackResponse = settings.getString(
                mySharedPreferences.getUserID(),
                ""
        );
        return new FeedbackSubmitEntitty(jsonFeedbackResponse);
    }

    @Override
    public void setFeedbackResponse(FeedbackSubmitEntitty feedbackSubmitEntitty, FeedbackRepository.OnSubmitFeedbackModelListener listener) {
        SharedPreferences settings = mySharedPreferences.getmSharedPreferences();
        SharedPreferences.Editor editor = settings.edit();

        editor.putString(
                mySharedPreferences.getUserID(),
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
