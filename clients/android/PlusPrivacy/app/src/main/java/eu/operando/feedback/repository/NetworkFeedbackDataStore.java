package eu.operando.feedback.repository;

import android.util.Log;

import com.google.gson.JsonElement;

import eu.operando.feedback.SwarmCallbackModified;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackResultSwarmModel;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class NetworkFeedbackDataStore implements FeedbackDataStore {

    @Override
    public FeedbackSubmitEntitty getFeedbackResponse() {
        return null;
    }

    @Override
    public void setFeedbackResponse(FeedbackSubmitEntitty feedbackSubmitEntitty, final FeedbackRepository.OnSubmitFeedbackModelListener listener) {
        SwarmService.getInstance().submitFeedback(new SwarmCallbackModified<Swarm>() {

            @Override
            public void call(Swarm result) {
                Log.e("submitFeedback", result.toString());
                listener.onSubmitFeedbackRep();
            }
        }, feedbackSubmitEntitty.getJsonElement());
    }

    @Override
    public FeedbackQuestionListEntity getFeedbackQuestionList(final FeedbackRepository.OnFinishedLoadingModelListener listener) {
        SwarmService.getInstance().getFeedbackQuestions(new SwarmCallbackModified<FeedbackQuestionListEntity>() {

            @Override
            public void call(Swarm result) {
                try {
                    FeedbackQuestionListEntity questions = ((FeedbackQuestionListEntity) result);
                    listener.onFinishedLoadingRep(questions);
                } catch (Exception e) {
                    listener.onErrorModel();
                }
            }
        });
        return null;
    }

    @Override
    public boolean hasUserSubmittedAFeedback(final FeedbackRepository.HasUserSubmittedAFeedbackModelListener listener) {
        SwarmService.getInstance().hasUserSubmittedAFeedback(new SwarmCallbackModified<FeedbackResultSwarmModel>() {

            @Override
            public void call(Swarm result) {

                Log.e("hasUserSubmittedAFeed", result.toString());
                JsonElement jsonElement = ((FeedbackResultSwarmModel) result).getJsonElement();

                if (jsonElement.getAsJsonObject().entrySet().size() == 0) {

                    listener.onHasUserNotSubmittedFeedbackRep();

                } else {

                    FeedbackSubmitEntitty feedbackSubmitEntitty = new FeedbackSubmitEntitty(jsonElement);
                    listener.onHasUserSubmittedFeedbackRep(feedbackSubmitEntitty, listener);
                }
            }
        });

        return false;
    }

}