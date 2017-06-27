package eu.operando.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AlertDialog;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;


import com.google.gson.Gson;

import org.greenrobot.eventbus.Subscribe;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.IdentitiesListAdapter;
import eu.operando.model.CreateIdentityBody;
import eu.operando.osdk.swarm.client.SwarmClient;
import eu.operando.osdk.swarm.client.events.SwarmIdentityListEvent;
import eu.operando.osdk.swarm.client.models.Identity;

/**
 * Created by Edy on 10/19/2016.
 */
public class IdentitiesActivity extends BaseActivity {
    private static final String TAG = "IdentitiesActivity";
    ListView identitiesLV;
    View addIdentityBtn;
    SwarmClient swarmClient;
    ArrayList<Identity> identities;

    public static void start(Context context) {
        Intent starter = new Intent(context, IdentitiesActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            swarmClient = SwarmClient.getInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
//        createIdentity("test@test.test","test.test",new Domain("uh","dunno"));
        setContentView(R.layout.activity_identities);
        identitiesLV = ((ListView) findViewById(R.id.identitiesLV));
        addIdentityBtn = findViewById(R.id.addIdentityBtn);
        addIdentityBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CreateIdentityActivity.start(IdentitiesActivity.this);
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onResume() {
        super.onResume();
        getIdentities();
    }

    @Subscribe
    public void onIdentitiesListEvent(final SwarmIdentityListEvent event) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (event.getIdentities().size() > 0) {
                    ((TextView) findViewById(R.id.realIdentityTV)).setText(event.getIdentities().get(0).getUserId());
                }
                identities = event.getIdentities();
                identitiesLV.setAdapter(new IdentitiesListAdapter(IdentitiesActivity.this, event.getIdentities()));

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

    private void updateIdentity(int position, String method) {
        Identity i = identities.get(position);
        CreateIdentityBody body = new CreateIdentityBody(i.getEmail(), null, null);
        String[] arguments = {new Gson().toJson(body)};
        final ProgressDialog dialog = new ProgressDialog(this);
        dialog.setCancelable(false);
        dialog.setMessage("Please wait...");
        dialog.show();
        swarmClient.startSwarm("identity.js", "start", method, arguments);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                getIdentities();
                dialog.dismiss();
            }
        }, 1000);
    }


    public void getIdentities() {
        swarmClient.startSwarm("identity.js", "start", "getMyIdentities");
    }
}
