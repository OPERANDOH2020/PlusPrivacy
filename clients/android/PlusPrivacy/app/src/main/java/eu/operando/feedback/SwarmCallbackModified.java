package eu.operando.feedback;

import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONObject;

import java.lang.reflect.ParameterizedType;

import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Matei_Alexandru on 27.09.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public abstract class SwarmCallbackModified<T> extends SwarmCallback {
    private Class<? extends T> type;

    public void result(JSONObject result) {
        this.type = (Class<T>)((ParameterizedType)getClass().getGenericSuperclass()).getActualTypeArguments()[0];
        Log.e("swclient Swarms: ", "result: " + result.toString() );
        T t = new Gson().fromJson(result.toString(),type);
        call((Swarm) t);
    }
}