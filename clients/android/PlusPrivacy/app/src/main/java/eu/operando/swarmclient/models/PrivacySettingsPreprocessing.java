package eu.operando.swarmclient.models;

import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import eu.operando.models.privacysettings.OspSettings;
import eu.operando.models.privacysettings.Question;

/**
 * Created by Alex on 3/8/2018.
 */

public class PrivacySettingsPreprocessing {

    public OspSettings getResult(JsonElement result) {
        JSONObject preprocessResult = null;
        try {
            preprocessResult = modifyResult(new JSONObject(result.toString()));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.e("swclient Swarms: ", "getResult: " + preprocessResult.toString());
        OspSettings res = new Gson().fromJson(preprocessResult.toString(), OspSettings.class);
        return res;
    }

    public List<Question> getQuestionsResult(JsonElement result) {

        JSONArray preprocessResult = null;
        try {
            preprocessResult = modifyQuestionResult(new JSONObject(result.toString()));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.e("swclient Swarms: ", "getResult: " + preprocessResult.toString());
        Type collectionType = new TypeToken<Collection<Question>>(){}.getType();
        List<Question> res = new Gson().fromJson(preprocessResult.toString(), collectionType);
        return res;
    }

    public JSONArray modifyQuestionResult(JSONObject result) {

        JSONArray questionsJsonArray = convertJSONObjectToJSONArray(result,true);
        return modifyAvailableSettins(questionsJsonArray);
    }

    public JSONObject modifyResult(JSONObject result) {

        JSONArray questionsJsonArray = null;

        try {

            Iterator<String> keys = result.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                questionsJsonArray = convertJSONObjectToJSONArray(result.getJSONObject(key),
                        true);

                JSONArray availableQuestionsJsonArray = modifyAvailableSettins(questionsJsonArray);

                result.put(key, availableQuestionsJsonArray);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Log.e("questionsJsonArray res", result.toString());
        return result;
    }

    private JSONArray modifyAvailableSettins(JSONArray questionsJsonArray) {
        JSONArray availableQuestionsJsonArray = new JSONArray();
        try {
            for (int i = 0; i < questionsJsonArray.length(); ++i) {

                JSONObject writeJsonObj = null;

                writeJsonObj = questionsJsonArray.getJSONObject(i).getJSONObject("write");

                if (writeJsonObj.has("recommended") && writeJsonObj.has("availableSettings")
                        && writeJsonObj.getJSONObject("availableSettings")
                        .has((String) writeJsonObj.get("recommended"))) {

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
