package eu.operando.network;

import com.google.gson.JsonElement;

import org.json.JSONObject;

import eu.operando.models.privacysettings.OspSettings;
import retrofit2.Call;
import retrofit2.http.GET;

/**
 * Created by Alex on 3/8/2018.
 */

public interface Api {

    @GET("/social-networks/privacy-settings")
    Call<JsonElement> getPrivacySettings();
}
