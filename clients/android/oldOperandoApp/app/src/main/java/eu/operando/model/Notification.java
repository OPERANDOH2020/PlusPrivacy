package eu.operando.model;

/**
 * Created by Edy on 6/21/2016.
 */
public class Notification {
    private String message;
    //TODO refactor this to use java.uti.Date or long UTC time
    private String date;

    private Type type;

    public Notification(String message, String date, Type type) {
        this.message = message;
        this.date = date;
        this.type = type;
    }

    public String getMessage() {
        return message;
    }

    public String getDate() {
        return date;
    }

    public Type getType() {
        return type;
    }

    public enum Type {
        WARNING,
        INFO
    }
}
