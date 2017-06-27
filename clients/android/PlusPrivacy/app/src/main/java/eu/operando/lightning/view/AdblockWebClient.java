package eu.operando.lightning.view;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.MailTo;
import android.net.http.SslError;
import android.os.Build;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AlertDialog;
import android.text.InputType;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.webkit.HttpAuthHandler;
import android.webkit.SslErrorHandler;
import android.webkit.ValueCallback;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.LinearLayout;

import org.adblockplus.libadblockplus.FilterEngine;
import org.adblockplus.libadblockplus.android.AdblockEngine;

import java.io.ByteArrayInputStream;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.inject.Inject;

import eu.operando.R;
import eu.operando.BrowserApp;
import eu.operando.lightning.constant.Constants;
import eu.operando.lightning.controller.UIController;
import eu.operando.lightning.dialog.BrowserDialog;
import eu.operando.lightning.utils.AdBlock;
import eu.operando.lightning.utils.IntentUtils;
import eu.operando.lightning.utils.Preconditions;
import eu.operando.lightning.utils.Utils;

public class AdblockWebClient extends WebViewClient {
    private static final Pattern RE_JS = Pattern.compile("\\.js$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_CSS = Pattern.compile("\\.css$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_IMAGE = Pattern.compile("\\.(?:gif|png|jpe?g|bmp|ico)$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_FONT = Pattern.compile("\\.(?:ttf|woff)$", Pattern.CASE_INSENSITIVE);
    private static final Pattern RE_HTML = Pattern.compile("\\.html?$", Pattern.CASE_INSENSITIVE);
    private ByteArrayInputStream emptyBAIS = new ByteArrayInputStream("".getBytes());
    private WebResourceResponse blocked = new WebResourceResponse("text/plain", "utf-8", emptyBAIS);
    private AdblockEngine engine;
    private String[] EMPTY_ARRAY = {};
    private boolean mBlockAds;



    private AdblockEngine getAdblockEngine() {
        return AdblockEngine
                .builder(
                        AdblockEngine.generateAppInfo(mActivity, false),
                        mActivity.getDir(AdblockEngine.BASE_PATH_DIRECTORY, Context.MODE_PRIVATE).getAbsolutePath())
                .enableElementHiding(true)
                .build();
    }

    private boolean isAd(String url) {
        if (!mBlockAds || url == null) {
            return false;
        }

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
    private static final String TAG = "AdblockWebClient";

    @NonNull private final Activity mActivity;
    @NonNull private final LightningView mLightningView;
    @NonNull private final UIController mUIController;
    @NonNull private final IntentUtils mIntentUtils;

    @Inject AdBlock mAdBlock;

    AdblockWebClient(@NonNull Activity activity, @NonNull LightningView lightningView, boolean blockAds) {
        BrowserApp.getAppComponent().inject(this);
        Preconditions.checkNonNull(activity);
        Preconditions.checkNonNull(lightningView);
        mActivity = activity;
        mUIController = (UIController) activity;
        mLightningView = lightningView;
        mAdBlock.updatePreference();
        mIntentUtils = new IntentUtils(activity);
        engine = getAdblockEngine();
        this.mBlockAds = blockAds;
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, @NonNull WebResourceRequest request) {
        if (isAd(request.getUrl().toString())) {
            return blocked;
        }
        return super.shouldInterceptRequest(view, request);
    }

    @Nullable
    @SuppressWarnings("deprecation")
    @TargetApi(Build.VERSION_CODES.KITKAT_WATCH)
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        if (isAd(url)) {
            return blocked;
        }
        return super.shouldInterceptRequest(view, url);
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public void onPageFinished(@NonNull WebView view, String url) {
        if (view.isShown()) {
            mUIController.updateUrl(url, true);
            mUIController.setBackButtonEnabled(view.canGoBack());
            mUIController.setForwardButtonEnabled(view.canGoForward());
            view.postInvalidate();
        }
        if (view.getTitle() == null || view.getTitle().isEmpty()) {
            mLightningView.getTitleInfo().setTitle(mActivity.getString(R.string.untitled));
        } else {
            mLightningView.getTitleInfo().setTitle(view.getTitle());
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT &&
            mLightningView.getInvertePage()) {
            view.evaluateJavascript(Constants.JAVASCRIPT_INVERT_PAGE, null);
        }
        mUIController.tabChanged(mLightningView);
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        mLightningView.getTitleInfo().setFavicon(null);
        if (mLightningView.isShown()) {
            mUIController.updateUrl(url, false);
            mUIController.showActionBar();
        }
        mUIController.tabChanged(mLightningView);
    }

    @Override
    public void onReceivedHttpAuthRequest(final WebView view, @NonNull final HttpAuthHandler handler,
                                          final String host, final String realm) {

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        final EditText name = new EditText(mActivity);
        final EditText password = new EditText(mActivity);
        LinearLayout passLayout = new LinearLayout(mActivity);
        passLayout.setOrientation(LinearLayout.VERTICAL);

        passLayout.addView(name);
        passLayout.addView(password);

        name.setHint(mActivity.getString(R.string.hint_username));
        name.setSingleLine();
        password.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD);
        password.setSingleLine();
        password.setTransformationMethod(new PasswordTransformationMethod());
        password.setHint(mActivity.getString(R.string.hint_password));
        builder.setTitle(mActivity.getString(R.string.title_sign_in));
        builder.setView(passLayout);
        builder.setCancelable(true)
            .setPositiveButton(mActivity.getString(R.string.title_sign_in),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        String user = name.getText().toString();
                        String pass = password.getText().toString();
                        handler.proceed(user.trim(), pass.trim());
                        Log.d(TAG, "Request Login");

                    }
                })
            .setNegativeButton(mActivity.getString(R.string.action_cancel),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        handler.cancel();
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
        BrowserDialog.setDialogSize(mActivity, alert);
    }

    private volatile boolean mIsRunning = false;
    private float mZoomScale = 0.0f;

    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public void onScaleChanged(@NonNull final WebView view, final float oldScale, final float newScale) {
        if (view.isShown() && mLightningView.mPreferences.getTextReflowEnabled() &&
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (mIsRunning)
                return;
            float changeInPercent = Math.abs(100 - 100 / mZoomScale * newScale);
            if (changeInPercent > 2.5f && !mIsRunning) {
                mIsRunning = view.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        mZoomScale = newScale;
                        view.evaluateJavascript(Constants.JAVASCRIPT_TEXT_REFLOW, new ValueCallback<String>() {
                            @Override
                            public void onReceiveValue(String value) {
                                mIsRunning = false;
                            }
                        });
                    }
                }, 100);
            }

        }
    }

    @NonNull
    private static List<Integer> getAllSslErrorMessageCodes(@NonNull SslError error) {
        List<Integer> errorCodeMessageCodes = new ArrayList<>(1);

        if (error.hasError(SslError.SSL_DATE_INVALID)) {
            errorCodeMessageCodes.add(R.string.message_certificate_date_invalid);
        }
        if (error.hasError(SslError.SSL_EXPIRED)) {
            errorCodeMessageCodes.add(R.string.message_certificate_expired);
        }
        if (error.hasError(SslError.SSL_IDMISMATCH)) {
            errorCodeMessageCodes.add(R.string.message_certificate_domain_mismatch);
        }
        if (error.hasError(SslError.SSL_NOTYETVALID)) {
            errorCodeMessageCodes.add(R.string.message_certificate_not_yet_valid);
        }
        if (error.hasError(SslError.SSL_UNTRUSTED)) {
            errorCodeMessageCodes.add(R.string.message_certificate_untrusted);
        }
        if (error.hasError(SslError.SSL_INVALID)) {
            errorCodeMessageCodes.add(R.string.message_certificate_invalid);
        }

        return errorCodeMessageCodes;
    }

    @Override
    public void onReceivedSslError(WebView view, @NonNull final SslErrorHandler handler, @NonNull SslError error) {
        List<Integer> errorCodeMessageCodes = getAllSslErrorMessageCodes(error);

        StringBuilder stringBuilder = new StringBuilder();
        for (Integer messageCode : errorCodeMessageCodes) {
            stringBuilder.append(" - ").append(mActivity.getString(messageCode)).append('\n');
        }
        String alertMessage =
            mActivity.getString(R.string.message_insecure_connection, stringBuilder.toString());

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        builder.setTitle(mActivity.getString(R.string.title_warning));
        builder.setMessage(alertMessage)
            .setCancelable(true)
            .setPositiveButton(mActivity.getString(R.string.action_yes),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        handler.proceed();
                    }
                })
            .setNegativeButton(mActivity.getString(R.string.action_no),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        handler.cancel();
                    }
                });
        Dialog dialog = builder.show();
        BrowserDialog.setDialogSize(mActivity, dialog);
    }

    @Override
    public void onFormResubmission(WebView view, @NonNull final Message dontResend, @NonNull final Message resend) {
        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        builder.setTitle(mActivity.getString(R.string.title_form_resubmission));
        builder.setMessage(mActivity.getString(R.string.message_form_resubmission))
            .setCancelable(true)
            .setPositiveButton(mActivity.getString(R.string.action_yes),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        resend.sendToTarget();
                    }
                })
            .setNegativeButton(mActivity.getString(R.string.action_no),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        dontResend.sendToTarget();
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
        BrowserDialog.setDialogSize(mActivity, alert);
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public boolean shouldOverrideUrlLoading(@NonNull WebView view, @NonNull WebResourceRequest request) {
        return shouldOverrideLoading(view, request.getUrl().toString()) || super.shouldOverrideUrlLoading(view, request);
    }

    @SuppressWarnings("deprecation")
    @Override
    public boolean shouldOverrideUrlLoading(@NonNull WebView view, @NonNull String url) {
        return shouldOverrideLoading(view, url) || super.shouldOverrideUrlLoading(view, url);
    }

    private boolean shouldOverrideLoading(@NonNull WebView view, @NonNull String url) {
        // Check if configured proxy is available

        Map<String, String> headers = mLightningView.getRequestHeaders();

        if (mLightningView.isIncognito()) {
            // If we are in incognito, immediately load, we don't want the url to leave the app
            return continueLoadingUrl(view, url, headers);
        }
        if (url.startsWith(Constants.ABOUT)) {
            // If this is an about page, immediately load, we don't need to leave the app
            return continueLoadingUrl(view, url, headers);
        }

        if (isMailOrIntent(url, view) || mIntentUtils.startActivityForUrl(view, url)) {
            // If it was a mailto: link, or an intent, or could be launched elsewhere, do that
            return true;
        }

        // If none of the special conditions was met, continue with loading the url
        return continueLoadingUrl(view, url, headers);
    }

    private boolean continueLoadingUrl(@NonNull WebView webView,
                                       @NonNull String url,
                                       @NonNull Map<String, String> headers) {
        if (headers.isEmpty()) {
            return false;
        } else if (Utils.doesSupportHeaders()) {
            webView.loadUrl(url, headers);
            return true;
        } else {
            return false;
        }
    }

    private boolean isMailOrIntent(@NonNull String url, @NonNull WebView view) {
        if (url.startsWith("mailto:")) {
            MailTo mailTo = MailTo.parse(url);
            Intent i = Utils.newEmailIntent(mailTo.getTo(), mailTo.getSubject(),
                mailTo.getBody(), mailTo.getCc());
            mActivity.startActivity(i);
            view.reload();
            return true;
        } else if (url.startsWith("intent://")) {
            Intent intent;
            try {
                intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
            } catch (URISyntaxException ignored) {
                intent = null;
            }
            if (intent != null) {
                intent.addCategory(Intent.CATEGORY_BROWSABLE);
                intent.setComponent(null);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH_MR1) {
                    intent.setSelector(null);
                }
                try {
                    mActivity.startActivity(intent);
                } catch (ActivityNotFoundException e) {
                    Log.e(TAG, "ActivityNotFoundException");
                }
                return true;
            }
        }
        return false;
    }
}
