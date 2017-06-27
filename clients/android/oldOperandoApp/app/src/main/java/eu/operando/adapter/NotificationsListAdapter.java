package eu.operando.adapter;

import android.content.Context;
import android.support.annotation.DrawableRes;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.model.Notification;

/**
 * Created by Edy on 6/21/2016.
 */
public class NotificationsListAdapter extends ArrayAdapter<Notification> {
    public NotificationsListAdapter(Context context, ArrayList<Notification> items) {
        super(context, R.layout.notification_list_item, items);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.notification_list_item, parent, false);
        }
        Notification item = getItem(position);
        ((TextView) convertView.findViewById(R.id.notification_text)).setText(Html.fromHtml(item.getMessage()));
        ((TextView) convertView.findViewById(R.id.notification_time)).setText(item.getDate());
        ((ImageView) convertView.findViewById(R.id.notification_image)).setImageResource(getImageResID(item.getType()));
        return convertView;
    }

    @DrawableRes
    private int getImageResID(Notification.Type type) {
        switch (type) {
            case WARNING:
                return R.drawable.ic_warning;
            case INFO:
            default:
                return R.drawable.ic_info;
        }
    }
}
