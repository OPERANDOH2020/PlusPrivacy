package eu.operando.network;

import com.google.gson.JsonElement;

import java.util.List;

import eu.operando.feedback.entity.FeedbackQuestionEntity;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackSubmitEntitty;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;

/**
 * Created by Alex on 3/8/2018.
 */

public interface Api {

    @GET("/social-networks/privacy-settings/all")
    Call<JsonElement> getPrivacySettings();

    @GET("/social-networks/privacy-settings/facebook")
    Call<JsonElement> getFacebookSettings();

    @GET("/social-networks/privacy-settings/twitter")
    Call<JsonElement> getTwitterSettings();

    @GET("/social-networks/privacy-settings/linkedin")
    Call<JsonElement> getLinkedinSettings();

    @GET("/social-networks/privacy-settings/google")
    Call<JsonElement> getGoogleSettings();

    @GET("/feedback/questions")
    Call<List<FeedbackQuestionEntity>> getFeedbackQuestions();

    @POST("/feedback/responses")
    Call<FeedbackSubmitEntitty> postAnswers(@Body JsonElement answers);
}
