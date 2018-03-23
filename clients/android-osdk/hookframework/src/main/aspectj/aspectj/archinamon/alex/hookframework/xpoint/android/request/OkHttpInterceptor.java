package aspectj.archinamon.alex.hookframework.xpoint.android.request;

import android.os.AsyncTask;
import android.util.Log;

import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;

/**
 * Created by Matei_Alexandru on 11.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class OkHttpInterceptor extends AsyncTask<String, Void, String> {
    @Override
    protected String doInBackground(String... params) {
        OkHttpClient client = new OkHttpClient();
        client.networkInterceptors().add(new LoggingInterceptor());
        Request request = new Request.Builder()
                .url("http://www.publicobject.com/helloworld.txt")
                .header("User-Agent", "OkHttp Example")
                .build();

        Response response = null;
        String result;
        try {
            response = client.newCall(request).execute();
            Log.e("OkHttpInterceptor", String.valueOf(response.body().bytes()));
            response.body().close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
