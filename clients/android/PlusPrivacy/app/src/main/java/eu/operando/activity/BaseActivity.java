package eu.operando.activity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import eu.operando.PlusPrivacyApp;
import eu.operando.R;
import eu.operando.swarmService.SwarmService;
import eu.operando.utils.ConnectivityReceiver;

/**
 * Created by Edy on 15-May-17.
 */

public class BaseActivity extends AppCompatActivity implements ConnectivityReceiver.ConnectivityReceiverListener {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        registerConnectivityListener();
    }

    @Override
    protected void onResume() {
        super.onResume();
        try {
            CharSequence label;
            if (getIntent().getExtras() != null && !TextUtils.isEmpty(getIntent().getExtras().getString("title"))) {
                label = getIntent().getExtras().getString("title");
            } else {
                label = (getPackageManager().getActivityInfo(getComponentName(), 0).nonLocalizedLabel);
            }
            if (!TextUtils.isEmpty(label)) {
                ((TextView) findViewById(R.id.title)).setText(label);
            }
        } catch (Exception ignored) {
        }
    }

    private void registerConnectivityListener() {

        final IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);

        ConnectivityReceiver connectivityReceiver = new ConnectivityReceiver();
        PlusPrivacyApp.getInstance().getApplicationContext().registerReceiver(connectivityReceiver, intentFilter);

        PlusPrivacyApp.getInstance().setConnectivityListener(this);
    }

    @Override
    public void onNetworkConnectionChanged(boolean isConnected) {

        if (isConnected) {
            if (alertDialog != null) {
                isShowing = false;
                alertDialog.cancel();
            }
        } else {
            if (alertDialog == null || !isShowing) {
                isShowing = true;
//                showSocialNetworkDialog();
            }
        }

    }


    private AlertDialog alertDialog;
    private boolean isShowing = false;

    public void showSocialNetworkDialog() {

        new android.os.Handler().post(new Runnable() {
            @Override
            public void run() {

                AlertDialog.Builder builder = new AlertDialog.Builder(BaseActivity.this);
                alertDialog = builder.setTitle(R.string.connection_lost)
                        .setMessage(R.string.connection_lost)
                        .setPositiveButton(R.string.action_ok, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                                dialog.dismiss();
                            }
                        })
                        .create();
                if( !isFinishing() ){
                    alertDialog.show();
                }
            }
        });

    }
}
