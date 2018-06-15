package eu.operando.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.animation.FastOutLinearInInterpolator;
import android.support.v7.widget.Toolbar;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ImageSpan;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.AdapterView;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;

import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.tasks.AccordionOnGroupExpandListener;
import eu.operando.models.InstalledApp;
import eu.operando.storage.Storage;
import eu.operando.utils.PermissionUtils;

public class ScannerActivity extends BaseActivity {

    private ExpandableListView listView;
    private HashSet<String> unknownPerms;
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
        reloadApps();
        rotateIndicator();

    }

    private void initUI() {

        setToolbar();

        listView = (ExpandableListView) findViewById(R.id.app_list_view);
        View myHeader = ((LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE))
                .inflate(R.layout.scanner_list_header, null, false);

        listView.addHeaderView(myHeader);
        indicatorIv = (ImageView) myHeader.findViewById(R.id.privacy_indicator);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Log.e("onListView", "click");
            }
        });

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

    @Override
    protected void onResume() {
        super.onResume();
    }

    private void setData() {

        List<InstalledApp> list = Storage.readAppList();
        list = sortList(list);

        setPrivacyScoreTv(list);
        setDataListView(list);
    }

    private List<InstalledApp> sortList(List<InstalledApp> list) {

        Collections.sort(list, new Comparator<InstalledApp>() {
            @Override
            public int compare(InstalledApp app1, InstalledApp app2) {
                if (app1.getPollutionScore() > app2.getPollutionScore())
                    return -1;
                else if (app1.getPollutionScore() < app2.getPollutionScore())
                    return 1;
                else
                    return 0;
            }
        });

        List<InstalledApp> copyList = new ArrayList<>(list);
        for(InstalledApp app: list){
            if (PermissionUtils.isOnWhiteList(app)){
                copyList.remove(app);
                copyList.add(app);
            }
        }
        return copyList;
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

        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                indicatorIv.clearAnimation();
                indicatorIv.setRotation(290 + rotationAngle);
            }
        }, 1700);

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

    private void reloadApps() {
        Storage.saveAppList(PermissionUtils.getApps(this, false));
        setData();
    }

    @Override
    public void onBackPressed() {
        finish();
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.scanner_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.facebook_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
        }
        switch (item.getItemId()) {
            case R.id.social_network_info:
                createInfoDialog();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void createInfoDialog() {

        LayoutInflater inflater = getLayoutInflater();
        View convertView = inflater.inflate(R.layout.scanner_info_dialog, null);

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setView(convertView);
        final AlertDialog dialog = builder.create();
        dialog.show();

        View closeIv = convertView.findViewById(R.id.fb_dialog_close_iv);
        TextView infoTv = (TextView) convertView.findViewById(R.id.installed_apps_info_tv);
        setSpannableString(infoTv);
        closeIv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
            }
        });
    }

    private void setSpannableString(TextView textview) {
        
        SpannableString ss = new SpannableString(textview.getText() + "   . ");
        Drawable d = getResources().getDrawable(R.drawable.privacy_oriented);
        d.setBounds(0, 0, 35, 35);
        ImageSpan span = new ImageSpan(d, ImageSpan.ALIGN_BASELINE);
        ss.setSpan(span, textview.getText().length() + 1, textview.getText().length() + 3, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        textview.setText(ss);
    }
}
