package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.animation.FastOutLinearInInterpolator;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.HashSet;
import java.util.List;

import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.customView.AccordionOnGroupExpandListener;
import eu.operando.customView.FacebookSettingsInfoDialog;
import eu.operando.models.InstalledApp;
import eu.operando.storage.Storage;
import eu.operando.utils.PermissionUtils;

public class ScannerActivity extends BaseActivity {

    private ExpandableListView listView;
    private boolean shouldRefresh = true;
    private HashSet<String> unknownPerms;
    private TextView privacyScoreTv;
    private TextView confidentialityLevel;
    private ImageView indicatorIv;
    private int privacyScore;
    private Handler handler = new Handler();

    public static void start(Context context) {

        Intent starter = new Intent(context, ScannerActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.fade_in, R.anim.fade_out);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scanner);
        initUI();
    }

    private void initUI() {

        setToolbar();

        listView = (ExpandableListView) findViewById(R.id.app_list_view);
        View myHeader = ((LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE))
                .inflate(R.layout.scanner_list_header, null, false);

        listView.addHeaderView(myHeader);

        privacyScoreTv = (TextView) myHeader.findViewById(R.id.privacy_score);
        confidentialityLevel = (TextView) myHeader.findViewById(R.id.confidentiality_level);
        indicatorIv = (ImageView) myHeader.findViewById(R.id.privacy_indicator);

        unknownPerms = new HashSet<>();
//        if(/*PreferenceManager.getDefaultSharedPreferences(this).getBoolean("once",true)&&*/ BuildConfig.DEBUG) {
//            for (InstalledApp app : Storage.readAppList()) {
//                if (app.getPermissions() == null) continue;
//                for (String permission : app.getPermissions()) {
//                    String[] splitted = permission.split("\\.");
//                    String simplifiedPermission = splitted[splitted.length - 1];
//                    if (PermissionUtils.getPermissionDescription(simplifiedPermission).isEmpty()) {
//                        unknownPerms.add(simplifiedPermission);
//                    }
//                }
//            }
//            sendEmail();
//            PreferenceManager.getDefaultSharedPreferences(this).edit().putBoolean("once",false).apply();
//        }


    }

    private void setData() {

        List<InstalledApp> list = Storage.readAppList();
        setPrivacyScoreTv(list);
        setConfidentialityLevel();
        rotateIndicator();
        setDataListView(list);

    }

    private void setDataListView(List<InstalledApp> list) {

        listView.setOnGroupExpandListener(new AccordionOnGroupExpandListener(listView));

        ScannerListAdapter adapter = new ScannerListAdapter(this, list);
        listView.setAdapter(adapter);
    }

    private void setPrivacyScoreTv(List<InstalledApp> list) {

        int sum = 0;
        for (InstalledApp app : list) {
            sum += app.getPollutionScore();
        }
        privacyScore = 10 * sum / list.size();
        privacyScoreTv.setText(String.valueOf(privacyScore));

    }

    private void rotateIndicator() {

        final int rotationAngle = (privacyScore * 140) / 100;
        final RotateAnimation rotate = new RotateAnimation(0, rotationAngle,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                0.5f);
        rotate.setDuration(1500);
        rotate.setFillAfter(true);
        rotate.setInterpolator(new FastOutLinearInInterpolator());

        handler.post(new Runnable() {
            @Override
            public void run() {
                indicatorIv.startAnimation(rotate);
            }
        });

    }

    private void setConfidentialityLevel() {

        if (privacyScore <= 25) {
            confidentialityLevel.setText(getString(R.string.high));
        } else if (privacyScore <= 75 && privacyScore > 25) {
            confidentialityLevel.setText(getString(R.string.medium));
        } else {
            confidentialityLevel.setText(getString(R.string.low));
        }
    }

    protected void sendEmail() {
        String[] TO = {"sle@rms.ro"};
        String[] CC = {""};
        Intent emailIntent = new Intent(Intent.ACTION_SEND);
        String body = "";
        for (String perm : unknownPerms) {
            body += perm + "\n";
        }

        emailIntent.setData(Uri.parse("mailto:"));
        emailIntent.setType("text/plain");
        emailIntent.putExtra(Intent.EXTRA_EMAIL, TO);
        emailIntent.putExtra(Intent.EXTRA_CC, CC);
        emailIntent.putExtra(Intent.EXTRA_SUBJECT, "Perms");
        emailIntent.putExtra(Intent.EXTRA_TEXT, body);

        try {
            startActivity(Intent.createChooser(emailIntent, "Send mail..."));
        } catch (android.content.ActivityNotFoundException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (shouldRefresh) {
            reloadApps();

        } else {
            shouldRefresh = true;
        }
    }

    private void reloadApps() {
        Storage.saveAppList(PermissionUtils.getApps(this, false));
        setData();
    }

    @Override
    public void onBackPressed() {
        finish();
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    public void infoClicked() {
        shouldRefresh = false;
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.scanner_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.scanner, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
        }
        switch (item.getItemId()) {
            case R.id.facebook_settings_recommended:
                FacebookSettingsInfoDialog dialog = new FacebookSettingsInfoDialog();
                dialog.show(getFragmentManager(), "FacebookSettingsInfoDialog");
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}
