package eu.operando.activity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.adblockplus.libadblockplus.android.webview.BuildConfig;

import java.util.ArrayList;

import eu.operando.AuthenticationRequiredActivity;
import eu.operando.R;
import eu.operando.adapter.IdentitiesExpandableListViewAdapter;
import eu.operando.customView.AccordionOnGroupExpandListener;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.models.Identity;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.IdentityListSwarmEntity;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class IdentitiesActivity extends AuthenticationRequiredActivity implements IdentitiesExpandableListViewAdapter.IdentityListener {

    private ExpandableListView identitiesELV;
    private LinearLayout defaultRealIdentity;
    private View addIdentityBtn;
    ArrayList<Identity> identities;
    private Identity realIdentity;
    private Identity defaultIdentity;

    public static void start(Context context) {
        Intent starter = new Intent(context, IdentitiesActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_identities);

        if (Storage.isUserLogged()){
            initUI();
            setActions();
        } else {
            setViewForAuthenticationRequired();
        }

    }

    private void initUI() {

        setToolbar();
        identitiesELV = (ExpandableListView) findViewById(R.id.identities_elv);
        addIdentityBtn = findViewById(R.id.addIdentityBtn);
        defaultRealIdentity = (LinearLayout) findViewById(R.id.default_real_identity);

        if (BuildConfig.DEBUG)
            ((TextView) findViewById(R.id.realIdentityTV)).setText("privacy_wizard@rms.ro");
    }

    private void setActions() {
        addIdentityBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CreateIdentityActivity.start(IdentitiesActivity.this);
            }
        });

        defaultRealIdentity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (realIdentity != null && !realIdentity.equals(defaultIdentity)) {
                    updateIdentity(realIdentity, "updateDefaultSubstituteIdentity");
                } else {
                    Toast.makeText(IdentitiesActivity.this, R.string.default_identity_toast, Toast.LENGTH_SHORT).show();
                }
            }
        });
        identitiesELV.setOnGroupExpandListener(new AccordionOnGroupExpandListener(identitiesELV));
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
        identitiesELV.setAdapter(new IdentitiesExpandableListViewAdapter(IdentitiesActivity.this,
                identities));
    }

    private void setRealIdentity(ArrayList<Identity> identities) {
        if (identities.size() > 0) {
            for (int index = 0; index < identities.size(); ++index) {
                Identity i = identities.get(index);
                if (i.isReal()) {
                    realIdentity = i;
                    identities.remove(realIdentity);
                    --index;
                    ((TextView) findViewById(R.id.realIdentityTV)).setText(i.getEmail());
                }
                if (i.isDefault()) {
                    defaultIdentity = i;
                    if (defaultIdentity.equals(realIdentity)) {
                        defaultRealIdentity.setBackgroundColor(ContextCompat.getColor(this,
                                R.color.identities_button_inactive_background));
                    } else {
                        defaultRealIdentity.setBackgroundColor(ContextCompat.getColor(this,
                                R.color.identities_button_active_background));
                    }
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

    public void updateIdentity(Identity identity, String method) {

        if (identity.isDefault()){
            Toast.makeText(this, R.string.default_identity_toast, Toast.LENGTH_SHORT).show();
            return;
        }
        final ProgressDialog dialog = new OperandoProgressDialog(this);
        dialog.setCancelable(false);
        dialog.setMessage("Please wait...");
        dialog.show();

        SwarmService.getInstance().updateIdentity(new SwarmCallback<Swarm>() {
            @Override
            public void call(final Swarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        getIdentities();
                        dialog.dismiss();
                    }
                });
            }
        }, method, identity.getEmail());
    }

    public void setClipboard(Identity identity) {

        ClipboardManager clipboard = (ClipboardManager)
                this.getSystemService(Context.CLIPBOARD_SERVICE);
        ClipData clip = ClipData.newPlainText("identity", identity.getEmail());
        if (clipboard != null) {
            clipboard.setPrimaryClip(clip);
            Toast.makeText(this, "Identity was copied to clipboard", Toast.LENGTH_SHORT).show();
        }
    }

}