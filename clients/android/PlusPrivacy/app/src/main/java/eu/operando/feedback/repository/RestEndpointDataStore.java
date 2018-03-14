package eu.operando.feedback.repository;

import android.util.Log;

import com.google.gson.JsonElement;

import java.util.List;

import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackResultSwarmModel;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import eu.operando.network.RestClient;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by Alex on 3/13/2018.
 */

public class RestEndpointDataStore implements FeedbackDataStore {

    @Override
    public FeedbackSubmitEntitty getFeedbackResponse() {
        return null;
    }

    @Override
    public void setFeedbackResponse(FeedbackSubmitEntitty feedbackSubmitEntitty, final FeedbackRepository.OnSubmitFeedbackModelListener listener) {

        RestClient.getApi().postAnswers(feedbackSubmitEntitty.getJsonElement()).enqueue(new Callback<FeedbackSubmitEntitty>() {
            @Override
            public void onResponse(Call<FeedbackSubmitEntitty> call, Response<FeedbackSubmitEntitty> response) {
                if (response.body() != null) {
                    listener.onSubmitFeedbackRep();
                }
            }

            @Override
            public void onFailure(Call<FeedbackSubmitEntitty> call, Throwable t) {
                Log.e("submitFeedback", t.getMessage());
//                listener.onErrorModel();
            }
        });
    }

    @Override
    public void getFeedbackQuestionList(final FeedbackRepository.OnFinishedLoadingModelListener listener) {

        RestClient.getApi().getFeedbackQuestions().enqueue(new Callback<List<FeedbackQuestionEntity>>() {
            @Override
            public void onResponse(Call<List<FeedbackQuestionEntity>> call, Response<List<FeedbackQuestionEntity>> response) {
                if (response.body() != null) {
                    try {
                        listener.onFinishedLoadingRep(response.body());
                    } catch (Exception e) {
                        listener.onErrorModel();
                    }
                }
            }

            @Override
            public void onFailure(Call<List<FeedbackQuestionEntity>> call, Throwable t) {
                listener.onErrorModel();
            }
        });
    }

    @Override
    public boolean hasUserSubmittedAFeedback(final FeedbackRepository.HasUserSubmittedAFeedbackModelListener listener) {

        return false;
    }

}