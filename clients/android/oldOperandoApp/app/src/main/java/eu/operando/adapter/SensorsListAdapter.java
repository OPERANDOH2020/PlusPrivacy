package eu.operando.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.model.SensorModel;

/**
 * Created by Edy on 6/24/2016.
 */
public class SensorsListAdapter extends ArrayAdapter<SensorModel> {
    public SensorsListAdapter(Context context, ArrayList<SensorModel> objects) {
        super(context, R.layout.sensor_list_item, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(
                    R.layout.sensor_list_item, parent, false
            );
        }
        SensorModel item = getItem(position);
        ((ImageView) convertView.findViewById(R.id.sensor_icon)).setImageResource(item.getIconResID());
        ((TextView) convertView.findViewById(R.id.sensor_name)).setText(item.getName());
        return convertView;
    }
}
