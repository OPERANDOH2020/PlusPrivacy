package eu.operando.adblock;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ContextMenu;
import android.view.MenuItem;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by Edy on 08-May-17.
 */

public class AdBlockWebView extends WebView {
    private OnPageFinishedListener onPageFinishedListener;
    private OnLongPressListener onLongPressListener;
    public void setOnPageFinishedListener(OnPageFinishedListener listener){
        this.onPageFinishedListener = listener;
    }

    public void setOnLongPressListener(OnLongPressListener onLongPressListener) {
        this.onLongPressListener = onLongPressListener;
    }

    public AdBlockWebView(Context context){
        super(context);
        init();
    }

    public AdBlockWebView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        getSettings().setJavaScriptEnabled(true);
        setWebChromeClient(new WebChromeClient());
        setWebViewClient(getWebViewClient());
        getSettings().setBuiltInZoomControls(true);
        getSettings().setUseWideViewPort(true);
        getSettings().setDomStorageEnabled(true);
        getSettings().setLoadWithOverviewMode(true);
    }

    private WebViewClient getWebViewClient() {
        return new AdBlockClient(getContext()) {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (onPageFinishedListener != null)
                    onPageFinishedListener.onPageFinished(url);
            }
        };
    }

    public interface OnPageFinishedListener {
        void onPageFinished(String url);
    }

    @Override
    protected void onCreateContextMenu(ContextMenu menu) {
        super.onCreateContextMenu(menu);
        final HitTestResult result = getHitTestResult();

        MenuItem.OnMenuItemClickListener handler = new MenuItem.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem menuItem) {
                if(onLongPressListener!=null){
                    onLongPressListener.onLongPress(result.getExtra());
                }
                return true;
            }
        };

        if(result.getType() == HitTestResult.ANCHOR_TYPE || result.getType() == HitTestResult.SRC_ANCHOR_TYPE){
            menu.add("Open in new tab").setOnMenuItemClickListener(handler);
        }
    }
    public interface OnLongPressListener{
        void onLongPress(String url);
    }
}
