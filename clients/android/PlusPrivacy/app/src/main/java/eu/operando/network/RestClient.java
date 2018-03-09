package eu.operando.network;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by Alex on 3/8/2018.
 */

public class RestClient {
    public static final String BASE_URL = "http://192.168.103.149:8080/";
    private static Api api;

    public static Api getApi() {

        if (api == null) {
            Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
                    .create();

            Interceptor tokenInterceptor = new PrivacySettingsInterceptor();
            OkHttpClient okHttpClient = new OkHttpClient.Builder()
                    .addInterceptor(tokenInterceptor)
                    .build();

            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .client(okHttpClient)
                    .addConverterFactory(GsonConverterFactory.create(gson))
                    .build();
            api = retrofit.create(Api.class);
        }
        return api;

    }
}