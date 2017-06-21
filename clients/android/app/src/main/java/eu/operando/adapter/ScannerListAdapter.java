package eu.operando.adapter;

import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.support.v4.app.NavUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import eu.operando.R;
import eu.operando.model.InstalledApp;
import eu.operando.util.PermissionUtils;

/**
 * Created by Edy on 6/15/2016.
 */
public class ScannerListAdapter extends ArrayAdapter<InstalledApp> {
    public ScannerListAdapter(Context context, List<InstalledApp> objects) {
        super(context, R.layout.scanner_list_item, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.scanner_list_item, parent, false);
        }
        InstalledApp item = getItem(position);
        ((TextView) convertView.findViewById(R.id.app_name)).setText(item.getAppName());
        ((TextView) convertView.findViewById(R.id.app_package_name)).setText(item.getPackageName());
        Drawable d = null;
        try {
            d = getContext().getPackageManager().getApplicationIcon(item.getPackageName());
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        if (d != null) {
            ((ImageView) convertView.findViewById(R.id.app_icon)).setImageDrawable(d);
        }
        convertView.setBackgroundColor(PermissionUtils.computePrivacyPollution(item));
        return convertView;
    }


}
