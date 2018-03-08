package eu.operando;

import android.support.v7.widget.Toolbar;
import android.view.View;

import eu.operando.activity.BaseActivity;
import eu.operando.activity.LoginActivity;

/**
 * Created by Alex on 3/8/2018.
 */

public abstract class AuthenticationRequiredActivity extends BaseActivity {

    protected void setViewForAuthenticationRequired() {
        findViewById(R.id.not_logged).setVisibility(View.VISIBLE);
        findViewById(R.id.go_to_login).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LoginActivity.start(AuthenticationRequiredActivity.this, true);
            }
        });
        setToolbar();
    }

    protected void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }


}
