package aspectj.archinamon.alex.hookframework.xpoint.android.request;

import android.util.Log;

import com.squareup.okhttp.Callback;
import com.squareup.okhttp.FormEncodingBuilder;
import com.squareup.okhttp.Headers;
import com.squareup.okhttp.MultipartBuilder;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

/**
 * Created by Matei_Alexandru on 09.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class TestOkHttpClient {
    private final OkHttpClient client = new OkHttpClient();

    public void run() throws Exception {
        Log.e("TestOkHttpClient1", "TestOkHttpClient");
        RequestBody requestBody = new MultipartBuilder()
                .type(MultipartBuilder.FORM)
                .addFormDataPart("someParam", "51.498134, -0.201755")
                .addFormDataPart("bla", "blabla")
                .build();
        Request request = new Request.Builder()
                .url("http://httpbin.org/post")
                .post(requestBody)
                .build();
        client.setConnectTimeout(15, TimeUnit.SECONDS);
        Log.e("TestOkHttpClient2", "TestOkHttpClient");
        client.newCall(request).enqueue(new Callback() {

            @Override
            public void onFailure(Request request, IOException e) {
                e.printStackTrace();
            }

            @Override
            public void onResponse(Response response) throws IOException {
                if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);

                Headers responseHeaders = response.headers();
                for (int i = 0, size = responseHeaders.size(); i < size; i++) {
                    Log.e(responseHeaders.name(i), responseHeaders.value(i));
                }
                Log.e("response", response.body().string());
            }
        });
    }
}
