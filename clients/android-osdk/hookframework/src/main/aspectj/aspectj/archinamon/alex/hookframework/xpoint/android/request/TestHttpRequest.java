package aspectj.archinamon.alex.hookframework.xpoint.android.request;

import android.os.AsyncTask;
import android.util.Log;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Scanner;

/**
 * Created by Matei_Alexandru on 09.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class TestHttpRequest extends AsyncTask<String, String, String> {
    @Override
    protected String doInBackground(String... params) {
        URL url = null;
        Scanner scan = null;
        String content = null;

        try {
            url = new URL("https://www.google.com");
            scan = new Scanner(url.openStream());
            content = new String();
            while (scan.hasNext())
                content += scan.nextLine();

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally{
            scan.close();
        }

        Log.e("request content", content);
        return content;
    }

    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        //Do anything with response..
    }
}
