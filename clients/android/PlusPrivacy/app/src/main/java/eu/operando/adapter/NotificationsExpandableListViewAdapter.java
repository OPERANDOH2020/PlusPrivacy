package eu.operando.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import eu.operando.R;
import eu.operando.activity.IdentitiesActivity;
import eu.operando.activity.PFBActivity;
import eu.operando.feedback.view.FeedbackActivity;
import eu.operando.lightning.activity.MainBrowserActivity;
import eu.operando.models.Notification;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;

import static eu.operando.utils.DateUtils.convertDateToStringLong;
import static eu.operando.utils.DateUtils.convertDateToStringShort;
import static eu.operando.utils.DateUtils.convertStringToDate;

/**
 * Created by Alex on 11/27/2017.
 */

public class NotificationsExpandableListViewAdapter extends BaseExpandableListAdapter {

    private Context context;
    private List<Notification> notifications;

    public NotificationsExpandableListViewAdapter(Context context, List<Notification> notifications) {
        this.context = context;
        this.notifications = notifications;
    }

    private class GroupHolder extends RecyclerView.ViewHolder {

        TextView titleTv;
        TextView dateTv;
        ImageView groupIndicator;

        public GroupHolder(View itemView) {
            super(itemView);

            titleTv = (TextView) itemView.findViewById(R.id.tv_title);
            dateTv = (TextView) itemView.findViewById(R.id.tv_date);
            groupIndicator = (ImageView) itemView.findViewById(R.id.group_indicator);
        }

        public void setData(Notification notification, boolean isExpandable) {
            groupIndicator.setSelected(isExpandable);
            titleTv.setText(notification.getTitle());
            setDateTv(notification.getCreationDate());
        }

        private void setDateTv(String dateString){

            if (dateString != null) {
                Date date = convertStringToDate(dateString);

                Calendar calendar = new GregorianCalendar();
                calendar.setTime(date);
                int dateYear = calendar.get(Calendar.YEAR);
                int currentYear = Calendar.getInstance().get(Calendar.YEAR);

                if (currentYear > dateYear){
                    dateTv.setText(convertDateToStringLong(date));
                } else {
                    dateTv.setText(convertDateToStringShort(date));
                }
            }
        }
    }

    private class ChildViewHolder extends RecyclerView.ViewHolder {

        TextView descriptionTv;
        LinearLayout takeActionRL;
        LinearLayout dismissRL;

        public ChildViewHolder(View itemView) {
            super(itemView);

            descriptionTv = (TextView) itemView.findViewById(R.id.tv_description);
            takeActionRL = (LinearLayout) itemView.findViewById(R.id.take_action_rl);
            dismissRL = (LinearLayout) itemView.findViewById(R.id.dismiss_rl);
        }

        public void setData(final Notification notification) {

            descriptionTv.setText(notification.getDescription());

            takeActionRL.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    String action = notification.getAction_name();
                    onNotificationTapped(action);

                    notifications.remove(notification);
                    notifyDataSetChanged();

                }
            });

            dismissRL.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    Object[] args = {notification.getNotificationId(), true};
                    SwarmService.getInstance().startSwarm(new Swarm("notification.js", "dismissNotification", args), null);

                    notifications.remove(notification);
                    notifyDataSetChanged();
                }
            });
        }

        private void onNotificationTapped(String action) {

            switch (action.toLowerCase()) {
                case "identity":
                    IdentitiesActivity.start(context);
                    break;
                case "privacy-for-benefits":
                    PFBActivity.start(context);
                    break;
                case "feedback":
                    Intent intent = new Intent(context, FeedbackActivity.class);
//                intent.setData(Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLSeZFVqG5GOKPT13qMihrgwJiIMYYENKKfbpBYN1Z5Q5ShDVuA/viewform"));
                    ((AppCompatActivity) context).overridePendingTransition(R.anim.slide_up_in, R.anim.fade_out_scale);
                    context.startActivity(intent);
                    break;
                case "private_browsing":
                    MainBrowserActivity.start(context);
                    break;
            }
        }
    }



    @Override
    public View getGroupView(int groupPosition, boolean b, View convertView, ViewGroup viewGroup) {

        Notification groupItem = (Notification) getGroup(groupPosition);
        final GroupHolder holder;

        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.notification_group_item, null);

            holder = new GroupHolder(convertView);

            convertView.setTag(holder);
        } else {
            holder = ((GroupHolder) convertView.getTag());
        }

        holder.setData(groupItem, b);

        return convertView;
    }

    @Override
    public View getChildView(int i, int i1, boolean b, View convertView, ViewGroup viewGroup) {

        Notification groupItem = (Notification) getGroup(i);
        final ChildViewHolder holder;

        if (convertView == null) {

            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.notification_child_item, null);

            holder = new ChildViewHolder(convertView);

            convertView.setTag(holder);
        } else {
            holder = ((ChildViewHolder) convertView.getTag());
        }

        holder.setData(groupItem);

        return convertView;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return false;
    }

    @Override
    public int getGroupCount() {
        return notifications.size();
    }

    @Override
    public int getChildrenCount(int i) {
        return 1;
    }

    @Override
    public Object getGroup(int i) {
        return notifications.get(i);
    }

    @Override
    public Object getChild(int i, int i1) {
        return notifications.get(i);
    }

    @Override
    public long getGroupId(int i) {
        return i;
    }

    @Override
    public long getChildId(int i, int i1) {
        return i + i1;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }
}
