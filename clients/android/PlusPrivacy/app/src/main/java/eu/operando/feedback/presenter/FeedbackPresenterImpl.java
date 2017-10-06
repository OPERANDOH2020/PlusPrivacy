package eu.operando.feedback.presenter;

import android.util.Log;

import java.util.List;

import eu.operando.feedback.model.FeedbackDataModel;
import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.view.FeedbackView;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackPresenterImpl implements FeedbackPresenter,
        FeedbackDataModel.OnFinishedPresenterListener, FeedbackDataModel.OnSubmitFeedbackPresenterListener,
        FeedbackDataModel.HasUserSubmittedAFeedbackPresenterListener
{

    private FeedbackView feedbackView;
    private FeedbackDataModel feedbackDataModel;

    public FeedbackPresenterImpl(FeedbackView feedbackActivity, FeedbackDataModel feedbackDataModel) {
        this.feedbackView = feedbackActivity;
        this.feedbackDataModel = feedbackDataModel;
    }

    @Override
    public void onLoading() {
        feedbackDataModel.hasUserSubmittedAFeedback(this);
    }

    @Override
    public void onHasUserSubmittedFeedback() {
        feedbackView.installFeedbackFragment();
    }

    @Override
    public void onHasUserNotSubmittedFeedback() {
        if (feedbackView != null) {
            feedbackView.showProgress();
        }
        feedbackDataModel.getQuestions(this);
    }

    @Override
    public void onDestroy() {
        feedbackView = null;
    }

    @Override
    public void saveState() {
        Log.e("onDestroy submit", feedbackDataModel.getFeedbackSubmitEntity().getJsonElement().getAsJsonObject().toString());
        feedbackDataModel.setFeedbackResponseFromSharedPreferences(this);
    }

    @Override
    public void restoreState() {
        feedbackDataModel.getFeedbackResponseFromSharedPreferences();
    }

    @Override
    public void submitFeedback() {
        feedbackDataModel.submitFeedback(this);
    }

    @Override
    public void onClickChangeFeedbackResponse() {
        feedbackView.uninstallFeedbackFragment();
        if (feedbackView != null) {
            feedbackView.showProgress();
        }
        feedbackDataModel.getQuestions(this);
    }

    @Override
    public void onFinished(List<FeedbackQuestionEntity> items) {
        if (feedbackView != null) {
            Log.e("onFinished", "onFinished: " + items.toString());
//            feedbackView.hideProgress();
            feedbackView.setItems(items, feedbackDataModel.getFeedbackSubmitEntity(items));
        }
    }

    @Override
    public void onSubmit() {
        feedbackView.showMessageForSubmittedFeedback("Thank you for your feedback!");
    }

    @Override
    public void onFailed() {
        feedbackView.showMessageForErrorOnSubmit("Fields with marks(*) are required.");
    }
}
