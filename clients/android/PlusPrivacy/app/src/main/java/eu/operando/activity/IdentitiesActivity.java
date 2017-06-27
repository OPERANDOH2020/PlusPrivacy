package eu.operando.activity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import org.adblockplus.libadblockplus.android.webview.BuildConfig;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.IdentitiesListAdapter;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.models.Identity;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.IdentityListSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class IdentitiesActivity extends BaseActivity {
    private ListView identitiesLV;
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
        identitiesLV = ((ListView) findViewById(R.id.identitiesLV));
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

    private void getIdentities() {
        SwarmService.getInstance().getIdentitiesList(new SwarmCallback<IdentityListSwarm>() {
            @Override
            public void call(final IdentityListSwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        Log.d("ide", "call() called with: result = [" + result + "]");
                        identities = result.getIdentities();
                        identitiesLV.setAdapter(new IdentitiesListAdapter(IdentitiesActivity.this, identities));
                        if (identities.size() > 0) {
                            for (Identity i : identities) {
                                if (i.isReal()) {
                                    ((TextView) findViewById(R.id.realIdentityTV)).setText(i.getEmail());
                                }
                            }
                        }

                        identitiesLV.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                            @Override
                            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                                if (identities.get(position).isDefault()) return;
                                AlertDialog.Builder builder = new AlertDialog.Builder(IdentitiesActivity.this)
                                        .setMessage("Select an action")
                                        .setNegativeButton(
                                                "Remove",
                                                new DialogInterface.OnClickListener() {
                                                    @Override
                                                    public void onClick(DialogInterface dialog, int which) {
                                                        updateIdentity(position, "removeIdentity");
                                                    }
                                                }
                                        ).setPositiveButton(
                                                "Set default",
                                                new DialogInterface.OnClickListener() {
                                                    @Override
                                                    public void onClick(DialogInterface dialog, int which) {
                                                        updateIdentity(position, "updateDefaultSubstituteIdentity");
                                                    }
                                                }
                                        );
                                builder.show();

                            }
                        });
                    }
                });
            }
        });
    }


    private void updateIdentity(int position, String method) {
        Identity i = identities.get(position);
        final ProgressDialog dialog = new OperandoProgressDialog(this);
        dialog.setCancelable(false);
        dialog.setMessage("Please wait...");
        dialog.show();
        SwarmClient.getInstance().startSwarm(new Swarm("identity.js", method, new Identity(i.getEmail(), null, null)), new SwarmCallback<Swarm>() {
            @Override
            public void call(Swarm result) {
                getIdentities();
                dialog.dismiss();
            }
        });
    }


    @Override
    public void onBackPressed() {
        finish();
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }
}
