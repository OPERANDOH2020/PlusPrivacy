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
import eu.operando.customView.PasswordConfirmationView;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.RegisterSwarmEntity;
import eu.operando.swarmclient.models.SwarmCallback;

public class SignUpActivity extends AppCompatActivity {

    private EditText inputEmail;
    private PasswordConfirmationView inputPassword;

    public static void start(Context context) {
        Intent starter = new Intent(context, SignUpActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.pull_in_right, R.anim.push_out_left);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);
        initUI();
    }

    private void initUI() {
        inputEmail = (EditText) findViewById(R.id.input_email);
        inputPassword = (PasswordConfirmationView) findViewById(R.id.input_password);

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
                String email = inputEmail.getText().toString();
                String password = inputPassword.getConfirmedPassword();

                signUp(email, password);
            }
        });

    }

    private void signUp(final String email, final String password) {
        if (email.isEmpty() || password.isEmpty()) {
            Toast.makeText(SignUpActivity.this, "Please complete all fields.", Toast.LENGTH_SHORT).show();
            return;
        }
        final OperandoProgressDialog dialog = new OperandoProgressDialog(this, "Creating account...");
        dialog.show();
        SwarmService.getInstance().signUp(email, password, new SwarmCallback<RegisterSwarmEntity>() {
            @Override
            public void call(final RegisterSwarmEntity result) {
                Log.d("Register", "call() called with: getResult = [" + result + "]");
                onSignUpSuccess(email, password, result, dialog);
            }
        });
    }

    private void onSignUpSuccess(final String email, final String password, final RegisterSwarmEntity result, final ProgressDialog dialog) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        dialog.dismiss();

                        if (result.getStatus() != null && result.getStatus().equals("error")) {
                            if (result.getError() != null)
                                Toast.makeText(SignUpActivity.this, result.getError().toString(), Toast.LENGTH_LONG).show();
                        } else {
                            Storage.saveRegisterCredentials(email, password);
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
        LoginActivity.start(SignUpActivity.this, true);
        finish();
    }
}
