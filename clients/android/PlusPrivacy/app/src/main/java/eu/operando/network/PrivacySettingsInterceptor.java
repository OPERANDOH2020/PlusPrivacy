package eu.operando.network;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;

import eu.operando.PlusPrivacyApp;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;

/**
 * Created by Alex on 3/9/2018.
 */

public class PrivacySettingsInterceptor implements Interceptor {


    @Override
    public Response intercept(Chain chain) throws IOException {

        Request initialRequest = chain.request();

//        if (initialRequest.url().toString()
//                .endsWith("social-networks/privacy-settings")) {
//            Log.e("interceptor", "catch request");
//
//            String file = loadJSONFromAsset();
//            MediaType contentType = MediaType.parse("application/json");
//            ResponseBody body = ResponseBody.create(contentType, file);
//
//            Response.Builder responseBuilder = new Response.Builder()
//                    .request(initialRequest)
//                    .protocol(Protocol.HTTP_1_1)
//                    .code(200)
//                    .message("OK")
//                    .body(body);
//
//            return responseBuilder.build();
//        }

        Response response = chain.proceed(initialRequest);
        return response;
    }

    public String loadJSONFromAsset() {
        String json = null;
        try {
            InputStream is = PlusPrivacyApp.getInstance().getAssets().open("osp.js");

            int size = is.available();

            byte[] buffer = new byte[size];

            is.read(buffer);

            is.close();

            json = new String(buffer, "UTF-8");


        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;

    }

}