package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.DomainAdapter;
import eu.operando.models.Domain;
import eu.operando.models.Identity;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.GenerateIdentitySwarmEntity;
import eu.operando.swarmService.models.GetDomainsSwarmEntity;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Edy on 10/20/2016.
 */
public class
CreateIdentityActivity extends AppCompatActivity {
    public static final String TAG = "CreateIdentityActivity";
    private Spinner domainsSpinner;
    private EditText aliasET;
    private View saveBtn;
    private View refresh;
    private ArrayList<Domain> domains;
    private TextView aliasDomainTV;
    SwarmService swarmService;

    public static void start(Context context) {
        Intent starter = new Intent(context, CreateIdentityActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_identity);

        initUI();
        swarmService = SwarmService.getInstance();
        setData();
    }

    private void setData() {

        ((TextView) findViewById(R.id.title)).setText("Add Identity");
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        domainsSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                setAliasDomainTV();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        getDomains();

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

    private void initUI() {

        domainsSpinner = ((Spinner) findViewById(R.id.domainsSpinner));
        aliasDomainTV = (TextView) findViewById(R.id.identity_alias_and_domain);
        aliasET = ((EditText) findViewById(R.id.aliasET));
        saveBtn = findViewById(R.id.saveBtn);
        refresh = findViewById(R.id.refreshBtn);
    }

    @Override
    protected void onResume() {
        super.onResume();
        generateIdentity();
    }

    private void getDomains() {

        swarmService.listDomains(new SwarmCallback<GetDomainsSwarmEntity>() {
            @Override
            public void call(final GetDomainsSwarmEntity result) {
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

    public void setAliasDomainTV() {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(aliasET.getText());
        stringBuilder.append("@");
        stringBuilder.append(((Domain) domainsSpinner.getSelectedItem()).getName());
        aliasDomainTV.setText(stringBuilder.toString());
    }

    private void generateIdentity() {


        swarmService.generateIdentity(new SwarmCallback<GenerateIdentitySwarmEntity>() {
            @Override
            public void call(final GenerateIdentitySwarmEntity result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        aliasET.setText(result.getIdentity().getEmail());
                        setAliasDomainTV();
                    }
                });
            }
        });
    }

    private void createIdentity(String email, String alias, Domain domain) {

        swarmService.createIdentity(new SwarmCallback<Swarm>() {
            @Override
            public void call(Swarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(CreateIdentityActivity.this, "Success", Toast.LENGTH_SHORT).show();
                        finish();
                    }
                });
            }
        }, new Identity(email, alias, domain));
    }

}
