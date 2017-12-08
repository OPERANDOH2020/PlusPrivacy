package eu.operando.adapter;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.models.InstalledApp;
import eu.operando.utils.PermissionUtils;


/**
 * Created by Edy on 6/17/2016.
 */
public class PermissionsListAdapter extends ArrayAdapter<String> {
    public PermissionsListAdapter(Context context, ArrayList<String> objects) {
        super(context, android.R.layout.simple_list_item_1, objects);
    }

    @NonNull
    @Override
    public View getView(int position, View convertView, @NonNull ViewGroup parent) {

        if(convertView == null){
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.permission_item, parent,false);
        }

        String permission = getItem(position);
        String[] splitted = permission.split("\\.");
        String simplifiedPermission = splitted[splitted.length-1];
        ((TextView) convertView.findViewById(R.id.permission_tv)).setText(PermissionUtils.getPermissionDescription(simplifiedPermission));
//        convertView.findViewById(R.id.drawable_circle_indicator).setBackgroundColor(PermissionUtils.getPermissionColor(permission));

        GradientDrawable bgShape = (GradientDrawable)convertView
                .findViewById(R.id.drawable_circle_indicator).getBackground();
        bgShape.setColor(PermissionUtils.getPermissionColor(permission));

        return convertView;
    }

}
