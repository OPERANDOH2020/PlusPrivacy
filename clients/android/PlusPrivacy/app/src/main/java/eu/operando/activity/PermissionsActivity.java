package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ListView;

import eu.operando.R;
import eu.operando.adapter.PermissionsListAdapter;

/**
 * Created by Edy on 6/17/2016.
 */
public class PermissionsActivity extends BaseActivity {
    public static void start(Context context) {
        Intent starter = new Intent(context, PermissionsActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_permissions);
        Toolbar toolbar = ((Toolbar) findViewById(R.id.toolbar));
        ListView listView = (ListView) findViewById(R.id.lv);
        if (listView != null) {
            if (getIntent().getStringArrayListExtra("perms") != null && getIntent().getStringArrayListExtra("perms").size() != 0) {
                listView.setAdapter(new PermissionsListAdapter(this, getIntent().getStringArrayListExtra("perms")));
            }
        }
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
    }
}
