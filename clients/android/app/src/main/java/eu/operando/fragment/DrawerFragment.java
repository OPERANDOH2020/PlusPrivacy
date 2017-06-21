package eu.operando.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import eu.operando.R;
import eu.operando.activity.BaseActivity;
import eu.operando.events.EventLoginPage;
import eu.operando.events.EventScanPage;
import eu.operando.events.EventSignIn;
import eu.operando.util.SharedPreferencesService;

/**
 * Created by raluca on 08.04.2016.
 */
public class DrawerFragment extends Fragment {

    TextView emailTV ;

    private ActionBarDrawerToggle mDrawerToggle;
    private DrawerLayout mDrawerLayout;
    private String mActivityTitle;

    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_navigation_drawer, container, false);
        initUI (v);
        return v;
    }

    private void initUI (View v){
        emailTV = (TextView) v.findViewById(R.id.emailTV);
        v.findViewById(R.id.scanner).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EventBus.getDefault().post(new EventScanPage());
            }
        });
    }

    @Subscribe
    public void onEvent (EventSignIn event ) {
        emailTV.setText(SharedPreferencesService.getInstance(getActivity()).getUserEmail());
    }

}
