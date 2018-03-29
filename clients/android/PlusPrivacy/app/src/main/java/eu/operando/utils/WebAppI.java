package eu.operando.utils;

import android.util.Log;
import android.webkit.JavascriptInterface;

/**
 * Created by Alex on 3/29/2018.
 */

public abstract class WebAppI {

    private int isJQueryLoaded;

    @JavascriptInterface
    public abstract void showToast(String message);

    @JavascriptInterface
    public void isLoaded(int jquery) {
        Log.e("WebAppI isLoaded", String.valueOf(jquery));
        isJQueryLoaded = jquery;
    }

    public int getIsJQueryLoaded() {
        return isJQueryLoaded;
    }
}
