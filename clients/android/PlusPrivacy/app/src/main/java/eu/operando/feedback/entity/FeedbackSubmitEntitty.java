package eu.operando.feedback.entity;

import android.util.Log;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Matei_Alexandru on 29.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackSubmitEntitty {

    public static final String MULTIPLE_RATING = "multipleRating";
    public static final String MULTIPLE_SELECTION = "multipleSelection";
    public static final String TEXT_INPUT = "textInput";
    public static final String RADIO = "radio";

    @SerializedName("feedback")
    private JsonElement jsonElement;

    public FeedbackSubmitEntitty(JsonElement jsonElement) {
        this.jsonElement = jsonElement;
    }

    public FeedbackSubmitEntitty() {
        this.jsonElement = new JsonObject();
    }

    public FeedbackSubmitEntitty(String items) {
        Log.e("items jsonElement", items);
        this.jsonElement = new JsonParser().parse(items);;
        Log.e("jsonElement", jsonElement.toString());
    }

    public FeedbackSubmitEntitty(List<FeedbackQuestionEntity> items) {
        this.jsonElement = new JsonObject();
        Log.e("setFeedbackSubmitEntity", items.toString());
        for (FeedbackQuestionEntity questionEntity : items) {
            switch (questionEntity.getType()){
                case MULTIPLE_RATING:
                    for (String item : questionEntity.getItems()){
                        putStringAnswer(getSubmitTitleForItems(questionEntity, item), "");
                    }
                    break;
                case MULTIPLE_SELECTION:
                    for (String item : questionEntity.getItems()){
                        putStringAnswer(getSubmitTitleForItems(questionEntity, item), "");
                    }
                    break;
                case TEXT_INPUT:
                    putStringAnswer(questionEntity.getTitle(), "");
                    break;
                case RADIO:
                    putStringAnswer(questionEntity.getTitle(), "");
                    break;
                default:
                    break;
            }
        }
    }

    public String getSubmitTitleForItems(FeedbackQuestionEntity question, String item) {
        StringBuilder sb = new StringBuilder();
        sb.append(question.getTitle())
                .append("[")
                .append(item)
                .append("]");
        return sb.toString();
    }

    public List<String> getSubmitTitlesForItems(FeedbackQuestionEntity question) {
        List<String> titles = new ArrayList<>();
        for (String item : question.getItems()){
            titles.add(getSubmitTitleForItems(question, item));
        }
        return titles;
    }

    public void putBooleanAnswer(String property, Boolean value){
        jsonElement.getAsJsonObject().addProperty(property, value);
    }

    public void putStringAnswer(String property, String value){
        jsonElement.getAsJsonObject().addProperty(property, value);
    }

    public String getStringValue(String key){
        return jsonElement.getAsJsonObject().get(key).getAsString();
    }

    public Boolean getBooleanValue(String key){
        return jsonElement.getAsJsonObject().get(key).getAsBoolean();
    }

    public JsonElement getJsonElement() {
        return jsonElement;
    }

    public void setJsonElement(JsonElement jsonElement) {
        this.jsonElement = jsonElement;
    }

    public boolean isEmpty(){
        return jsonElement.isJsonNull();
    }

}
