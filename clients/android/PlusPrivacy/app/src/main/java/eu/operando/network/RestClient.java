package eu.operando.network;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import static eu.operando.swarmService.SwarmService.SWARMS_URL_DEBUG_RAFAEL;

/**
 * Created by Alex on 3/8/2018.
 */

public class RestClient {
    
    private static Api api;

    public static Api getApi() {

        if (api == null) {
            Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
                    .create();

            Interceptor restInterceptor = new PrivacySettingsInterceptor();
            OkHttpClient okHttpClient = new OkHttpClient.Builder()
                    .addInterceptor(restInterceptor)
                    .build();

            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(SWARMS_URL_DEBUG_RAFAEL)
//                    .client(okHttpClient)
                    .addConverterFactory(GsonConverterFactory.create(gson))
                    .build();
            api = retrofit.create(Api.class);
        }
        return api;

    }
}