package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;

import javax.inject.Inject;

import eu.operando.BrowserApp;
import eu.operando.R;
import eu.operando.lightning.preference.PreferenceManager;

public class SettingsActivity extends BaseActivity {
    @Inject PreferenceManager prefManager;

    public static void start(Context context) {
        Intent starter = new Intent(context, SettingsActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        BrowserApp.getAppComponent().inject(this);
        ((CheckBox) findViewById(R.id.cb_block_ads)).setChecked(prefManager.getAdBlockEnabled());
        ((CheckBox) findViewById(R.id.cb_block_ads)).setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                prefManager.setAdBlockEnabled(b);
            }
        });

        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
    }
}
