package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.TextView;

import org.adblockplus.libadblockplus.android.webview.BuildConfig;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.IdentitiesExpandableListViewAdapter;
import eu.operando.models.Identity;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.IdentityListSwarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class IdentitiesActivity extends BaseActivity {
//    private ListView identitiesLV;
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
        getIdentities();
    }

    private void initUI() {
        identitiesELV = (ExpandableListView) findViewById(R.id.identities_elv);
//        identitiesLV = ((ListView) findViewById(R.id.identitiesLV));
        addIdentityBtn = findViewById(R.id.addIdentityBtn);
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        addIdentityBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CreateIdentityActivity.start(IdentitiesActivity.this);
            }
        });
        if (BuildConfig.DEBUG)
            ((TextView) findViewById(R.id.realIdentityTV)).setText("privacy_wizard@rms.ro");
    }

    @Override
    protected void onResume() {
        super.onResume();
        getIdentities();
    }

    public void getIdentities() {
        SwarmService.getInstance().getIdentitiesList(new SwarmCallback<IdentityListSwarm>() {
            @Override
            public void call(final IdentityListSwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        Log.d("ide", "call() called with: result = [" + result + "]");
                        identities = result.getIdentities();

                        setRealIdentity(identities);

                        identitiesELV.setAdapter(new IdentitiesExpandableListViewAdapter(IdentitiesActivity.this, identities));
                        identitiesELV.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {
                            int previousGroup = -1;

                            @Override
                            public void onGroupExpand(int groupPosition) {
                                if(groupPosition != previousGroup)
                                    identitiesELV.collapseGroup(previousGroup);
                                previousGroup = groupPosition;
                            }
                        });
                    }
                });
            }
        });
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


}
