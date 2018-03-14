package eu.operando.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ImageSpan;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import eu.operando.R;
import eu.operando.customView.ChangePasswordView;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import eu.operando.utils.PasswordStrength;

/**
 * Created by Alex on 12/14/2017.
 */

public class UserAccountActivity extends BaseActivity implements ChangePasswordView.ChangePasswordListener {

    private final int ANIMATION_DURATION = 500;

    private LinearLayout changeBtn;
    private LinearLayout deleteAccountBtn;
    private LinearLayout mainLayout;
    private TextView deleteTv;
    private RelativeLayout changePasswordCollapsed;
    private ChangePasswordView changePasswordExpanded;
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
        mainLayout = (LinearLayout) findViewById(R.id.main_layout);
        deleteTv = (TextView) findViewById(R.id.delete_account_tv);
        changePasswordCollapsed = (RelativeLayout) findViewById(R.id.change_password_rl);
        changePasswordExpanded = (ChangePasswordView) findViewById(R.id.change_password_expanded);

    }

    private void setData() {

        pd = new ProgressDialog(UserAccountActivity.this);
        setSpannableString(deleteTv);
        setOnChangeClickListener();
        setOnDeleteAccountClickListener();
    }


    @Override
    public void onUpdatePasswordClickListener(String currPass, String newPass) {
        PasswordStrength ps = new PasswordStrength(this, newPass);
        if (!currPass.equals(Storage.readCredentials().second)) {
            Toast.makeText(UserAccountActivity.this, R.string.update_password_err, Toast.LENGTH_SHORT).show();
        }
        else if (newPass.length() < 6 || ps.calculatePasswordStrength() < 2 ) {
            onInvalidPassword();
        } else {
            pd.show();
            SwarmService.getInstance().changePassword(currPass, newPass, new SwarmCallback<Swarm>() {
                @Override
                public void call(Swarm result) {
                    Log.e("passwordChanged", result.toString());
                    pd.cancel();
                    changePasswordExpanded.onPasswordChangedListener();
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            onCancelClickListener();
                        }
                    });
                }
            });
        }
    }

    private void onInvalidPassword() {

        changePasswordExpanded.getPasswordConfirmationView().showPopup();
        mainLayout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {

                changePasswordExpanded.getPasswordConfirmationView().hidePopup();
                mainLayout.setOnTouchListener(null);

                return false;
            }
        });
    }

    @Override
    public void onCancelClickListener() {
        collapse(changePasswordExpanded);
        changePasswordExpanded.postDelayed(new Runnable() {
            @Override
            public void run() {
                expand(changePasswordCollapsed);
                changePasswordExpanded.setVisibility(View.GONE);

            }
        }, ANIMATION_DURATION + 200);
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
                        });
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
