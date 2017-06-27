package eu.operando;

import android.app.Application;

import org.adblockplus.libadblockplus.android.AdblockEngine;

import io.paperdb.Paper;

/**
 * Created by Edy on 11/25/2016.
 */

public class App extends Application {
    private static App app;
    @Override
    public void onCreate() {
        super.onCreate();
        app = this;

    }

    public static App getApp(){
        return app;
    }
}
