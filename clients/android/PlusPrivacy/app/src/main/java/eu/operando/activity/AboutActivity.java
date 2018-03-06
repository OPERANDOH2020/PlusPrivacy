package eu.operando.activity;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import eu.operando.R;

/**
 * Created by Alex on 12/20/2017.
 */

public class AboutActivity extends BaseActivity {

    private String libraries[] = {"Dagger", "LeakCanary", "Socket.io", "Gson", "Picasso",
            "Paper", "ButterKnife"};

    private String links[] = {
            "https://github.com/google/dagger",
            "https://github.com/square/leakcanary",
            "https://github.com/socketio/socket.io-client-java",
            "https://github.com/google/gson",
            "https://github.com/square/picasso",
            "https://github.com/pilgr/Paper",
            "https://github.com/JakeWharton/butterknife"
    };
    private ListView listView;
    private TextView appVersion;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);

        setToolbar();
        initUi();
        setData();

    }

    private void setData() {

        setAppVersion();

        listView.setAdapter(new ArrayAdapter<>(this, R.layout.about_libraries_item, libraries));
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
                if (position - 1 >= 0 && position - 1 < libraries.length) {
                    Intent i = new Intent(Intent.ACTION_VIEW);
                    i.setData(Uri.parse(links[position - 1]));
                    startActivity(i);
                }
            }
        });
    }

    private void initUi() {

        listView = (ListView) findViewById(R.id.libraries_lv);

        LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);

        View header = inflater.inflate(R.layout.header_view_about, null);
        View footer = inflater.inflate(R.layout.footer_view_about, null);
        listView.addHeaderView(header);
        listView.addFooterView(footer);

        appVersion = (TextView) footer.findViewById(R.id.app_version_tv);
    }

    private void setAppVersion() {

        try {
            PackageInfo pInfo = this.getPackageManager().getPackageInfo(getPackageName(), 0);
            String version = pInfo.versionName;
            appVersion.setText(appVersion.getText() + " " + version);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

}