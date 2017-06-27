package eu.operando.activity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import eu.operando.R;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.RegisterSwarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class SignUpActivity extends AppCompatActivity {
    private EditText inputName;
    private EditText inputEmail;
    private EditText inputPassword;

    public static void start(Context context) {
        Intent starter = new Intent(context, SignUpActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.pull_in_right, R.anim.push_out_left);
        ;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);
        initUI();
    }

    private void initUI() {
        inputName = (EditText) findViewById(R.id.input_name);
        inputEmail = (EditText) findViewById(R.id.input_email);
        inputPassword = (EditText) findViewById(R.id.input_password);

        findViewById(R.id.link_login).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LoginActivity.start(SignUpActivity.this);
                finish();
            }
        });

        findViewById(R.id.btn_signup).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String name = inputName.getText().toString();
                String email = inputEmail.getText().toString();
                String password = inputPassword.getText().toString();

                signUp(name, email, password);
            }
        });

    }

    private void signUp(String name, final String email, final String password) {
        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            Toast.makeText(SignUpActivity.this, "Please complete all fields.", Toast.LENGTH_SHORT).show();
            return;
        }
        final OperandoProgressDialog dialog = new OperandoProgressDialog(this, "Creating account...");
        dialog.show();
        SwarmService.getInstance().signUp(name, email, password, new SwarmCallback<RegisterSwarm>() {
            @Override
            public void call(final RegisterSwarm result) {
                Log.d("Register", "call() called with: result = [" + result + "]");
                onSignUpSuccess(email,password,result, dialog);
            }


        });

    }

    private void onSignUpSuccess(final String email, final String password, final RegisterSwarm result, final ProgressDialog dialog) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        dialog.dismiss();

                        if (result.getStatus() != null && result.getStatus().equals("error")) {
                            Toast.makeText(SignUpActivity.this, result.getError(), Toast.LENGTH_LONG).show();
                        } else {
                            Storage.saveRegisterCredentials(email,password);
                            Toast.makeText(SignUpActivity.this, "Registration success. Please check your e-mail to activate the account", Toast.LENGTH_LONG).show();
                            onBackPressed();
                        }
                    }
                }, 1000);
            }
        });
    }

    @Override
    public void onBackPressed() {
        LoginActivity.start(SignUpActivity.this);
        finish();
    }
}
