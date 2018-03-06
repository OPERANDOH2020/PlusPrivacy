package eu.operando.swarmService.models;

import java.util.ArrayList;

import eu.operando.models.Notification;
import eu.operando.swarmclient.models.Swarm;

/**
 * Created by Edy on 1/3/2017.
 */

public class GetNotificationsSwarmEntity extends Swarm {
    private ArrayList<Notification> notifications;

    public GetNotificationsSwarmEntity(String swarmingName, String phase, String command, String ctor, String tenantId, Object commandArguments) {
        super(swarmingName, phase, command, ctor, tenantId, commandArguments);
    }

    public ArrayList<Notification> getNotifications() {
        return notifications;
    }
}
