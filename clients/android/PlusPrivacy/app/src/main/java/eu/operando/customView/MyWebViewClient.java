package eu.operando.customView;

import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.util.Map;

/**
 * Created by Alex on 3/1/2018.
 */


public class MyWebViewClient extends WebViewClient {

    protected SocialNetworkInterface socialNetworkInterface;

    public MyWebViewClient(SocialNetworkInterface socialNetworkInterface) {
        this.socialNetworkInterface = socialNetworkInterface;
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        socialNetworkInterface.onPageListener();
    }

    @Override
    public void onPageCommitVisible(WebView view, String url) {
        super.onPageCommitVisible(view, url);
        socialNetworkInterface.onPageListener();
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        Log.e("requestHTTP", request.getMethod() + " " + request.getUrl());
        Map<String, String> headers = request.getRequestHeaders();
        for (Map.Entry<String, String> entry : headers.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            Log.e("{HEADER Aos}" + key, value);
        }

        return super.shouldInterceptRequest(view, request);
    }

    public interface SocialNetworkInterface{
        void onPageListener();
    }
}

