package eu.operando.models;

/**
 * Created by Edy on 1/3/2017.
 */

public class Notification {
    private String notificationId;
    private String sender;
    private String title;
    private String description;
    private String zone;
    private String action_name;

    public String getNotificationId() {
        return notificationId;
    }

    public String getSender() {
        return sender;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getZone() {
        return zone;
    }

    public String getAction_name() {
        return action_name;
    }

    @Override
    public String toString() {
        return "Notification{" +
                "notificationId='" + notificationId + '\'' +
                ", sender='" + sender + '\'' +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", zone='" + zone + '\'' +
                ", action_name='" + action_name + '\'' +
                '}';
    }
}
