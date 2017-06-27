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

import eu.operando.MainActivity;
import eu.operando.R;
import eu.operando.activity.IdentitiesActivity;
import eu.operando.activity.NotificationsActivity;
import eu.operando.activity.PFBActivity;
import eu.operando.activity.SensorsActivity;
import eu.operando.events.EventScanPage;
import eu.operando.events.EventSignIn;
import eu.operando.proxy.MainProxyActivity;
import eu.operando.util.SharedPreferencesService;

/**
 * Created by raluca on 08.04.2016.
 */
public class DrawerFragment extends Fragment {

    TextView emailTV;

    private ActionBarDrawerToggle mDrawerToggle;
    private DrawerLayout mDrawerLayout;
    private String mActivityTitle;

    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_navigation_drawer, container, false);
        initUI(v);
        return v;
    }

    private void initUI(View v) {
        emailTV = (TextView) v.findViewById(R.id.emailTV);
        v.findViewById(R.id.scanner).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EventBus.getDefault().post(new EventScanPage());
            }
        });

        v.findViewById(R.id.privateBrowsing).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MainActivity) getActivity()).addFragment(R.id.main_fragment_container, new BrowserFragment(), "browse");
                ((MainActivity) getActivity()).getmDrawerLayout().closeDrawers();
            }
        });
        v.findViewById(R.id.dataLeak).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainProxyActivity.start(getActivity());
            }
        });
        v.findViewById(R.id.notifications).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                NotificationsActivity.start(getActivity());
            }
        });
        v.findViewById(R.id.sensorMonitoring).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                SensorsActivity.start(getActivity());
            }
        });
        v.findViewById(R.id.identities).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                IdentitiesActivity.start(getActivity());
            }
        });
        v.findViewById(R.id.pfb).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PFBActivity.start(getActivity());
            }
        });
    }

    @Subscribe
    public void onEvent(EventSignIn event) {
        emailTV.setText(SharedPreferencesService.getInstance(getActivity()).getUserEmail());
    }

}
