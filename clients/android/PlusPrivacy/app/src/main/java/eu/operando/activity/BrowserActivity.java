package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.design.widget.TabLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Pair;
import android.view.View;

import com.github.clans.fab.FloatingActionMenu;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.fragment.TabFragment;
import io.paperdb.Paper;

public class BrowserActivity extends AppCompatActivity {
    TabLayout tabLayout;
    ArrayList<TabLayout.Tab> tabs = new ArrayList<>();
    ArrayList<Pair<String, String>> urls = new ArrayList<>();
    TabFragment fragment;

    public static void start(Context context) {
        Intent starter = new Intent(context, BrowserActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browser2);
        tabLayout = ((TabLayout) findViewById(R.id.tabhost));
        tabs.add(tabLayout.newTab());
        tabLayout.addTab(tabs.get(0));
        urls.add(new Pair<>("assets.www.google.com", ""));

        fragment = TabFragment.newInstance("assets.www.google.com");
        fragment.setUrlLoadListener(new TabFragment.UrlLoadListener() {
            @Override
            public void onUrlLoaded(String title, String url) {
                tabs.get(tabLayout.getSelectedTabPosition()).setText(title);
                urls.set(tabLayout.getSelectedTabPosition(), new Pair<>(url, title));
            }
        });

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                fragment.loadUrl(urls.get(tabLayout.getSelectedTabPosition()).first);
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        getSupportFragmentManager().beginTransaction().add(R.id.container, fragment).commit();

        findViewById(R.id.fab_new_tab).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                newTab("assets.www.google.ro");
                ((FloatingActionMenu) findViewById(R.id.fab_menu)).close(true);
            }
        });

        findViewById(R.id.fab_close_tab).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int pos = tabLayout.getSelectedTabPosition();
                urls.remove(pos);
                tabs.remove(pos);
                tabLayout.removeTabAt(pos);
                ((FloatingActionMenu) findViewById(R.id.fab_menu)).close(true);
            }
        });

        fragment.setOnNewTabRequestListener(new TabFragment.OnNewTabRequestListener() {
            @Override
            public void onNewTabRequested(String url) {
                newTab(url);
            }
        });


    }

    private void newTab(String url) {
        TabLayout.Tab tab = tabLayout.newTab();
        tabs.add(tab);
        tabLayout.addTab(tab);
        urls.add(new Pair<>(url, ""));
        fragment.loadUrl(url);
        tab.select();
    }

    @Override
    protected void onPause() {
        super.onPause();
        Paper.book().write("urls", urls);
    }

    @Override
    protected void onResume() {
        super.onResume();
        ArrayList<Pair<String, String>> cached = Paper.book().read("urls");
        if (cached == null) return;
        if (cached.size() > 0) {
            urls.remove(0);
            tabs.remove(0);
            tabLayout.removeTabAt(0);
        }
        urls.addAll(cached);
        TabLayout.Tab tab = null;
        for (Pair<String, String> url : urls) {
            tab = tabLayout.newTab();
            tabLayout.addTab(tab);
            tabs.add(tab);
            tab.setText(url.second);
        }
        if (tab != null) {
            tab.select();
        }
    }
}
