package eu.operando.adapter;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import eu.operando.R;
import eu.operando.activity.PermissionsActivity;
import eu.operando.activity.ScannerActivity;
import eu.operando.models.InstalledApp;
import eu.operando.utils.PermissionUtils;

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
        final InstalledApp item = getItem(position);
        ((TextView) convertView.findViewById(R.id.app_name)).setText(item.getAppName());
        String poll = "Privacy Pollution: " + item.getPollutionScore() + "/10";
        ((TextView) convertView.findViewById(R.id.app_package_name)).setText(poll);
        Drawable d = null;
        try {
            d = getContext().getPackageManager().getApplicationIcon(item.getPackageName());
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        if (d != null) {
            ((ImageView) convertView.findViewById(R.id.app_icon)).setImageDrawable(d);
        }
        convertView.setBackgroundColor(PermissionUtils.getColor(item));
        convertView.findViewById(R.id.eye_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getContext(), PermissionsActivity.class);
                i.putExtra("perms", item.getPermissions());
                ((ScannerActivity)getContext()).infoClicked();
                getContext().startActivity(i);
            }
        });
        convertView.findViewById(R.id.trash_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_DELETE);
                intent.setData(Uri.parse("package:" + item.getPackageName()));
                getContext().startActivity(intent);
            }
        });
        return convertView;
    }


}
