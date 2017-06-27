package eu.operando.models;

/**
 * Created by Edy on 10/20/2016.
 */

public class Domain {
    String id;
    String name;

    public Domain(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }
}
