package eu.operando.swarmclient.models;

import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

/**
 * Created by Matei_Alexandru on 01.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public abstract class PrivacyWizardSwarmCallback<T extends Swarm> extends SwarmCallback {

    @SuppressWarnings("unchecked")
    public PrivacyWizardSwarmCallback() {
        super();
    }

    public void result(JSONObject result) {
        result = modifyResult(result);
        Log.e("swclient Swarms: ", "result: " + result.toString());
        T t = new Gson().fromJson(result.toString(), (Class<T>) super.getType());
        call(t);
    }

    private JSONObject modifyResult(JSONObject result) {
//        Log.e("questionsJsonArray res", result.toString());
        JSONArray questionsJsonArray = null;
//        List<Question> questionList = new ArrayList<>();

        try {

            Iterator<String> keys = result.getJSONObject("ospSettings").keys();
            while (keys.hasNext()) {
                String key = keys.next();
                questionsJsonArray = convertJSONObjectToJSONArray(result
                        .getJSONObject("ospSettings").getJSONObject(key), true);

                JSONArray availableQuestionsJsonArray = modifyAvailableSettins(questionsJsonArray);

                result.getJSONObject("ospSettings").put(key, availableQuestionsJsonArray);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

//        Log.e("questionsJsonArray", questionsJsonArray.toString());
        Log.e("questionsJsonArray res", result.toString());
        return result;
    }

    private JSONArray modifyAvailableSettins(JSONArray questionsJsonArray) {
        JSONArray availableQuestionsJsonArray = new JSONArray();
        try {
            for (int i = 0; i < questionsJsonArray.length(); ++i) {

                JSONObject writeJsonObj = null;

                writeJsonObj = questionsJsonArray.getJSONObject(i).getJSONObject("write");

//                    Log.e("modifyResult", writeJsonObj.toString());
                if (writeJsonObj.has("recommended") && writeJsonObj.has("availableSettings")
                        && writeJsonObj.getJSONObject("availableSettings")
                        .has((String) writeJsonObj.get("recommended"))) {

//                        Log.e("modifyResult", "true condition");
                    questionsJsonArray.getJSONObject(i).getJSONObject("read")
                            .put("availableSettings", convertJSONObjectToJSONArray(
                                    questionsJsonArray.getJSONObject(i).getJSONObject("read")
                                            .getJSONObject("availableSettings"), true)
                            );

                    writeJsonObj
                            .put("availableSettings", convertJSONObjectToJSONArray(
                                    questionsJsonArray.getJSONObject(i).getJSONObject("write")
                                            .getJSONObject("availableSettings"), true)
                            );
////
                    JSONArray availableSettinsJSONArray = writeJsonObj
                            .getJSONArray("availableSettings");

                    Log.e("availableSettings1", availableSettinsJSONArray.toString());

                    for (int j = 0; j < availableSettinsJSONArray.length(); ++j) {

                        JSONObject setting = availableSettinsJSONArray.getJSONObject(j);
                        if (setting.has("params")) {
                            setting.put("params", convertJSONObjectToJSONArray(
                                    setting.getJSONObject("params"),
                                    true)
                            );
                        }
                    }
                    Log.e("availableSettings2", availableSettinsJSONArray.toString());
////
                    availableQuestionsJsonArray.put(questionsJsonArray.getJSONObject(i));
                }
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return availableQuestionsJsonArray;
    }

    public JSONArray convertJSONObjectToJSONArray(JSONObject jsonObject, boolean isQuestion) {

        JSONArray newJsonArray = new JSONArray();
        Iterator<String> keys = jsonObject.keys();

        while (keys.hasNext()) {
            String key = keys.next();
            try {
                JSONObject value = (JSONObject) jsonObject.get(key);

                if (isQuestion)
                    value.put("tag", key);

                if (jsonObject.get(key) instanceof JSONObject) {
                    newJsonArray.put(value);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return newJsonArray;
    }
}
