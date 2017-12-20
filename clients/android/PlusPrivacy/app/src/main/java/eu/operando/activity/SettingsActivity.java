package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.lightning.fragment.PrivacySettingsFragment;

public class SettingsActivity extends AppCompatActivity {
//    @Inject PreferenceManager prefManager;

    public static void start(Context context) {
        Intent starter = new Intent(context, SettingsActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        setToolbar();
//        BrowserApp.getAppComponent().inject(this);
//        ((CheckBox) findViewById(R.id.cb_block_ads)).setChecked(prefManager.getAdBlockEnabled());
//        ((CheckBox) findViewById(R.id.cb_block_ads)).setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
//            @Override
//            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
//                prefManager.setAdBlockEnabled(b);
//            }
//        });
//
//        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                onBackPressed();
//            }
//        });
        getFragmentManager().beginTransaction().replace(R.id.content,new PrivacySettingsFragment()).commit();
    }

    @Override
    protected void onResume() {
        super.onResume();
        try {
            CharSequence label = (getPackageManager().getActivityInfo(getComponentName(), 0).nonLocalizedLabel);
            if (!TextUtils.isEmpty(label)) {
                ((TextView) findViewById(R.id.title)).setText(label);
            }
        } catch (Exception ignored) {
        }
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }
}
