package eu.operando.fragment;


import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import org.greenrobot.eventbus.EventBus;

import eu.operando.BuildConfig;
import eu.operando.MainActivity;
import eu.operando.R;
import eu.operando.activity.BaseActivity;
import eu.operando.events.EventLoginPage;
import eu.operando.util.Constants;

/**
 * Created by raluca on 05.04.2016.
 */
public class FirstScreenFragment extends Fragment {

    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".MainFragment";

    RelativeLayout registerOrLogin;

    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_main, container, false);
        registerOrLogin = (RelativeLayout) v.findViewById(R.id.registerOrLoginRL);
        registerOrLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EventBus.getDefault().post(new EventLoginPage(Constants.events.LOGIN));
            }
        });
        v.findViewById(R.id.scan_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MainActivity) getActivity()).addFragment(R.id.main_fragment_container, new ScannerFragment(), "scan");
            }
        });
        v.findViewById(R.id.browser_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MainActivity) getActivity()).addFragment(R.id.main_fragment_container, new BrowserFragment(), "browse");
            }
        });
        return v;

    }


}
