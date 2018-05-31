package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;

import eu.operando.AuthenticationRequiredActivity;
import eu.operando.R;
import eu.operando.adapter.NotificationsExpandableListViewAdapter;
import eu.operando.tasks.AccordionOnGroupExpandListener;
import eu.operando.models.Notification;
import eu.operando.storage.Storage;
import eu.operando.swarmService.SwarmService;
import eu.operando.swarmService.models.GetNotificationsSwarmEntity;
import eu.operando.swarmclient.models.SwarmCallback;

public class NotificationsActivity extends AuthenticationRequiredActivity {

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

        if (Storage.isUserLogged()){
            initUI();
            setData();
        } else {
            setViewForAuthenticationRequired();
        }

    }

    private void initUI() {

        setToolbar();

        notificationsLV = (ExpandableListView) findViewById(R.id.notifications_elv);
        notificationsLV.setOnGroupExpandListener(new AccordionOnGroupExpandListener(notificationsLV));
    }

    private void setData() {

        SwarmService.getInstance().getNotifications(
                new SwarmCallback<GetNotificationsSwarmEntity>() {
                    @Override
                    public void call(final GetNotificationsSwarmEntity result) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                handleGetNotificationsSwarmResult(result);
                            }
                        });
                    }
                });
    }

    private void handleGetNotificationsSwarmResult(final GetNotificationsSwarmEntity result) {
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
