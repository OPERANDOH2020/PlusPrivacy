package eu.operando.storage;

import android.support.annotation.Nullable;
import android.util.Pair;

import java.util.List;

import eu.operando.models.InstalledApp;
import io.paperdb.Paper;

/**
 * Created by Edy on 11/25/2016.
 */

public class Storage {
    private static void write(String key, @Nullable Object value) {
        if (value != null) {
            Paper.book().write(key, value);
        } else {
            Paper.book().delete(key);
        }
    }

    public static void saveUserID(String userID) {
        write(K.USER_ID, userID);
    }

    public static String readUserID() {
        return Paper.book().read(K.USER_ID);
    }

    public static void saveAppList(List<InstalledApp> appList) {
        write(K.APP_LIST, appList);
    }

    public static List<InstalledApp> readAppList() {
        return Paper.book().read(K.APP_LIST);
    }

    public static void saveCredentials(String user, String pass) {
        Paper.book().write(K.USER, user);
        Paper.book().write(K.PASS, pass);
    }

    public static Pair<String, String> readCredentials() {
        return new Pair<>((String) Paper.book().read(K.USER), (String) Paper.book().read(K.PASS));
    }

    public static void clearData(){
        Paper.book().destroy();
    }

    public static void saveRegisterCredentials(String user, String pass) {
        Paper.book().write(K.REGISTER_USER, user);
        Paper.book().write(K.REGISTER_PASS, pass);
    }

    public static Pair<String, String> readRegisterCredentials() {
        return new Pair<>((String) Paper.book().read(K.REGISTER_USER), (String) Paper.book().read(K.REGISTER_PASS));
    }

    public static void clearRegisterCredentials(){
        Paper.book().delete(K.REGISTER_USER);
        Paper.book().delete(K.REGISTER_PASS);
    }
}


