package eu.operando.activity;

import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import eu.operando.R;

/**
 * Created by Edy on 15-May-17.
 */

public class BaseActivity extends AppCompatActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onResume() {
        super.onResume();
        try {
            CharSequence label;
            if (getIntent().getExtras() != null && !TextUtils.isEmpty(getIntent().getExtras().getString("title"))) {
                label = getIntent().getExtras().getString("title");
            } else {
                label = (getPackageManager().getActivityInfo(getComponentName(), 0).nonLocalizedLabel);
            }
            if (!TextUtils.isEmpty(label)) {
                ((TextView) findViewById(R.id.title)).setText(label);
            }
        } catch (Exception ignored) {
        }
    }
}
