package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.DomainAdapter;
import eu.operando.models.Domain;
import eu.operando.models.Identity;
import eu.operando.swarmService.models.GetDomainsSwarm;
import eu.operando.swarmService.models.CreateIdentitySwarm;
import eu.operando.swarmService.models.GenerateIdentitySwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Edy on 10/20/2016.
 */
public class CreateIdentityActivity extends AppCompatActivity {
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
        swarmClient = SwarmClient.getInstance();
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

    @Override
    protected void onResume() {
        super.onResume();
        generateIdentity();
    }

    private void getDomains() {
        swarmClient.startSwarm(new GetDomainsSwarm(), new SwarmCallback<GetDomainsSwarm>() {
            @Override
            public void call(final GetDomainsSwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        domains = result.getDomains();
                        domainsSpinner.setAdapter(new DomainAdapter(CreateIdentityActivity.this, 0, domains));
                    }
                });
            }
        });
    }

    private void generateIdentity() {
        swarmClient.startSwarm(new GenerateIdentitySwarm(), new SwarmCallback<GenerateIdentitySwarm>() {
            @Override
            public void call(final GenerateIdentitySwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        aliasET.setText(result.getIdentity().getEmail());
                    }
                });
            }

        });
    }


    private void createIdentity(String email, String alias, Domain domain) {

        swarmClient.startSwarm(new CreateIdentitySwarm(new Identity(email, alias, domain)), new SwarmCallback<CreateIdentitySwarm>() {
            @Override
            public void call(CreateIdentitySwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(CreateIdentityActivity.this, "Success", Toast.LENGTH_SHORT).show();
                        finish();
                    }
                });
            }
        });
    }

}
