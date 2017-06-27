package eu.operando.adblock;

import android.content.Context;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.adblockplus.libadblockplus.FilterEngine;
import org.adblockplus.libadblockplus.android.AdblockEngine;

import java.io.ByteArrayInputStream;
import java.util.regex.Pattern;

/**
 * Created by Edy on 08-May-17.
 */

public class AdBlockClient extends WebViewClient {
    public AdBlockClient(Context context) {
        this.context = context;
        engine = getAdblockEngine();
    }
    private static final Pattern RE_JS = Pattern.compile("\\.js$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_CSS = Pattern.compile("\\.css$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_IMAGE = Pattern.compile("\\.(?:gif|png|jpe?g|bmp|ico)$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_FONT = Pattern.compile("\\.(?:ttf|woff)$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_HTML = Pattern.compile("\\.html?$", Pattern.CASE_INSENSITIVE);
    private ByteArrayInputStream emptyBAIS = new ByteArrayInputStream("".getBytes());
    private WebResourceResponse blocked = new WebResourceResponse("text/plain", "utf-8", emptyBAIS);
    private AdblockEngine engine;
    private String[] EMPTY_ARRAY = {};
    private Context context;



    private AdblockEngine getAdblockEngine() {
        return AdblockEngine
                .builder(
                        AdblockEngine.generateAppInfo(context, false),
                        context.getDir(AdblockEngine.BASE_PATH_DIRECTORY, Context.MODE_PRIVATE).getAbsolutePath())
                .enableElementHiding(true)
                .build();
    }

    private boolean isAd(String url) {
        FilterEngine.ContentType contentType;
        if (RE_JS.matcher(url).find()) {
            contentType = FilterEngine.ContentType.SCRIPT;
        } else if (RE_CSS.matcher(url).find()) {
            contentType = FilterEngine.ContentType.STYLESHEET;
        } else if (RE_IMAGE.matcher(url).find()) {
            contentType = FilterEngine.ContentType.IMAGE;
        } else if (RE_FONT.matcher(url).find()) {
            contentType = FilterEngine.ContentType.FONT;
        } else if (RE_HTML.matcher(url).find()) {
            contentType = FilterEngine.ContentType.SUBDOCUMENT;
        } else {
            contentType = FilterEngine.ContentType.OTHER;
        }

        return (engine.matches(url, contentType, EMPTY_ARRAY));
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        if (isAd(request.getUrl().toString())) {
            return blocked;
        }
        return super.shouldInterceptRequest(view, request);
    }

    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        if (isAd(url)) {
            return blocked;
        }
        return super.shouldInterceptRequest(view, url);
    }
}
