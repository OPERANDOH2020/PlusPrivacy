package eu.operando.activity;

import android.accounts.AccountManager;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Pair;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import eu.operando.R;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.LoginSwarm;
import eu.operando.swarmclient.models.SwarmCallback;
import io.paperdb.Paper;

public class LoginActivity extends AppCompatActivity {

    private EditText emailText;
    private EditText passwordText;

    public static void start(Context context) {
        Intent starter = new Intent(context, LoginActivity.class);
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
        Pair<String, String> credentials = Storage.readCredentials();
        if (credentials.first != null && credentials.second != null) {
//            login(credentials.first,credentials.second);
            MainActivity.start(this, true);
            finish();
            return;
        }
        credentials = Storage.readRegisterCredentials();
        if (credentials.first != null && credentials.second != null) {
            emailText.setText(credentials.first);
            passwordText.setText(credentials.second);
            Storage.clearRegisterCredentials();
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
        //FIXME
//        swarmLogin("kkkk@mailinator.com","aaaa",new ProgressDialog(this));
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

        SwarmService.getInstance().login(username, password, new SwarmCallback<LoginSwarm>() {
            @Override
            public void call(final LoginSwarm result) {
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
                                    storeCredentials(username, password);
                                    finish();
                                } else {
                                    emailText.setText("");
                                    passwordText.setText("");
                                }
                            }
                        }, 1);
                    }
                });

            }
        });
    }

    private void storeCredentials(String user, String pass) {
        Storage.saveCredentials(user, pass);
    }


}
