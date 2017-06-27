package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Notification;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 1/3/2017.
 */

public class GetNotificationsSwarm extends Swarm {
    private ArrayList<Notification> notifications;

    public GetNotificationsSwarm() {
        super("notification.js","getNotifications");
    }

    public ArrayList<Notification> getNotifications() {
        return notifications;
    }
}
