package eu.operando.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextWatcher;
import android.text.style.ImageSpan;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import eu.operando.R;
import eu.operando.utils.PasswordStrength;

import static eu.operando.utils.PasswordStrength.ACCEPTABLE;
import static eu.operando.utils.PasswordStrength.STRONG;
import static eu.operando.utils.PasswordStrength.VERY_STRONG;
import static eu.operando.utils.PasswordStrength.WEAK;
import static eu.operando.utils.PasswordStrength.WHITE_SPACES;

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
    private EditText currentPassword;
    private EditText newPassword;
    private EditText confirmPassword;
    private RelativeLayout passwordStatesRl;

    private View firstStrengthIndicator;
    private View secondStrengthIndicator;
    private View thirdStrengthIndicator;
    private View fourthStrengthIndicator;
    private TextView strengthTv;
    private TextView passwordMatchTv;

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
        setData();
    }

    private void initUI() {

        setToolbar();
        changeBtn = (LinearLayout) findViewById(R.id.change_btn);
        deleteAccountBtn = (LinearLayout) findViewById(R.id.delete_account_btn);
        deleteTv = (TextView) findViewById(R.id.delete_account_tv);
        changePasswordCollapsed = (RelativeLayout) findViewById(R.id.change_password_rl);
        changePasswordExpanded = (LinearLayout) findViewById(R.id.change_password_expanded);
        cancelChangePassword = (TextView) findViewById(R.id.cancel_change_password);
        currentPassword = (EditText) findViewById(R.id.current_password_et);
        newPassword = (EditText) findViewById(R.id.new_password_et);
        confirmPassword = (EditText) findViewById(R.id.confirm_new_password_et);

        passwordStatesRl = (RelativeLayout) findViewById(R.id.password_states);
        firstStrengthIndicator = findViewById(R.id.first_strength_indicator);
        secondStrengthIndicator = findViewById(R.id.second_strength_indicator);
        thirdStrengthIndicator = findViewById(R.id.third_strength_indicator);
        fourthStrengthIndicator = findViewById(R.id.fourth_strength_indicator);
        strengthTv = (TextView) findViewById(R.id.password_strength_tv);
        passwordMatchTv = (TextView) findViewById(R.id.match_validation_tv);

    }

    private void setData() {

        setSpannableString(deleteTv);
        setOnChangeClickListener();
        newPassword.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int start, int before, int count) {

                int length = charSequence.toString().length();
                if (length == 0) {
                    passwordStatesRl.setVisibility(View.INVISIBLE);
                } else {
                    passwordStatesRl.setVisibility(View.VISIBLE);
                    int result = checkForStrength(charSequence);
                    updateStrengthUI(result);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {
            }
        });
        confirmPassword.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().length() == 0){
                    passwordMatchTv.setVisibility(View.INVISIBLE);
                    confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                } else {
                    passwordMatchTv.setVisibility(View.VISIBLE);
                }
                if (newPassword.getText().toString().length() >= 6
                        && newPassword.getText().toString().equals(charSequence.toString())){
                    passwordMatchTv.setText(R.string.match);
                    confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, R.drawable.succes_match, 0);
                    confirmPassword.setCompoundDrawablePadding(10);
                } else {
                    passwordMatchTv.setText(R.string.doesnt_match);
                    confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, R.drawable.error_match, 0);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    private void updateStrengthUI(int result) {

        switch (result) {

            case WEAK:
                firstStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.weak_password));
                secondStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.account_empty_indicator));
                thirdStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.account_empty_indicator));
                fourthStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.account_empty_indicator));

                break;

            case ACCEPTABLE:
                firstStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.acceptable_password));
                secondStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.acceptable_password));
                thirdStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.account_empty_indicator));
                fourthStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.account_empty_indicator));
                break;

            case STRONG:
                firstStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.strong_password));
                secondStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.strong_password));
                thirdStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.strong_password));
                fourthStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.account_empty_indicator));
                break;

            case VERY_STRONG:
                firstStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.very_strong_password));
                secondStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.very_strong_password));
                thirdStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.very_strong_password));
                fourthStrengthIndicator.setBackgroundColor(ContextCompat.getColor(this, R.color.very_strong_password));
                break;

            case WHITE_SPACES:

                break;
        }
    }

    private int checkForStrength(CharSequence charSequence) {

        PasswordStrength passwordStrength = new PasswordStrength(this);
        passwordStrength.setPassword(charSequence.toString());
        int state = passwordStrength.calculatePasswordStrength();
        strengthTv.setText(passwordStrength.getStringForState(state));

        return state;
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
