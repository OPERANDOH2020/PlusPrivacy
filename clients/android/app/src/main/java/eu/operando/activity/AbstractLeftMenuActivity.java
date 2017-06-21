package eu.operando.activity;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.view.Gravity;
import android.view.MenuItem;

import eu.operando.util.OnBackPressedListener;

/**
 * Created by raluca on 08.04.2016.
 */
public class AbstractLeftMenuActivity  extends  BaseActivity{
    public static final int SIGNINGS = 1;
    public static final int INVOICES = 2;
    public static final int SETTINGS = 3;
    public static final int PROFILE = 4;
    public static final int UPS = 5;
    public static final int TUTORIALS = 6;

    private DrawerLayout mDrawerLayout;
    private ActionBarDrawerToggle mDrawerToggle;
    private int menuMode;
    private OnBackPressedListener onBackPressedListener;


    @Override protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }


    @Override public boolean onOptionsItemSelected(MenuItem item) {
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        mDrawerToggle.syncState();
    }

    @Override public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }

    @Override public void onBackPressed() {
        if (mDrawerLayout.isDrawerOpen(Gravity.START | Gravity.LEFT)) {
            mDrawerLayout.closeDrawers();
            return;
        }
        if(onBackPressedListener!=null){
            if(onBackPressedListener.onBackPressed()){
               return;
            }
        }
        if(getFragmentManager().getBackStackEntryCount() > 0){
            getFragmentManager().popBackStack();
            return;
        }
        super.onBackPressed();


    }

    protected void setComponents(ActionBarDrawerToggle drawerToggle, DrawerLayout drawerLayout, int menuMode) {
        this.mDrawerLayout = drawerLayout;
        this.mDrawerToggle = drawerToggle;
        this.menuMode = menuMode;
    }

    public void setOnBackPressedListener(OnBackPressedListener onBackPressedListener) {
        this.onBackPressedListener = onBackPressedListener;
    }
}
