package eu.operando.feedback.entity;

import com.google.gson.JsonElement;
import com.google.gson.annotations.SerializedName;

import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackResultSwarmModel extends Swarm {

    @SerializedName("feedback")
    private JsonElement jsonElement;

    public FeedbackResultSwarmModel(JsonElement element, String swarmingName, String ctor, Object... commandArguments) {
        super(swarmingName, ctor, commandArguments);
        jsonElement = element;
    }

    public JsonElement getJsonElement() {
        return jsonElement;
    }

    public void setJsonElement(JsonElement jsonElement) {
        this.jsonElement = jsonElement;
    }
}
