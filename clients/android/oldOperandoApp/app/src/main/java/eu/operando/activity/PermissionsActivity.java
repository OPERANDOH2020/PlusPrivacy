package eu.operando.activity;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;

import eu.operando.R;
import eu.operando.adapter.PermissionsListAdapter;

/**
 * Created by Edy on 6/17/2016.
 */
public class PermissionsActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifications);
        Toolbar toolbar = ((Toolbar) findViewById(R.id.toolbar));
        ListView listView = (ListView) findViewById(R.id.lv);
        if (listView != null) {
            listView.setAdapter(new PermissionsListAdapter(this, getIntent().getStringArrayListExtra("perms")));
        }
    }
}
