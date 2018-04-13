package eu.operando.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import eu.operando.R;
import eu.operando.activity.SocialNetworkBaseActivity;

/**
 * Created by Alex on 11.04.2018.
 */

public class SocialNetworksFragment extends Fragment {

    private ImageView rotationDotFacebook;
    private ImageView rotationDotLinkedin;
    private ImageView rotationDotGoogle;
    private ImageView rotationDotTwitter;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(
                R.layout.social_networks_first_fragment, container, false);
        initSnCircles(rootView);

        return rootView;
    }

    private void initSnCircles(View rootView) {

        RelativeLayout facebookLayout = (RelativeLayout) rootView.findViewById(R.id.facebook_settings);
        RelativeLayout linkedinLayout = (RelativeLayout) rootView.findViewById(R.id.linkedin_settings);
        RelativeLayout twitterLayout = (RelativeLayout) rootView.findViewById(R.id.twitter_settings);
        RelativeLayout googleLayout = (RelativeLayout) rootView.findViewById(R.id.google_settings);
        rotationDotFacebook = (ImageView) rootView.findViewById(R.id.rotation_dot_facebook);
        rotationDotLinkedin = (ImageView) rootView.findViewById(R.id.rotation_dot_linkedin);
        rotationDotGoogle = (ImageView) rootView.findViewById(R.id.rotation_dot_google);
        rotationDotTwitter = (ImageView) rootView.findViewById(R.id.rotation_dot_twitter);

        final SocialNetworkBaseActivity activity = (SocialNetworkBaseActivity) getActivity();
        facebookLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getActivity(),
                        activity.facebookClass());
                startActivity(intent);
            }
        });

        linkedinLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getActivity(),
                        activity.linkedinClass());
                startActivity(intent);
            }
        });

        twitterLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getActivity(),
                        activity.twitterClass());
                startActivity(intent);
            }
        });

        googleLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getActivity(),
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
}