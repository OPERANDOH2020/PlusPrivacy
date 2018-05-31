package eu.operando.adapter;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.models.InstalledApp;
import eu.operando.utils.PermissionUtils;


/**
 * Created by Edy on 6/17/2016.
 */
public class PermissionsListAdapter extends ArrayAdapter<String> {

    private int colorId;
    private Context context;

    public PermissionsListAdapter(Context context, ArrayList<String> objects, int colorId) {
        super(context, android.R.layout.simple_list_item_1, objects);
        this.colorId = colorId;
        this.context = context;
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
        TextView permissionTv = (TextView) convertView.findViewById(R.id.permission_tv);
        permissionTv.setText(PermissionUtils.getPermissionDescription(simplifiedPermission));
        permissionTv.setTextColor(ContextCompat.getColor(context, R.color.white));
        if (colorId != 0){
            convertView.findViewById(R.id.item_view).setBackgroundColor(ContextCompat.getColor(context, colorId));
        }

        GradientDrawable bgShape = (GradientDrawable)convertView
                .findViewById(R.id.drawable_circle_indicator).getBackground();
        bgShape.setColor(PermissionUtils.getPermissionColor(permission));

        return convertView;
    }

}