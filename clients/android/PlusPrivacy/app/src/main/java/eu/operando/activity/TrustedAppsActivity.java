package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import eu.operando.R;

public class TrustedAppsActivity extends BaseActivity {
    public static void start(Context context) {
        Intent starter = new Intent(context, TrustedAppsActivity.class);
        context.startActivity(starter);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_trusted_apps);
    }
}
