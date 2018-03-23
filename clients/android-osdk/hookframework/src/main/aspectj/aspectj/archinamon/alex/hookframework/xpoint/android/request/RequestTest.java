package aspectj.archinamon.alex.hookframework.xpoint.android.request;
import android.content.Context;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

/**
 * Created by Matei_Alexandru on 08.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class RequestTest {

    private TextView mTextView;
    private Context context;

    public RequestTest(Context context) {
        this.context = context;
//        mTextView = (TextView) ((Activity)context).findViewById(R.id.speechto_text_result_tv);
    }

    public void run(){
        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(context);
        String url ="https://swapi.co/api/people/1";

        // Request a string response from the provided URL.
        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.GET, url, null, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
//                        mTextView.setText("Response: " + response.toString());
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        // TODO Auto-generated method stub

                    }
                });
        // Add the request to the RequestQueue.
        queue.add(jsObjRequest);
    }
}
