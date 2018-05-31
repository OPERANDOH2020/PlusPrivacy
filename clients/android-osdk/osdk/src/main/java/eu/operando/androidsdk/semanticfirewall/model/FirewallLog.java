package eu.operando.androidsdk.semanticfirewall.model;

import android.arch.persistence.room.Entity;
import android.arch.persistence.room.PrimaryKey;
import android.support.annotation.NonNull;

import java.util.Date;

/**
 * Created by Alex on 03.05.2018.
 */

@Entity(primaryKeys = {"date", "name"})
public class FirewallLog {

    @NonNull
    private Date date;
    @NonNull
    private String name;
    private String patternFound;
    private int startIndex;


    public FirewallLog(Date date, String name, String patternFound, int startIndex) {
        this.date = date;
        this.name = name;
        this.patternFound = patternFound;
        this.startIndex = startIndex;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPatternFound() {
        return patternFound;
    }

    public void setPatternFound(String patternFound) {
        this.patternFound = patternFound;
    }

    public int getStartIndex() {
        return startIndex;
    }

    @Override
    public String toString() {
        return "FirewallLog{" +
                "date=" + date +
                ", name='" + name + '\'' +
                ", patternFound='" + patternFound + '\'' +
                ", startIndex=" + startIndex +
                '}';
    }

    public void setStartIndex(int startIndex) {
        this.startIndex = startIndex;
    }
}
