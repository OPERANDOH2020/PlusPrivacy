package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;

import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.storage.Storage;
import eu.operando.utils.PermissionUtils;

public class ScannerActivity extends BaseActivity {
    private ListView listView;
    private boolean shouldRefresh = true;

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
        listView.setAdapter(adapter);
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
