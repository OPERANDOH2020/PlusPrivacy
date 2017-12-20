package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import eu.operando.R;
import eu.operando.adapter.NotificationsExpandableListViewAdapter;
import eu.operando.customView.AccordionOnGroupExpandListener;
import eu.operando.customView.CustomOnGroupClickListener;
import eu.operando.feedback.view.FeedbackActivity;
import eu.operando.lightning.activity.MainBrowserActivity;
import eu.operando.models.Notification;
import eu.operando.swarmService.models.GetNotificationsSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

public class NotificationsActivity extends BaseActivity {

    private ExpandableListView notificationsLV;
    private ExpandableListAdapter adapter;

    public static void start(Context context) {
        Intent starter = new Intent(context, NotificationsActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifications);

        initUI();
        setData();
    }

    private void initUI() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.notification_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        notificationsLV = (ExpandableListView) findViewById(R.id.notifications_elv);
        notificationsLV.setOnGroupExpandListener(new AccordionOnGroupExpandListener(notificationsLV));
    }

    private void setData() {

        SwarmClient.getInstance().startSwarm(new GetNotificationsSwarm(),
                new SwarmCallback<GetNotificationsSwarm>() {
                    @Override
                    public void call(final GetNotificationsSwarm result) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                handleGetNotificationsSwarmResult(result);

                            }
                        });
                    }
                });
    }

    private void handleGetNotificationsSwarmResult(final GetNotificationsSwarm result) {
        for (Notification notification : result.getNotifications()) {
            Log.e("Notifications", notification.toString());
        }

        adapter = new NotificationsExpandableListViewAdapter(
                NotificationsActivity.this, result.getNotifications());
        notificationsLV.setAdapter(adapter);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
        }
        return super.onOptionsItemSelected(item);
    }
}
