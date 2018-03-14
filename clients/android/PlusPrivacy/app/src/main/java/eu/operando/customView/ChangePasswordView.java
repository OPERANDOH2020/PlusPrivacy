package eu.operando.customView;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Build;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.storage.Storage;

/**
 * Created by Alex on 12/21/2017.
 */

public class ChangePasswordView extends LinearLayout {

    private final int SUCCESS_DRAWABLE = R.drawable.succes_match;
    private final int ERROR_DRAWABLE = R.drawable.error_match;
    private final int COLOR_EMPTY_INDICATOR = R.color.account_empty_indicator;

    public interface ChangePasswordListener {
        void onUpdatePasswordClickListener(String currPass, String newPass);

        void onCancelClickListener();
    }

    private ChangePasswordListener listener;
    private Context context;

    private TextView cancelChangePassword;
    private EditText currentPassword;
    private TextView updatePassword;
    private PasswordConfirmationView passwordConfirmationView;


    public ChangePasswordView(Context context) {
        super(context);
        this.context = context;
        init();
        setData();
    }

    public ChangePasswordView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        init();
        setData();
    }

    public PasswordConfirmationView getPasswordConfirmationView() {
        return passwordConfirmationView;
    }

    private void init() {

        listener = (ChangePasswordListener) context;
        View rootView = inflate(context, R.layout.change_password, this);

        cancelChangePassword = (TextView) rootView.findViewById(R.id.cancel_change_password);
        currentPassword = (EditText) rootView.findViewById(R.id.current_password_et);
        updatePassword = (TextView) rootView.findViewById(R.id.update_password);
        updatePassword = (TextView) rootView.findViewById(R.id.update_password);
        passwordConfirmationView = (PasswordConfirmationView)
                rootView.findViewById(R.id.password_confirmation);
    }

    private void setData() {

        setCurrentPasswordListener();
        setOnUpdatePasswordClickListener();
        setOnCancelClickListener();
    }

    private void setOnUpdatePasswordClickListener() {

        updatePassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String currPass = currentPassword.getText().toString();
                String newPass = passwordConfirmationView.getNewPassword();
                listener.onUpdatePasswordClickListener(currPass, newPass);
            }
        });
    }

    public void setOnCancelClickListener() {

        cancelChangePassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                listener.onCancelClickListener();
                removeAllInputFromEditText();
            }
        });
    }

    private void setCurrentPasswordListener() {
        currentPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if (!hasFocus) {
                    if (currentPassword.getText().toString().length() == 0) {
                        currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);

                    } else {
                        currentPassword.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                if (Storage.readCredentials().second.equals(currentPassword.getText().toString())) {
                                    if (Build.VERSION.SDK_INT == Build.VERSION_CODES.LOLLIPOP || Build.VERSION.SDK_INT == Build.VERSION_CODES.LOLLIPOP_MR1) {
                                        currentPassword.setCompoundDrawables(null, null, passwordConfirmationView.getScaledDrawable(SUCCESS_DRAWABLE), null);
                                    } else {
                                        currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(null, null, passwordConfirmationView.getScaledDrawable(SUCCESS_DRAWABLE), null);
                                    }
                                } else {
                                    if (Build.VERSION.SDK_INT == Build.VERSION_CODES.LOLLIPOP) {
                                        currentPassword.setCompoundDrawables(null, null, passwordConfirmationView.getScaledDrawable(ERROR_DRAWABLE), null);
                                    } else {
                                        currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(null, null, passwordConfirmationView.getScaledDrawable(ERROR_DRAWABLE), null);
                                    }
                                }
                            }
                        }, 300);

                    }
                } else {
                    currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
                }
            }
        });
    }

    public void onPasswordChangedListener() {
        updatePassword.post(new Runnable() {
            @Override
            public void run() {
//                pd.hide();
                showOnPasswordChangedDialog();
                Storage.saveCredentials(Storage.readCredentials().first, passwordConfirmationView.getNewPassword());
                removeAllInputFromEditText();

            }
        });
    }

    private void showOnPasswordChangedDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
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

    private void removeAllInputFromEditText() {

        currentPassword.setText("");
        currentPassword.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);

        passwordConfirmationView.clearEditTextFields();
    }

}
