package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ImageSpan;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import eu.operando.R;

/**
 * Created by Alex on 12/14/2017.
 */

public class UserAccountActivity extends BaseActivity {

    private final int ANIMATION_DURATION = 500;
    private LinearLayout changeBtn;
    private LinearLayout deleteAccountBtn;
    private TextView deleteTv;
    private RelativeLayout changePasswordCollapsed;
    private LinearLayout changePasswordExpanded;
    private TextView cancelChangePassword;

    public static void start(Context context) {

        Intent starter = new Intent(context, UserAccountActivity.class);
        context.startActivity(starter);
        ((Activity) context).overridePendingTransition(R.anim.fade_in, R.anim.fade_out);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_account);
        initUI();
    }

    private void initUI() {

        setToolbar();
        changeBtn = (LinearLayout) findViewById(R.id.change_btn);
        deleteAccountBtn = (LinearLayout) findViewById(R.id.delete_account_btn);
        deleteTv = (TextView) findViewById(R.id.delete_account_tv);
        changePasswordCollapsed = (RelativeLayout) findViewById(R.id.change_password_rl);
        changePasswordExpanded = (LinearLayout) findViewById(R.id.change_password_expanded);
        cancelChangePassword = (TextView) findViewById(R.id.cancel_change_password);

        setSpannableString(deleteTv);
        setOnChangeClickListener();
    }

    private void setOnChangeClickListener() {
        changeBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                collapse(changePasswordCollapsed);
                changePasswordCollapsed.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        expand(changePasswordExpanded);
                        changePasswordCollapsed.setVisibility(View.GONE);
                    }
                }, ANIMATION_DURATION + 200);

            }
        });
        cancelChangePassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                collapse(changePasswordExpanded);
                changePasswordExpanded.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        expand(changePasswordCollapsed);
                        changePasswordExpanded.setVisibility(View.GONE);
                    }
                }, ANIMATION_DURATION + 200);
            }
        });
    }

    public void collapse(final View v) {

        final int initialHeight = v.getMeasuredHeight();

        Animation a = new Animation() {
            @Override
            protected void applyTransformation(float interpolatedTime, Transformation t) {
//                if (interpolatedTime == 1) {
//                    v.setVisibility(View.GONE);
//                } else {
                    v.getLayoutParams().height = initialHeight - (int) (initialHeight * interpolatedTime);
                    v.requestLayout();
//                }
            }

            @Override
            public boolean willChangeBounds() {
                return true;
            }
        };

        a.setDuration(ANIMATION_DURATION);
        v.startAnimation(a);
    }

    public void expand(final View v) {

        v.measure(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        final int targetHeight = v.getMeasuredHeight();

        // Older versions of android (pre API 21) cancel animations for views with a height of 0.
        v.getLayoutParams().height = 1;
        v.setVisibility(View.VISIBLE);
        Animation a = new Animation() {
            @Override
            protected void applyTransformation(float interpolatedTime, Transformation t) {
                v.getLayoutParams().height = (int) (targetHeight * interpolatedTime);
                v.requestLayout();
            }

            @Override
            public boolean willChangeBounds() {
                return true;
            }
        };

        // 1dp/ms
//        a.setDuration((int) (targetHeight / v.getContext().getResources().getDisplayMetrics().density));
        a.setDuration(ANIMATION_DURATION);
        v.startAnimation(a);
    }

    private void setSpannableString(TextView textview) {
        SpannableString ss = new SpannableString("  " + textview.getText());
        Drawable d = getResources().getDrawable(R.drawable.info_account_dl);
        d.setBounds(0, 1, d.getIntrinsicWidth(), d.getIntrinsicHeight());
        ImageSpan span = new ImageSpan(d, ImageSpan.ALIGN_BASELINE);
        ss.setSpan(span, 0, 1, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        textview.setText(ss);
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    private void setToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

}
