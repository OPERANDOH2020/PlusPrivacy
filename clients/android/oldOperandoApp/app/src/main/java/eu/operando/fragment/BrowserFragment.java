package eu.operando.fragment;

import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.activity.AbstractLeftMenuActivity;
import eu.operando.util.OnBackPressedListener;
import im.delight.android.webview.AdvancedWebView;

/**
 * Created by Edy on 6/16/2016.
 */
public class BrowserFragment extends Fragment implements AdvancedWebView.Listener, OnBackPressedListener {
    private View rootView;
    private AdvancedWebView webView;
    private EditText urlET;
    private View goButton;
    private ProgressDialog progressDialog;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_browser, container, false);
        initUI();
        setListeners();
        getActivity().setTitle("Private browsing");
        ((AbstractLeftMenuActivity)getActivity()).setOnBackPressedListener(this);
        return rootView;
    }

    private void initUI() {
        progressDialog = new ProgressDialog(getActivity());
        progressDialog.setCancelable(false);
        progressDialog.setTitle("Please wait");
        webView = ((AdvancedWebView) rootView.findViewById(R.id.webview));
        webView.setListener(getActivity(), this);
        urlET = ((EditText) rootView.findViewById(R.id.url));
        goButton = rootView.findViewById(R.id.go_button);
    }

    private void hideKeyboard(){
        View view = rootView;
        if (view != null) {
            InputMethodManager imm = (InputMethodManager)getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    private void setListeners() {
        urlET.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_GO) {
                    go();
                    return true;
                }
                return false;
            }
        });
        goButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                go();
            }
        });
    }

    private void go() {
        webView.loadUrl(getURL());
        hideKeyboard();
    }

    private String getURL() {
        String st = urlET.getText().toString();
        if (!st.startsWith("http://") || !st.startsWith("https://")) {
            st = "http://" + (st.isEmpty() ? " " : st);
        }
        return st;
    }

    @Override
    public void onResume() {
        super.onResume();
        webView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        webView.onPause();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        webView.onDestroy();
    }

    @Override
    public void onPageStarted(String url, Bitmap favicon) {
        showLoading();
    }

    @Override
    public void onPageFinished(String url) {
        hideLoading();
    }

    private void showLoading() {
        progressDialog.show();
    }

    private void hideLoading() {
        progressDialog.dismiss();
    }

    @Override
    public void onPageError(int errorCode, String description, String failingUrl) {
        progressDialog.dismiss();
    }

    @Override
    public void onDownloadRequested(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {

    }

    @Override
    public void onExternalPageRequest(String url) {

    }

    @Override
    public boolean onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
            return true;
        }
        return false;

    }


}
