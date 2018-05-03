package eu.operando.androidsdk.semanticfirewall.model;

import android.arch.persistence.room.TypeConverter;

import java.util.Date;

/**
 * Created by Alex on 03.05.2018.
 */

public class DateConverter {
    @TypeConverter
    public static Date toDate(Long timestamp) {
        return timestamp == null ? null : new Date(timestamp);
    }

    @TypeConverter
    public static Long toTimestamp(Date date) {
        return date == null ? null : date.getTime();
    }
}
