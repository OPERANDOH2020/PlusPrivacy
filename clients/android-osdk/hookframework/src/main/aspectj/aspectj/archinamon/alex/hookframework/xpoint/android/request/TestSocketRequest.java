package aspectj.archinamon.alex.hookframework.xpoint.android.request;

import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;

/**
 * Created by Matei_Alexandru on 09.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class TestSocketRequest extends AsyncTask<String, String, String> {
    @Override
    protected String doInBackground(String... params) {
        Socket s = null;
        StringBuilder result = new StringBuilder();
        try {

            s = new Socket(InetAddress.getByName("www.google.com"), 80);
            PrintWriter pw = new PrintWriter(s.getOutputStream());
            pw.println("GET / HTTP/1.1\r\n");
            pw.println("Host: www.google.com\r\n");

            pw.flush();
            BufferedReader br = new BufferedReader(new InputStreamReader(s.getInputStream()));


            String line;
            while ((line = br.readLine()) != null) {
//                Log.e("line content", line);
//                Log.e("result content", result.toString());
                result.append(line);
            }
            br.close();
            s.close();

        } catch (IOException e) {
            Log.e("result content", "null");
            e.printStackTrace();
        }
        Log.e("result content", result.toString());
        return result.toString();
    }

    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        //Do anything with response..
    }

    @Override
    protected void onCancelled() {
        super.onCancelled();

    }

    @Override
    protected void onCancelled(String s) {
        super.onCancelled(s);
        Log.e("onCancelled", "s" + s);
    }
}
