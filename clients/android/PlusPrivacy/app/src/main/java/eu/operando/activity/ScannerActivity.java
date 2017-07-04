package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;

import java.util.HashMap;
import java.util.HashSet;

import eu.operando.BuildConfig;
import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.models.InstalledApp;
import eu.operando.storage.Storage;
import eu.operando.utils.PermissionUtils;

public class ScannerActivity extends BaseActivity {
    private ListView listView;
    private boolean shouldRefresh = true;
    private HashSet<String> unknownPerms;

    public static void start(Context context) {
        Intent starter = new Intent(context, ScannerActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.fade_in, R.anim.fade_out);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scanner);
        initUI();
    }

    private void initUI() {
        listView = (ListView) findViewById(R.id.app_list_view);
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        ScannerListAdapter adapter = new ScannerListAdapter(this, Storage.readAppList());
        unknownPerms = new HashSet<>();
        if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean("once",true)&& BuildConfig.DEBUG) {
            for (InstalledApp app : Storage.readAppList()) {
                if (app.getPermissions() == null) continue;
                for (String permission : app.getPermissions()) {
                    String[] splitted = permission.split("\\.");
                    String simplifiedPermission = splitted[splitted.length - 1];
                    if (PermissionUtils.getPermissionDescription(simplifiedPermission).isEmpty()) {
                        unknownPerms.add(simplifiedPermission);
                    }
                }
            }
            sendEmail();
            PreferenceManager.getDefaultSharedPreferences(this).edit().putBoolean("once",false).apply();
        }

        listView.setAdapter(adapter);
    }

    private void sendEmail() {
        String body = "";
        for (String perm : unknownPerms) {
            body += perm + "\n";
        }
        Intent emailIntent = new Intent(Intent.ACTION_SEND);
        emailIntent.putExtra(Intent.EXTRA_SUBJECT, "Permissions");
        emailIntent.putExtra(Intent.EXTRA_TEXT, body);

        try {
            startActivity(Intent.createChooser(emailIntent, "Send email using..."));
        } catch (android.content.ActivityNotFoundException ignored) {
        }

    }

    @Override
    protected void onResume() {
        super.onResume();
        if (shouldRefresh) {
            reloadApps();
        } else {
            shouldRefresh = true;
        }
    }

    private void reloadApps() {
        Storage.saveAppList(PermissionUtils.getApps(this, false));
        initUI();
    }

    @Override
    public void onBackPressed() {
        finish();
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    public void infoClicked() {
        shouldRefresh = false;
    }
}
