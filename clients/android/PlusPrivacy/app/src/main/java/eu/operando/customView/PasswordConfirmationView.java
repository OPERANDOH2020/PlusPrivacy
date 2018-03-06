package eu.operando.customView;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ScaleDrawable;
import android.os.Build;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.utils.PasswordStrength;

import static android.content.Context.LAYOUT_INFLATER_SERVICE;
import static eu.operando.utils.PasswordStrength.ACCEPTABLE;
import static eu.operando.utils.PasswordStrength.STRONG;
import static eu.operando.utils.PasswordStrength.VERY_STRONG;
import static eu.operando.utils.PasswordStrength.WEAK;
import static eu.operando.utils.PasswordStrength.WHITE_SPACES;

/**
 * Created by Alex on 12/21/2017.
 */

public class PasswordConfirmationView extends LinearLayout {

    private final int SUCCESS_DRAWABLE = R.drawable.succes_match;
    private final int ERROR_DRAWABLE = R.drawable.error_match;
    private final int COLOR_EMPTY_INDICATOR = R.color.account_empty_indicator;

    private Context context;

    private EditText newPassword;
    private EditText confirmPassword;
    private RelativeLayout passwordStatesRl;
    private LinearLayout indicatorsLayout;
    private TextView strengthTv;
    private TextView passwordMatchTv;

    private PopupWindow popupWindow;
    private View customPopupView;

    public PasswordConfirmationView(Context context) {
        super(context);
        this.context = context;
        init("");
        setData();
    }

    public PasswordConfirmationView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        this.context = context;

        TypedArray a = context.obtainStyledAttributes(attrs,
                R.styleable.PasswordConfirmationView, 0, 0);
        String type = a.getString(R.styleable.PasswordConfirmationView_type);
        a.recycle();

        init(type);
        setData();
    }

    private void init(String type) {

        View rootView;
        if (type != null && type.equals("REGISTER")) {
            rootView = inflate(context, R.layout.password_confirmation_register, this);
        } else {
            rootView = inflate(context, R.layout.password_confirmation, this);
        }

        newPassword = (EditText) rootView.findViewById(R.id.new_password_et);
        confirmPassword = (EditText) rootView.findViewById(R.id.confirm_new_password_et);
        passwordStatesRl = (RelativeLayout) rootView.findViewById(R.id.password_states);
        indicatorsLayout = (LinearLayout) rootView.findViewById(R.id.password_strength);
        strengthTv = (TextView) rootView.findViewById(R.id.password_strength_tv);
        passwordMatchTv = (TextView) rootView.findViewById(R.id.match_validation_tv);

    }

    private void setData() {

//        pd = new ProgressDialog(UserAccountActivity.this);

        initPopupPasswordRules();
        setNewPasswordListener();
        setConfirmPasswordListener();
    }

    public void initPopupPasswordRules() {
        // Initialize a new instance of LayoutInflater service
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(LAYOUT_INFLATER_SERVICE);

        // Inflate the custom layout/view
        customPopupView = inflater.inflate(R.layout.custom_popup_window, null);

        popupWindow = new PopupWindow(
                customPopupView,
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
        );

        // Set an elevation value for popup window
        // Call requires API level 21
        if (Build.VERSION.SDK_INT >= 21) {
            popupWindow.setElevation(5.0f);
        }
    }

    public void showPopup() {

        customPopupView.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        int height = customPopupView.getMeasuredHeight();
        popupWindow.showAtLocation(newPassword, Gravity.CENTER_HORIZONTAL, 0, -newPassword.getHeight() - height);

    }

    public void hidePopup() {
        popupWindow.dismiss();
    }

    public Drawable getScaledDrawable(int drawableId) {

        Drawable drawable = getResources().getDrawable(drawableId);
        double scale = 0.2;
        if (drawableId == ERROR_DRAWABLE) {
            scale = 0.4;
        }
        drawable.setBounds(0, 0, (int) (drawable.getIntrinsicWidth() * scale),
                (int) (drawable.getIntrinsicHeight() * scale));
        ScaleDrawable scaledImg = new ScaleDrawable(drawable, 0, 10, 10);
        return scaledImg.getDrawable();
    }

    private void setNewPasswordListener() {

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
                    newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {
                int length = newPassword.getText().length();
                if (length < 6 && length > 0 && !popupWindow.isShowing()) {
                    showPopup();
                } else if (length >= 6 && popupWindow.isShowing()) {
                    PasswordStrength ps = new PasswordStrength(context, newPassword.getText().toString());
                    if (ps.hasLowerCaseLetters() && ps.hasUpperCaseLetters()) {
                        hidePopup();
                        newPassword.setCompoundDrawables(null, null, getScaledDrawable(SUCCESS_DRAWABLE), null);
                    }
                } else if (length == 0) {
                    hidePopup();
                }
            }
        });
        newPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if (!hasFocus) popupWindow.dismiss();
                if (!hasFocus && newPassword.getText().length() > 0 && newPassword.getText().length() < 6) {
                    newPassword.setCompoundDrawables(null, null, getScaledDrawable(ERROR_DRAWABLE), null);
                } else if (newPassword.getText().length() >= 6) {
                    newPassword.setCompoundDrawables(null, null, getScaledDrawable(SUCCESS_DRAWABLE), null);
                } else if (newPassword.getText().length() == 0) {
                    newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                }
            }
        });
    }

    private void updateStrengthUI(int result) {

        switch (result) {

            case WEAK:
                updateIndicators(R.color.weak_password, WEAK);
                break;

            case ACCEPTABLE:
                updateIndicators(R.color.acceptable_password, ACCEPTABLE);
                break;

            case STRONG:
                updateIndicators(R.color.strong_password, STRONG);
                break;

            case VERY_STRONG:
                updateIndicators(R.color.very_strong_password, VERY_STRONG);
                break;

            case WHITE_SPACES:

                break;
        }
    }

    private void updateIndicators(int color, int state) {

        for (int i = 0; i < indicatorsLayout.getChildCount(); ++i) {
            View child = indicatorsLayout.getChildAt(i);
            if (i < state) {
                child.setBackgroundColor(ContextCompat.getColor(context, color));
            } else {
                child.setBackgroundColor(ContextCompat.getColor(context, COLOR_EMPTY_INDICATOR));
            }
        }
    }

    private int checkForStrength(CharSequence charSequence) {

        PasswordStrength passwordStrength = new PasswordStrength(context, charSequence.toString());
        int state = passwordStrength.calculatePasswordStrength();
        strengthTv.setText(passwordStrength.getStringForState(state));

        return state;
    }

    private void setConfirmPasswordListener() {

        confirmPassword.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().length() == 0) {
                    passwordMatchTv.setVisibility(View.INVISIBLE);
                    confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                } else {
                    passwordMatchTv.setVisibility(View.VISIBLE);
                    if (newPassword.getText().toString().length() >= 6
                            && newPassword.getText().toString().equals(charSequence.toString())) {
                        passwordMatchTv.setText(R.string.match);
                        confirmPassword.setCompoundDrawables(null, null, getScaledDrawable(SUCCESS_DRAWABLE), null);
                    } else {
                        passwordMatchTv.setText(R.string.doesnt_match);
                        confirmPassword.setCompoundDrawables(null, null, getScaledDrawable(ERROR_DRAWABLE), null);
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    public String getNewPassword() {
        return newPassword.getText().toString();
    }

    public String getConfirmedPassword() {
        return confirmPassword.getText().toString();
    }

    public boolean match() {
        return getNewPassword().equals(getConfirmedPassword());
    }

    public void clearEditTextFields() {
        newPassword.setText("");
        confirmPassword.setText("");
        newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
        confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
    }
}
