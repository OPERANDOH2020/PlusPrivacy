package eu.operando.activity;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.widget.ListView;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.adapter.SocialNetworkAccountsAdapter;

/**
 * Created by Alex on 16.04.2018.
 */

public class SocialNetworkAccountsActivity extends BaseActivity {

    private TextView infoHeader;
    private ListView listView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.social_network_second_fragment);
        initUI();

    }

    private void initUI() {

        Toolbar myToolbar = (Toolbar) findViewById(R.id.toolbar);
//        myToolbar.setTitle(getStringTitleId());
        setSupportActionBar(myToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        infoHeader = (TextView) findViewById(R.id.info_header);
//        infoHeader.setText(getStringDescriptionId());

        listView = (ListView) findViewById(R.id.sn_accounts_list_view);
        listView.setAdapter(new SocialNetworkAccountsAdapter(this, R.layout.social_networks_account_item));

    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }
}
