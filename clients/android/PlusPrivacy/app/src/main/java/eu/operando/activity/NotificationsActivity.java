package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.models.Notification;
import eu.operando.swarmService.models.GetNotificationsSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class NotificationsActivity extends BaseActivity {

    private ListView notificationsLV;

    public static void start(Context context) {
        Intent starter = new Intent(context, NotificationsActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifications);
        notificationsLV = ((ListView) findViewById(R.id.notifications_lv));
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        SwarmClient.getInstance().startSwarm(new GetNotificationsSwarm(),
                new SwarmCallback<GetNotificationsSwarm>() {
                    @Override
                    public void call(final GetNotificationsSwarm result) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                notificationsLV.setAdapter(new ArrayAdapter<Notification>(NotificationsActivity.this, R.layout.notification_item, result.getNotifications()) {
                                    @NonNull
                                    @Override
                                    public View getView(final int position, View convertView, @NonNull ViewGroup parent) {
                                        if (convertView == null) {
                                            convertView = LayoutInflater.from(getContext()).inflate(R.layout.notification_item, parent, false);
                                        }
                                        ((TextView) convertView.findViewById(R.id.tv_title)).setText(
                                                result.getNotifications().get(position).getTitle()
                                        );
                                        ((TextView) convertView.findViewById(R.id.tv_description)).setText(
                                                result.getNotifications().get(position).getDescription()
                                        );
                                        ((TextView) convertView.findViewById(R.id.btn_action)).setText("OK"
                                        );
                                        convertView.findViewById(R.id.btn_action).setOnClickListener(new View.OnClickListener() {
                                            @Override
                                            public void onClick(View v) {
                                                String action = result.getNotifications().get(position).getAction_name();
                                                onNotificationTapped(action, result.getNotifications().get(position).getNotificationId());
                                                result.getNotifications().remove(position);
                                                notifyDataSetChanged();
                                            }
                                        });
                                        return convertView;
                                    }
                                });
                            }
                        });
                    }
                });

    }

    private void onNotificationTapped(String action, String id) {
        switch (action.toLowerCase()) {
            case "identity":
                IdentitiesActivity.start(this);
                break;
            case "privacy-for-benefits":
                PFBActivity.start(this);
                break;

        }

        Object[] args = {id, true};
        SwarmClient.getInstance().startSwarm(new Swarm("notification.js", "dismissNotification", args), null);

    }
}
