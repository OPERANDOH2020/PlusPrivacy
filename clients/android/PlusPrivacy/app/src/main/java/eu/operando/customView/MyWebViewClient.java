package eu.operando.customView;

import android.graphics.Bitmap;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.util.Map;

/**
 * Created by Alex on 3/1/2018.
 */


public class MyWebViewClient extends WebViewClient {

    private boolean loadingFinished = true;
    private boolean redirect = false;

    protected SocialNetworkInterface socialNetworkInterface;

    public MyWebViewClient(SocialNetworkInterface socialNetworkInterface) {
        this.socialNetworkInterface = socialNetworkInterface;
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String urlNewString) {
        if (!loadingFinished) {
            redirect = true;
        }

        loadingFinished = false;
        view.loadUrl(urlNewString);
        return true;
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap facIcon) {
        loadingFinished = false;
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);

        if (!redirect) {
            loadingFinished = true;
        }

        if (loadingFinished && !redirect) {
            socialNetworkInterface.onPageFinished();
        } else {
            redirect = false;
        }
    }

    @Override
    public void onPageCommitVisible(WebView view, String url) {
        super.onPageCommitVisible(view, url);
        socialNetworkInterface.onPageCommitVisible();
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

        String cookies = CookieManager.getInstance().getCookie(request.getUrl().toString());
        Log.d("Cookie", "[" + request.getUrl().toString() + "] All the cookies in a string:" + cookies);

        return super.shouldInterceptRequest(view, request);
    }

    public interface SocialNetworkInterface {
        void onPageCommitVisible();

        void onPageFinished();
    }
}

