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

/**
 * Created by Alex on 3/28/2018.
 */

public abstract class SocialNetworkBaseActivity extends BaseActivity {


    private TextView infoHeader;
    private Button snAccounts;

    private ImageView rotationDotFacebook;
    private ImageView rotationDotLinkedin;
    private ImageView rotationDotGoogle;
    private ImageView rotationDotTwitter;

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

        initSnCircles();

        infoHeader = (TextView) findViewById(R.id.info_header);
        infoHeader.setText(getStringDescriptionId());

        snAccounts = (Button) findViewById(R.id.sn_accounts_button);
        snAccounts.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(SocialNetworkBaseActivity.this,
                        SocialNetworkAccountsActivity.class));
            }
        });

    }

    private void initSnCircles() {

        RelativeLayout facebookLayout = (RelativeLayout) findViewById(R.id.facebook_settings);
        RelativeLayout linkedinLayout = (RelativeLayout) findViewById(R.id.linkedin_settings);
        RelativeLayout twitterLayout = (RelativeLayout) findViewById(R.id.twitter_settings);
        RelativeLayout googleLayout = (RelativeLayout) findViewById(R.id.google_settings);
        rotationDotFacebook = (ImageView) findViewById(R.id.rotation_dot_facebook);
        rotationDotLinkedin = (ImageView) findViewById(R.id.rotation_dot_linkedin);
        rotationDotGoogle = (ImageView) findViewById(R.id.rotation_dot_google);
        rotationDotTwitter = (ImageView) findViewById(R.id.rotation_dot_twitter);

        final SocialNetworkBaseActivity activity = this;
        facebookLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(SocialNetworkBaseActivity.this,
                        activity.facebookClass());
                startActivity(intent);
            }
        });

        linkedinLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(SocialNetworkBaseActivity.this,
                        activity.linkedinClass());
                startActivity(intent);
            }
        });

        twitterLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(SocialNetworkBaseActivity.this,
                        activity.twitterClass());
                startActivity(intent);
            }
        });

        googleLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(SocialNetworkBaseActivity.this,
                        activity.googleClass());
                startActivity(intent);
            }
        });

        fitHeightForWidth(facebookLayout);
        fitHeightForWidth(linkedinLayout);
        fitHeightForWidth(googleLayout);
        fitHeightForWidth(twitterLayout);

    }

    private void fitHeightForWidth(final RelativeLayout googleLayout) {
        googleLayout.post(new Runnable() {
            @Override
            public void run() {
                LinearLayout.LayoutParams mParams;
                mParams = (LinearLayout.LayoutParams) googleLayout.getLayoutParams();
                mParams.height = googleLayout.getWidth();
                googleLayout.setLayoutParams(mParams);
                googleLayout.postInvalidate();
            }
        });
    }

    private void rotateDot() {

        final int rotationAngle = 360;
        final RotateAnimation rotate = new RotateAnimation(0, rotationAngle,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                2.4f);
        rotate.setDuration(10000);
        rotate.setRepeatCount(Animation.INFINITE);
        rotate.setInterpolator(new LinearInterpolator());

        Handler handler = new Handler();
        handler.post(new Runnable() {
            @Override
            public void run() {
                rotationDotFacebook.startAnimation(rotate);
                rotationDotLinkedin.startAnimation(rotate);
                rotationDotGoogle.startAnimation(rotate);
                rotationDotTwitter.startAnimation(rotate);
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        rotateDot();
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

}
