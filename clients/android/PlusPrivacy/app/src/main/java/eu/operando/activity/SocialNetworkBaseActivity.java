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
import eu.operando.models.privacysettings.OspSettings;

/**
 * Created by Alex on 3/28/2018.
 */

public abstract class SocialNetworkBaseActivity extends BaseActivity {

    private ImageView rotationDotFacebook;
    private ImageView rotationDotLinkedin;
    private ImageView rotationDotGoogle;
    private ImageView rotationDotTwitter;

    public abstract Class facebookClass();

    public abstract Class linkedinClass();

    public abstract Class twitterClass();

    public abstract Class googleClass();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_social_network_settings);
        initUI();

//        new RequestTask().execute("https://plusprivacy.com");
    }

    private void initUI() {

        Toolbar myToolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(myToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        RelativeLayout facebookLayout = (RelativeLayout) findViewById(R.id.facebook_settings);
        RelativeLayout linkedinLayout = (RelativeLayout) findViewById(R.id.linkedin_settings);
        RelativeLayout twitterLayout = (RelativeLayout) findViewById(R.id.twitter_settings);
        RelativeLayout googleLayout = (RelativeLayout) findViewById(R.id.google_settings);
        rotationDotFacebook = (ImageView) findViewById(R.id.rotation_dot_facebook);
        rotationDotLinkedin = (ImageView) findViewById(R.id.rotation_dot_linkedin);
        rotationDotGoogle = (ImageView) findViewById(R.id.rotation_dot_google);
        rotationDotTwitter = (ImageView) findViewById(R.id.rotation_dot_twitter);

        facebookLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(),
                        facebookClass());
                startActivity(intent);
            }
        });

        linkedinLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(),
                        linkedinClass());
                startActivity(intent);
            }
        });

        twitterLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(),
                        twitterClass());
                startActivity(intent);
            }
        });

        googleLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(),
                        googleClass());
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
    protected void onResume() {
        super.onResume();
        rotateDot();
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

}
