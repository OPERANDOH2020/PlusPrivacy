package eu.operando.adapter;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import eu.operando.fragment.SocialNetowrkSecondFragment;
import eu.operando.fragment.SocialNetworksFragment;

/**
 * Created by Alex on 11.04.2018.
 */

public class ViewPagerAdapter extends FragmentPagerAdapter {
    public ViewPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {

        Fragment fragment = null;

        switch(position) {
            case 0:
                fragment = new SocialNetworksFragment();
                break;
            case 1:
                fragment = new SocialNetowrkSecondFragment();
                break;

        }
        return fragment;
    }

    @Override
    public int getCount() {
        return 2;
    }
}
