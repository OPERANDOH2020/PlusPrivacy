package eu.operando.lightning.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.Menu;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;

import com.anthonycr.bonsai.Completable;
import com.anthonycr.bonsai.CompletableAction;
import com.anthonycr.bonsai.CompletableSubscriber;

import eu.operando.R;

@SuppressWarnings("deprecation")
public class MainBrowserActivity extends BrowserActivity {

    public static void start(Context context) {
        Intent starter = new Intent(context, MainBrowserActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    @NonNull
    @Override
    public Completable updateCookiePreference() {
        return Completable.create(new CompletableAction() {
            @Override
            public void onSubscribe(@NonNull CompletableSubscriber subscriber) {
                CookieManager cookieManager = CookieManager.getInstance();
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                    CookieSyncManager.createInstance(MainBrowserActivity.this);
                }
                cookieManager.setAcceptCookie(mPreferences.getCookiesEnabled());
                subscriber.onComplete();
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(@NonNull Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        if (isPanicTrigger(intent)) {
            panicClean();
        } else {
            handleNewIntent(intent);
            super.onNewIntent(intent);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        saveOpenTabs();
    }

    @Override
    public void updateHistory(@Nullable String title, @NonNull String url) {
        addItemToHistory(title, url);
    }

    @Override
    public boolean isIncognito() {
        return false;
    }

    @Override
    public void closeActivity() {
        closeDrawers(new Runnable() {
            @Override
            public void run() {
                performExitCleanUp();
//                moveTaskToBack(true);
                finish();
            }
        });
    }
}
