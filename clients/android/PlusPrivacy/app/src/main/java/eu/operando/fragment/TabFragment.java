package eu.operando.fragment;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import org.jetbrains.annotations.NotNull;

import java.net.URLEncoder;

import eu.operando.R;
import eu.operando.adblock.AdBlockWebView;

/**
 * Created by Edy on 31-Mar-17.
 */

public class TabFragment extends Fragment {
    public static TabFragment newInstance(@Nullable String url) {

        Bundle args = new Bundle();
        args.putString("url", url);
        TabFragment fragment = new TabFragment();
        fragment.setArguments(args);
        return fragment;
    }

    private ImageView goBtn;
    private ImageView backBtn;
    private AdBlockWebView webView;
    private EditText urlEt;
    private OnNewTabRequestListener onNewTabRequestListener;
    private UrlLoadListener urlLoadListener;

    public void setUrlLoadListener(UrlLoadListener urlLoadListener) {
        this.urlLoadListener = urlLoadListener;
    }

    public void setOnNewTabRequestListener(OnNewTabRequestListener onNewTabRequestListener) {
        this.onNewTabRequestListener = onNewTabRequestListener;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View rootView = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_browser_tab, container, false);
        initUI(rootView);
        return rootView;
    }

    public void loadUrl(String url) {
        urlEt.setText(url);
        go();
    }

    private void initUI(View rootView) {

        goBtn = ((ImageView) rootView.findViewById(R.id.btn_go));
        backBtn = ((ImageView) rootView.findViewById(R.id.btn_back));
        urlEt = ((EditText) rootView.findViewById(R.id.urlET));
        initWebView(rootView);
        initAddressBar();

    }

    private void initAddressBar() {
        urlEt.setSelectAllOnFocus(true);
        urlEt.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_GO) {
                    go();
                    return true;
                }
                return false;
            }
        });

        goBtn.setColorFilter(getResources().getColor(R.color.colorAccent));
        goBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                go();
            }
        });

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                goBack();
            }
        });
    }

    private void initWebView(View rootView) {
        webView = (AdBlockWebView) rootView.findViewById(R.id.webView);
        webView.setOnPageFinishedListener(new AdBlockWebView.OnPageFinishedListener() {
            @Override
            public void onPageFinished(String url) {
                urlEt.setText(url);
                urlEt.clearFocus();
                hideKeyboard();
                if (urlLoadListener != null) {
                    urlLoadListener.onUrlLoaded(webView.getTitle(),url);
                }
                Bundle b = new Bundle();
                b.putString("url",url);
            }
        });
        loadUrl(getArguments().getString("url", "assets.www.google.ro"));
        webView.setOnLongPressListener(new AdBlockWebView.OnLongPressListener() {
            @Override
            public void onLongPress(String url) {
                if(onNewTabRequestListener!=null){
                    onNewTabRequestListener.onNewTabRequested(url);
                }
            }
        });

    }



    private void goBack() {
        onBackPressed();
    }

    private void go() {
        String url = urlEt.getText().toString();
        if (!android.util.Patterns.WEB_URL.matcher(url).matches()) {
//            url = "http://assets.www.google.com/search?q=" + URLEncoder.encode(url);
            url = "http://www.google.com/search?q=" + URLEncoder.encode(url);
        }
        url = url.toLowerCase().startsWith("http://") || url.toLowerCase().startsWith("https://") ? url : ("http://" + url);
        webView.loadUrl(url);
        Log.e("url", url);
    }


    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            getActivity().finish();
        }
    }

    private void hideKeyboard() {
        View view = getActivity() != null ? getActivity().getCurrentFocus() : null;
        if (view != null) {
            InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    @NotNull
    public String getUrl() {
        return urlEt.getText().toString();
    }

    public interface UrlLoadListener {
        void onUrlLoaded(String title, String url);
    }

    public interface OnNewTabRequestListener{
        void onNewTabRequested(String url);
    }
}
