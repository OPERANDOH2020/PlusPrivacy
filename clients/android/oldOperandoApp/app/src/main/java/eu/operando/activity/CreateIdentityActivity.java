package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.google.gson.Gson;

import org.greenrobot.eventbus.Subscribe;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.DomainAdapter;
import eu.operando.model.CreateIdentityBody;
import eu.operando.osdk.swarm.client.SwarmClient;
import eu.operando.osdk.swarm.client.events.CreateIdentitySuccessEvent;
import eu.operando.osdk.swarm.client.events.DomainsListSuccessEvent;
import eu.operando.osdk.swarm.client.events.GenerateIdentitySuccessEvent;
import eu.operando.osdk.swarm.client.models.Domain;

/**
 * Created by Edy on 10/20/2016.
 */
public class CreateIdentityActivity extends BaseActivity {
    public static final String TAG = "CreateIdentityActivity";
    private Spinner domainsSpinner;
    private EditText aliasET;
    private View saveBtn;
    private View refresh;
    private ArrayList<Domain> domains;
    SwarmClient swarmClient;

    public static void start(Context context) {
        Intent starter = new Intent(context, CreateIdentityActivity.class);
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
        setContentView(R.layout.activity_create_identity);
        getDomains();
        domainsSpinner = ((Spinner) findViewById(R.id.domainsSpinner));
        aliasET = ((EditText) findViewById(R.id.aliasET));
        saveBtn = findViewById(R.id.saveBtn);
        refresh = findViewById(R.id.refreshBtn);
        refresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                generateIdentity();
            }
        });
        saveBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Domain domain = domains.get(domainsSpinner.getSelectedItemPosition());
                String domName = domain.getName();
                String alias = aliasET.getText().toString();
                String email = alias + "@" + domName;
                createIdentity(email, alias, domain);
            }
        });
    }

    private void getDomains() {
        swarmClient.startSwarm("identity.js", "start", "listDomains");
    }

    private void generateIdentity() {
        swarmClient.startSwarm("identity.js", "start", "generateIdentity");
    }

    @Subscribe
    public void onDomainsSuccess(final DomainsListSuccessEvent event) {
        Log.d(TAG, "onDomainsSuccess() called with: event = [" + event + "]");
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                domainsSpinner.setAdapter(new DomainAdapter(CreateIdentityActivity.this, 0, event.getDomains()));
                domains = event.getDomains();
            }
        });
    }


    @Subscribe
    public void onGenerateIdentitySuccess(final GenerateIdentitySuccessEvent event) {
        Log.d(TAG, "onGenerateIdentitySuccess() called with: event = [" + event + "]");
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                aliasET.setText(event.getIdentity().getEmail());
            }
        });
    }

    @Subscribe
    public void onCreateIdentitySuccess(CreateIdentitySuccessEvent event) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(CreateIdentityActivity.this, "Success", Toast.LENGTH_SHORT).show();

            }
        });
        Log.d(TAG, "onCreateIdentity() called with: event = [" + event + "]");
        finish();
    }


    private void createIdentity(String email, String alias, Domain domain) {
        CreateIdentityBody body = new CreateIdentityBody(email, alias, domain);
        String[] arguments = {new Gson().toJson(body)};
        swarmClient.startSwarm("identity.js", "start", "createIdentity", arguments);
    }

}
