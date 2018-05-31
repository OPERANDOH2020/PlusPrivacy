package eu.operando.models;

/**
 * Created by Alex on 20.04.2018.
 */

public class DrawerItem {

    private String title;
    private int drawable;
    private int id;

    public DrawerItem(String title, int drawable, int id) {
        this.title = title;
        this.drawable = drawable;
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getDrawable() {
        return drawable;
    }

    public void setDrawable(int drawable) {
        this.drawable = drawable;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
