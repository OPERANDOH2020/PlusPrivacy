package aspectj.archinamon.alex.hookframework.xpoint.android.request;

import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by Matei_Alexandru on 09.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class TestUrlConnection extends AsyncTask<String, String, String> {

    @Override
    protected String doInBackground(String... uri) {
        URL url = null;
        StringBuilder result = new StringBuilder();
        try {
            url = new URL("https://www.google.com/");
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            try {
                InputStream in = new BufferedInputStream(urlConnection.getInputStream());
                BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                String line;
                result = new StringBuilder();
                while ((line = reader.readLine()) != null) {
                    result.append(line);
                }

            } finally {
                urlConnection.disconnect();
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Log.e("TestHttpClient", result.toString());
        return result.toString();
    }

    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        //Do anything with response..
    }
}
