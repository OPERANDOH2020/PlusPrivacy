package eu.operando.activity;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import eu.operando.R;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.customView.SignInFailedDialog;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.LoginSwarmEntity;
import eu.operando.swarmService.models.RegisterZoneSwarm;
import eu.operando.swarmService.models.UDESwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class LoginActivity extends AppCompatActivity {

    private EditText emailText;
    private EditText passwordText;

    public static void start(Context context) {
        start(context, false);
    }

    public static void start(Context context, boolean fromMainActivity) {
        Intent starter = new Intent(context, LoginActivity.class);
        if (fromMainActivity) {
            starter.putExtra("fromMainActivity", fromMainActivity);
        }
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.pull_in_left, R.anim.push_out_right);


    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        initUI();
        autoLoginOrComplete();
    }

    private void autoLoginOrComplete() {

        Pair<String, String> credentials = Storage.readRegisterCredentials();
        if (credentials.first != null && credentials.second != null) {
            emailText.setText(credentials.first);
            passwordText.setText(credentials.second);
            Storage.clearRegisterCredentials();
        }

        if (Storage.isUserLogged()) {
            credentials = Storage.readCredentials();
            login(credentials.first, credentials.second);
            return;
        } else {
            boolean extra = getIntent().getBooleanExtra("fromMainActivity", false);
            if (!extra) {
                MainActivity.start(LoginActivity.this, false);
                finish();
            }
        }
    }

    private void initUI() {
        emailText = (EditText) findViewById(R.id.input_email);
        passwordText = (EditText) findViewById(R.id.input_password);
        findViewById(R.id.link_signup).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SignUpActivity.start(LoginActivity.this);
                finish();
            }
        });

        findViewById(R.id.btn_login).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String email = emailText.getText().toString();
                String password = passwordText.getText().toString();
                login(email, password);
            }
        });

        findViewById(R.id.resetPasswordTV).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showResetPasswordDialog();
            }
        });
    }

    private void login(String email, String password) {

        if (email.isEmpty() && password.isEmpty()) {
            Toast.makeText(this, "Please enter an e-mail address and a password.", Toast.LENGTH_SHORT).show();
            return;
        }

        final OperandoProgressDialog progressDialog = new OperandoProgressDialog(this);
        progressDialog.setMessage("Authenticating...");
        progressDialog.show();

        swarmLogin(email, password, progressDialog);
    }

    private void swarmLogin(final String username, final String password, final ProgressDialog dialog) {

        SwarmService.getInstance().login(username, password, new SwarmCallback<LoginSwarmEntity>() {

            @Override
            public void call(final LoginSwarmEntity result) {

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                dialog.dismiss();
                                if (result.isAuthenticated()) {
                                    Storage.saveUserID(result.getUserId());
                                    MainActivity.start(LoginActivity.this, false);
                                    finish();
                                    storeCredentials(username, password);
                                    registerZone();
                                    finish();
                                } else {
                                    if (Storage.isUserLogged()) {
                                        MainActivity.start(LoginActivity.this, false);
                                    } else {
                                        showFailedLoginDialog();
                                    }
                                }
                            }
                        }, 100);
                    }
                });
            }
        });
    }

    private void registerZone() {
        SwarmService.getInstance().startSwarm(new RegisterZoneSwarm("Android"),
                new SwarmCallback<RegisterZoneSwarm>() {
                    @Override
                    public void call(final RegisterZoneSwarm result) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Log.e("RegisterZoneSwarm", result.toString());
                            }
                        });
                    }
                });
        final String androidId = Settings.Secure.getString(
                getContentResolver(), Settings.Secure.ANDROID_ID);
        Log.w("UUID", androidId);
        SwarmService.getInstance().startSwarm(new UDESwarm(androidId), new SwarmCallback<UDESwarm>() {
            @Override
            public void call(final UDESwarm result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Log.e("UDESwarm", result.toString());
                    }
                });
            }
        });
    }

    public void showFailedLoginDialog() {
        if (!isFinishing()) {
            DialogFragment newFragment = new SignInFailedDialog();
            if (!newFragment.isAdded()) {
                newFragment.show(getFragmentManager(), "SignInFailedDialog");
            }
        }
    }

    public void showResetPasswordDialog() {
        AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);
        LayoutInflater inflater = this.getLayoutInflater();
        final View dialogView = inflater.inflate(R.layout.reset_pass_dialog, null);
        dialogBuilder.setView(dialogView);

        final EditText edt = (EditText) dialogView.findViewById(R.id.emailTV);

        dialogBuilder.setTitle("Enter e-mail");
        dialogBuilder.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                String email = edt.getText().toString();
                SwarmService.getInstance().resetPassword(email, new SwarmCallback<Swarm>() {
                    @Override
                    public void call(final Swarm result) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                if (result.getMeta().getCurrentPhase().equals("resetRequestDone")) {
                                    Toast.makeText(LoginActivity.this, "You will receive an e-mail shortly.", Toast.LENGTH_SHORT).show();
                                } else {
                                    Toast.makeText(LoginActivity.this, result.getError().toString(), Toast.LENGTH_SHORT).show();
                                }
                            }
                        });
                    }
                });
            }
        });
        dialogBuilder.setNegativeButton("Cancel", null);
        AlertDialog b = dialogBuilder.create();
        b.show();
    }

    private void storeCredentials(String user, String pass) {
        Storage.saveCredentials(user, pass);
    }


}
