package eu.operando.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import eu.operando.R;

/**
 * Created by Alex on 12/12/2017.
 */

public class SocialNetworkPrivacySettingsActivity extends BaseActivity {

    private ImageView rotationDot;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_social_network_settings);
        initUI();
    }

    private void initUI() {

        Toolbar myToolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(myToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        RelativeLayout facebookLayout = (RelativeLayout) findViewById(R.id.facebook_settings);
        RelativeLayout linkedinLayout = (RelativeLayout) findViewById(R.id.linkedin_settings);
        RelativeLayout twitterLayout = (RelativeLayout) findViewById(R.id.twitter_settings);
        RelativeLayout googleLayout = (RelativeLayout) findViewById(R.id.google_settings);
        rotationDot = (ImageView) findViewById(R.id.rotation_dot);

        facebookLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(SocialNetworkPrivacySettingsActivity.this,
                        FacebookSettingsActivity.class));
            }
        });

        linkedinLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(SocialNetworkPrivacySettingsActivity.this,
                        LinkedinSettingsActivity.class));
            }
        });

        twitterLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(SocialNetworkPrivacySettingsActivity.this,
                        TwitterSettingsActivity.class));
            }
        });

        googleLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(SocialNetworkPrivacySettingsActivity.this,
                        GoogleSettingsActivity.class));
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

    private void rotateIndicator() {

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
                rotationDot.startAnimation(rotate);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        rotateIndicator();
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

}
