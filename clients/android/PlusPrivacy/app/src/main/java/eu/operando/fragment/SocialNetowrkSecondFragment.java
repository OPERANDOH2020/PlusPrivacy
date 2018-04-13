package eu.operando.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import eu.operando.R;
import eu.operando.adapter.SocialNetworkAccountsAdapter;

/**
 * Created by Alex on 11.04.2018.
 */

public class SocialNetowrkSecondFragment extends Fragment {

    private ListView listView;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View rootView = inflater.inflate(
                R.layout.social_network_second_fragment, container, false);

        listView = (ListView) rootView.findViewById(R.id.sn_accounts_list_view);
        listView.setAdapter(new SocialNetworkAccountsAdapter(getActivity(), R.layout.social_networks_account_item));

        return rootView;
    }
}