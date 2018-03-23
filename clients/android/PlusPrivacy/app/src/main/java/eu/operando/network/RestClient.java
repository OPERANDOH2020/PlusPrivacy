package eu.operando.network;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;


import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import static eu.operando.swarmService.SwarmService.SWARMS_URL_DEBUG_RAFAEL_2;

/**
 * Created by Alex on 3/8/2018.
 */

public class RestClient {

    private static Api api;

    public static Api getApi() {


        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return new java.security.cert.X509Certificate[] {};
            }

            public void checkClientTrusted(X509Certificate[] chain,
                                           String authType) throws CertificateException {
            }

            public void checkServerTrusted(X509Certificate[] chain,
                                           String authType) throws CertificateException {
            }
        } };

        OkHttpClient okHttpClient = null;
        try {
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());

            okHttpClient = new OkHttpClient.Builder()
                    .sslSocketFactory(sc.getSocketFactory())
                    .build();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (api == null) {
            Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
                    .create();

//            Interceptor restInterceptor = new PrivacySettingsInterceptor();
//            OkHttpClient okHttpClient = new OkHttpClient.Builder()
//                    .addInterceptor(restInterceptor)
//                    .build();

            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(SWARMS_URL_DEBUG_RAFAEL_2)
                    .client(okHttpClient)
                    .addConverterFactory(GsonConverterFactory.create(gson))
                    .build();
            api = retrofit.create(Api.class);
        }
        return api;

    }
}