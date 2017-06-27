package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.widget.ListView;

import java.util.ArrayList;

import eu.operando.R;
import eu.operando.adapter.NotificationsListAdapter;
import eu.operando.model.Notification;

/**
 * Created by Edy on 6/21/2016.
 */
public class NotificationsActivity extends BaseActivity {
    public static void start(Context context) {
        Intent starter = new Intent(context, NotificationsActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifications);
        Toolbar toolbar = ((Toolbar) findViewById(R.id.toolbar));


        ListView listView = (ListView) findViewById(R.id.lv);

        if (listView != null) {
            listView.setAdapter(new NotificationsListAdapter(this, getNotifications()));
        }
    }

    private ArrayList<Notification> getNotifications() {
        ArrayList<Notification> notifications = new ArrayList<>();
        notifications.add(
                new Notification("Some users have reported the application <b>MSQRD</b> as suspicious",
                        "1 hour ago", Notification.Type.INFO)
        );
        notifications.add(
                new Notification("Application <b>Clever Taxi</b> is sending some sensitive information about your location",
                        "3 hours ago", Notification.Type.WARNING)
        );
        notifications.add(
                new Notification("Application <b>Messenger</b> is requesting a wide range of potentially dangerous permissions",
                        "1 day ago", Notification.Type.WARNING)
        );
        notifications.add(
                new Notification("OPERANDO 1.0.5 is available",
                        "1 day ago", Notification.Type.INFO)
        );
        notifications.add(
                new Notification("Application <b>Heart Rate Monitor</b> is accessing your camera but it is not listed as a camera app",
                        "2 days ago", Notification.Type.WARNING)
        );


        return notifications;
    }
}
