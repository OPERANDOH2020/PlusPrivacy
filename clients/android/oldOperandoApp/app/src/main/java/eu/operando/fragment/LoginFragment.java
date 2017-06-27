package eu.operando.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.greenrobot.eventbus.EventBus;

import eu.operando.BuildConfig;
import eu.operando.R;
import eu.operando.events.EventLoginPage;
import eu.operando.events.EventSignIn;
import eu.operando.util.Constants;
import eu.operando.util.SharedPreferencesService;

/**
 * Created by raluca on 05.04.2016.
 */
public class LoginFragment extends Fragment {

    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".LoginFragment";

    RelativeLayout createAccoutRL ;
    EditText emailET , passwordET;
    Button signIn;
    TextView forgotPassword;


    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_login, container, false);
        initUI (v);
        return v;
    }

    private void initUI (View view){

        createAccoutRL = (RelativeLayout) view.findViewById(R.id.createAnAccountRL);
        emailET = (EditText) view.findViewById(R.id.emailET);
        passwordET = (EditText) view.findViewById(R.id.passwordET);
        signIn = (Button) view.findViewById(R.id.signInBut);
        forgotPassword = (TextView) view.findViewById(R.id.forgotPasswordTV);

        signIn.setEnabled(false);

        setChangeListenersForEditText(emailET, passwordET);
        setChangeListenersForEditText(passwordET, emailET);

        createAccoutRL.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                EventBus.getDefault().post(new EventLoginPage(Constants.events.CREATE_ACCOUNT));
            }
        });

        signIn.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                SharedPreferencesService.getInstance(getActivity()).setUserEmail(emailET.getText().toString());
                EventBus.getDefault().post(new EventSignIn(emailET.getText().toString(), passwordET.getText().toString()));
            }
        });

    }

    private void setSignInEnabled  (boolean isEnabled,  int color ){
        signIn.setEnabled(isEnabled);
        signIn.setBackgroundColor(color);
    }

    private void setChangeListenersForEditText (EditText mainEt, final EditText secondaryEt){
        mainEt.addTextChangedListener(new TextWatcher() {

            @Override
            public void afterTextChanged(Editable s) {
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start,
                                          int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start,
                                      int before, int count) {
                if (s.length() != 0&&secondaryEt.getText()!=null&&secondaryEt.getText().toString().length()>0){
                    setSignInEnabled(true, getResources().getColor(R.color.lightOrange));
                }
                else {
                    setSignInEnabled(true, getResources().getColor(R.color.darkGray));
                }

            }
        });


    }
}
