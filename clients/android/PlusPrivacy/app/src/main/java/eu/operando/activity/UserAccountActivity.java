package eu.operando.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextWatcher;
import android.text.style.ImageSpan;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import eu.operando.R;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
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
    private final int SUCCES_DRAWABLE = R.drawable.succes_match;
    private final int ERROR_DRAWABLE = R.drawable.error_match;
    private final int COLOR_EMPTY_INDICATOR = R.color.account_empty_indicator;

    private LinearLayout changeBtn;
    private LinearLayout deleteAccountBtn;
    private TextView deleteTv;
    private RelativeLayout changePasswordCollapsed;
    private LinearLayout changePasswordExpanded;
    private TextView cancelChangePassword;
    private EditText currentPassword;
    private EditText newPassword;
    private EditText confirmPassword;
    private TextView updatePassword;

    private RelativeLayout passwordStatesRl;
    private LinearLayout indicatorsLayout;
    private TextView strengthTv;
    private TextView passwordMatchTv;

    private PopupWindow popupWindow;
    private View customPopupView;

    private ProgressDialog pd;

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
        updatePassword = (TextView) findViewById(R.id.update_password);

        passwordStatesRl = (RelativeLayout) findViewById(R.id.password_states);
        indicatorsLayout = (LinearLayout) findViewById(R.id.password_strength);
        strengthTv = (TextView) findViewById(R.id.password_strength_tv);
        passwordMatchTv = (TextView) findViewById(R.id.match_validation_tv);

    }

    private void setData() {

        pd = new ProgressDialog(UserAccountActivity.this);
        setSpannableString(deleteTv);
        setOnChangeClickListener();
        setCurrentPasswordListener();
        initPopupPasswordRules();
        setNewPasswordListener();
        setConfirmPasswordListener();
        setOnUpdatePasswordClickListener();
        setOnDeleteAccountClickListener();
    }

    private void setOnDeleteAccountClickListener() {
        deleteAccountBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                AlertDialog.Builder builder = new AlertDialog.Builder(UserAccountActivity.this);
                builder.setTitle(R.string.delete_account)
                        .setMessage(R.string.delete_account_question)
                        .setPositiveButton(R.string.action_yes, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                dialog.dismiss();

                                pd.show();
                                SwarmService.getInstance().deleteAccount(new SwarmCallback<Swarm>() {
                                    @Override
                                    public void call(Swarm result) {
                                        onDeleteAccount();
                                    }
                                });
                            }
                        })
                        .setNegativeButton(R.string.action_no, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                dialogInterface.dismiss();
                            }
                        })
                ;
                // Create the AlertDialog object and return it
                builder.create().show();
            }
        });
    }

    private void onDeleteAccount() {

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pd.hide();
                AlertDialog.Builder builder = new AlertDialog.Builder(UserAccountActivity.this);
                builder.setTitle(R.string.delete_account)
                        .setMessage(R.string.delete_account_confirmation)
                        .setPositiveButton(R.string.action_ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                Storage.clearData();
                                startActivity(new Intent(UserAccountActivity.this, LoginActivity.class));
                            }
                        })
                        .setCancelable(false);
                ;
                builder.create().show();
            }
        });
    }

    private void setOnUpdatePasswordClickListener() {

        updatePassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String currPass = currentPassword.getText().toString();
                String newPass = newPassword.getText().toString();
                if (currPass.equals(Storage.readCredentials().second) && newPass.length() >= 6) {
                    pd.show();
                    SwarmService.getInstance().changePassword(currPass, newPass, new SwarmCallback<Swarm>() {
                        @Override
                        public void call(Swarm result) {
                            Log.e("passwordChanged", result.toString());

                            onPasswordChangedListener();
                        }
                    });
                } else {
                    Toast.makeText(UserAccountActivity.this, R.string.update_password_err, Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void onPasswordChangedListener() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pd.hide();
                showOnPasswordChangedDialog();
                removeAllInputFromEditText();
                Storage.saveCredentials(Storage.readCredentials().first, newPassword.getText().toString());
            }
        });
    }

    private void showOnPasswordChangedDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(UserAccountActivity.this);
        builder.setTitle(R.string.password_changed)
                .setMessage(R.string.password_changed_confirmation)
                .setPositiveButton(R.string.action_ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                })
        ;
        builder.create().show();
    }

    private void setCurrentPasswordListener() {
        currentPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if (!hasFocus) {
                    if (currentPassword.getText().toString().length() == 0) {
                        currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                    } else {
                        if (Storage.readCredentials().second.equals(currentPassword.getText().toString())) {
                            currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, SUCCES_DRAWABLE, 0);
                        } else {
                            currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, ERROR_DRAWABLE, 0);
                        }
                    }
                } else {
                    currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                }
            }
        });
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
                        confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, SUCCES_DRAWABLE, 0);
                    } else {
                        passwordMatchTv.setText(R.string.doesnt_match);
                        confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, ERROR_DRAWABLE, 0);
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
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
                    hidePopup();
                    newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, SUCCES_DRAWABLE, 0);
                } else if (length == 0) {
                    hidePopup();
                }
            }
        });
        newPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if (!hasFocus && newPassword.getText().length() > 0 && newPassword.getText().length() < 6) {
                    newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, ERROR_DRAWABLE, 0);
                } else if (newPassword.getText().length() >= 6) {
                    newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, SUCCES_DRAWABLE, 0);
                } else if (newPassword.getText().length() == 0) {
                    newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                }
            }
        });
    }

    public void initPopupPasswordRules() {
        // Initialize a new instance of LayoutInflater service
        LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);

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
                child.setBackgroundColor(ContextCompat.getColor(this, color));
            } else {
                child.setBackgroundColor(ContextCompat.getColor(this, COLOR_EMPTY_INDICATOR));
            }
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

                popupWindow.dismiss();
                collapse(changePasswordExpanded);
                changePasswordExpanded.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        expand(changePasswordCollapsed);
                        changePasswordExpanded.setVisibility(View.GONE);
                        removeAllInputFromEditText();
                    }
                }, ANIMATION_DURATION + 200);
            }
        });
    }

    private void removeAllInputFromEditText() {

        currentPassword.setText("");
        newPassword.setText("");
        confirmPassword.setText("");

        currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
        newPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
        confirmPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
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
