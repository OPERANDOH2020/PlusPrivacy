package eu.operando.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import eu.operando.util.PermissionUtils;

/**
 * Created by Edy on 6/17/2016.
 */
public class PermissionsListAdapter extends ArrayAdapter<String> {
    public PermissionsListAdapter(Context context, ArrayList<String> objects) {
        super(context, android.R.layout.simple_list_item_1, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if(convertView == null){
            convertView = LayoutInflater.from(getContext()).inflate(android.R.layout.simple_list_item_1,parent,false);
        }

        String permission = getItem(position);
        ((TextView) convertView.findViewById(android.R.id.text1)).setText(permission);
        convertView.setBackgroundColor(PermissionUtils.getPermissionColor(permission));

        return convertView;
    }
}
