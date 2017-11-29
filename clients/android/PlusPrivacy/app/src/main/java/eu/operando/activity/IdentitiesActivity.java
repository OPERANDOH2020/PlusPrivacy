package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import org.adblockplus.libadblockplus.android.webview.BuildConfig;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.IdentitiesExpandableListViewAdapter;
import eu.operando.models.Identity;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.IdentityListSwarmEntity;
import eu.operando.swarmclient.models.SwarmCallback;

public class IdentitiesActivity extends BaseActivity {

    private ExpandableListView identitiesELV;
    private View addIdentityBtn;
    ArrayList<Identity> identities;

    public static void start(Context context) {
        Intent starter = new Intent(context, IdentitiesActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_identities);
        initUI();
        setActions();

    }

    private void initUI() {

        setToolbar();
        identitiesELV = (ExpandableListView) findViewById(R.id.identities_elv);
        addIdentityBtn = findViewById(R.id.addIdentityBtn);

        if (BuildConfig.DEBUG)
            ((TextView) findViewById(R.id.realIdentityTV)).setText("privacy_wizard@rms.ro");
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.identities_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    private void setActions() {
        addIdentityBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CreateIdentityActivity.start(IdentitiesActivity.this);
            }
        });
        identitiesELV.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {
            int previousGroup = -1;

            @Override
            public void onGroupExpand(int groupPosition) {
                if (groupPosition != previousGroup)
                    identitiesELV.collapseGroup(previousGroup);
                previousGroup = groupPosition;
            }
        });

        identitiesELV.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView parent, View clickedView, int groupPosition, long rowId) {
                ImageView groupIndicator = (ImageView) clickedView.findViewById(R.id.arrow);
                if (parent.isGroupExpanded(groupPosition)) {
                    parent.collapseGroup(groupPosition);
                    groupIndicator.setImageResource(R.drawable.ic_forward_identities);
                } else {
                    parent.expandGroup(groupPosition);
                    groupIndicator.setImageResource(R.drawable.ic_bottom_arrow_identities);
                }
                return true;
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        getIdentities();
    }

    public void getIdentities() {

        SwarmService.getInstance().getIdentitiesList(new SwarmCallback<IdentityListSwarmEntity>() {
            @Override
            public void call(final IdentityListSwarmEntity result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        setIdentities(result);
                    }
                });
            }
        });
    }

    private void setIdentities(IdentityListSwarmEntity result) {

        Log.d("ide", "call() called with: result = [" + result + "]");
        identities = result.getIdentities();

        setRealIdentity(identities);
        identitiesELV.setAdapter(new IdentitiesExpandableListViewAdapter(IdentitiesActivity.this, identities));
    }

    private void setRealIdentity(ArrayList<Identity> identities) {
        if (identities.size() > 0) {
            for (Identity i : identities) {
                if (i.isReal()) {
                    ((TextView) findViewById(R.id.realIdentityTV)).setText(i.getEmail());
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        finish();
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
        }
        return super.onOptionsItemSelected(item);
    }

}