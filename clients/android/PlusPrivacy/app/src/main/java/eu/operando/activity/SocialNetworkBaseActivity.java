package eu.operando.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.adapter.ViewPagerAdapter;

/**
 * Created by Alex on 3/28/2018.
 */

public abstract class SocialNetworkBaseActivity extends BaseActivity {


    private TextView infoHeader;
    private Button snAccounts;
    private ViewPager viewPager;

    public abstract Class facebookClass();

    public abstract Class linkedinClass();

    public abstract Class twitterClass();

    public abstract Class googleClass();

    public abstract int getStringTitleId();

    public abstract int getStringDescriptionId();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_social_network_settings);
        initUI();

    }

    private void initUI() {

        Toolbar myToolbar = (Toolbar) findViewById(R.id.toolbar);
        myToolbar.setTitle(getStringTitleId());
        setSupportActionBar(myToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        infoHeader = (TextView) findViewById(R.id.info_header);
        infoHeader.setText(getStringDescriptionId());

        viewPager = (ViewPager) findViewById(R.id.pager);
        viewPager.setAdapter(new ViewPagerAdapter(getSupportFragmentManager()));
        snAccounts = (Button) findViewById(R.id.sn_accounts_button);
        snAccounts.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                viewPager.setCurrentItem((viewPager.getCurrentItem() + 1) % 2);
            }
        });


    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

}
