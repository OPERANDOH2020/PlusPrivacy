package eu.operando.fragment;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import at.grabner.circleprogress.CircleProgressView;
import eu.operando.R;
import eu.operando.adapter.ScannerListAdapter;
import eu.operando.model.InstalledApp;
import eu.operando.util.PermissionUtils;

/**
 * Created by Edy on 6/14/2016.
 */
public class ScannerFragment extends Fragment {
    CircleProgressView spinner;
    View rootView;
    ArrayList<InstalledApp> apps;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_scanner, container, false);
        spinner = (CircleProgressView) rootView.findViewById(R.id.circle_progress_view);
        spinner.setStartAngle(270);
        spinner.setSpinSpeed(1);
        spinner.setValue(0);
        new LoadingAsyncTask().execute();
        getActivity().setTitle("Application Scanner");
        return rootView;
    }

    private void showList() throws PackageManager.NameNotFoundException {
        if (!isAdded()) return;
        ListView listView = (ListView) rootView.findViewById(R.id.app_list_view);
        spinner.setVisibility(View.GONE);
        listView.setVisibility(View.VISIBLE);
        ScannerListAdapter adapter = new ScannerListAdapter(getActivity(), apps, this);
        listView.setAdapter(adapter);
    }



    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 101) {
            try {
                apps = PermissionUtils.getApps(getActivity(),false);
                showList();
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    class LoadingAsyncTask extends AsyncTask<Void, Void, Void> {
        int i = 0;
        Random random = new Random();

        @Override
        protected Void doInBackground(Void... params) {
            try {
                apps = PermissionUtils.getApps(getActivity(),false);
                while (i < 100) {
                    Thread.sleep(random.nextInt(3) * 40);
                    publishProgress();
                }
                Thread.sleep(1000);
            } catch (InterruptedException | PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onProgressUpdate(Void... values) {
            super.onProgressUpdate(values);
            i += new Random().nextInt(15) + 1;
            if (i > 100) {
                spinner.setValueAnimated(100);
                return;
            }
            spinner.setValueAnimated(i);
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            try {
                showList();
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

}
