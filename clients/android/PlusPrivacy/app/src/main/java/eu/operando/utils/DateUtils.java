package eu.operando.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Alex on 11/28/2017.
 */

public class DateUtils {

    public static Date convertStringToDate(String dateString) {

        DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date date = null;
        try {
            date = format.parse(dateString);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

    public static String convertDateToStringShort(Date date) {

        DateFormat format = new SimpleDateFormat("MMM, dd", Locale.ENGLISH);
        return format.format(date);
    }

    public static String convertDateToStringLong(Date date) {

        DateFormat format = new SimpleDateFormat("yyyy, MMM, dd", Locale.ENGLISH);
        return format.format(date);
    }
}
