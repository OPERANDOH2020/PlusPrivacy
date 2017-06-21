package eu.operando.util;

import android.graphics.Color;
import android.support.annotation.ColorInt;

import java.util.ArrayList;
import java.util.HashMap;

import eu.operando.model.InstalledApp;

/**
 * Created by Edy on 6/15/2016.
 */
public class PermissionUtils {
    public static final HashMap<String, Integer> permissionRisks;
    public static final int[] colors;

    static {
        colors = new int[]{
                Color.parseColor("#3300FF"),
                Color.parseColor("#3366FF"),
                Color.parseColor("#33FF66"),
                Color.parseColor("#CCFF66"),
                Color.parseColor("#FFFF66"),
                Color.parseColor("#FFFF00"),
                Color.parseColor("#FFCC00"),
                Color.parseColor("#FF9900"),
                Color.parseColor("#FF6600"),
                Color.parseColor("#FF0000")};
        permissionRisks = new HashMap<>();
        permissionRisks.put("android.permission.ACCESS_ALL_EXTERNAL_STORAGE", 5);
        permissionRisks.put("android.permission.ACCESS_COARSE_LOCATION", 8);
        permissionRisks.put("android.permission.ACCESS_FINE_LOCATION", 9);
        permissionRisks.put("android.permission.ACCESS_LOCATION_EXTRA_COMMANDS", 8);
        permissionRisks.put("android.permission.ACCESS_MOCK_LOCATION", 10);
        permissionRisks.put("android.permission.ACCESS_NETWORK_STATE", 6);
        permissionRisks.put("android.permission.ACCESS_SUPERUSER", 10);
        permissionRisks.put("android.permission.ACCESS_WIFI_STATE", 2);
        permissionRisks.put("android.permission.ACTIVITY_RECOGNITION", 5);
        permissionRisks.put("android.permission.ADD_VOICEMAIL", 7);
        permissionRisks.put("android.permission.AUTHENTICATE_ACCOUNTS", 10);
        permissionRisks.put("android.permission.BLUETOOTH", 4);
        permissionRisks.put("android.permission.BLUETOOTH_ADMIN", 6);
        permissionRisks.put("android.permission.BODY_SENSORS", 5);
        permissionRisks.put("android.permission.BROADCAST_STICKY", 2);
        permissionRisks.put("android.permission.CALL_PHONE", 10);
        permissionRisks.put("android.permission.CAMERA", 5);
        permissionRisks.put("android.permission.CHANGE_CONFIGURATION", 7);
        permissionRisks.put("android.permission.CHANGE_NETWORK_STATE", 6);
        permissionRisks.put("android.permission.CHANGE_WIFI_MULTICAST_STATE", 2);
        permissionRisks.put("android.permission.CHANGE_WIFI_STATE", 5);
        permissionRisks.put("android.permission.CLEAR_APP_CACHE", 3);
        permissionRisks.put("android.permission.CONFIGURE_SIP", 7);
        permissionRisks.put("android.permission.DISABLE_KEYGUARD", 6);
        permissionRisks.put("android.permission.DOWNLOAD_WITHOUT_NOTIFICATION", 8);
        permissionRisks.put("android.permission.EXPAND_STATUS_BAR", 7);
        permissionRisks.put("android.permission.FLASHLIGHT", 2);
        permissionRisks.put("android.permission.GET_ACCOUNTS", 2);
        permissionRisks.put("android.permission.GET_PACKAGE_SIZE", 1);
        permissionRisks.put("android.permission.GOOGLE_AUTH", 4);
        permissionRisks.put("android.permission.INSTALL_DRM", 3);
        permissionRisks.put("android.permission.INSTALL_SHORTCUT", 5);
        permissionRisks.put("android.permission.KILL_BACKGROUND_PROCESSES", 4);
        permissionRisks.put("android.permission.MANAGE_ACCOUNTS", 3);
        permissionRisks.put("android.permission.MODIFY_AUDIO_SETTINGS", 4);
        permissionRisks.put("android.permission.NFC", 4);
        permissionRisks.put("android.permission.PREVENT_POWER_KEY", 8);
        permissionRisks.put("android.permission.PROCESS_OUTGOING_CALLS", 10);
        permissionRisks.put("android.permission.READ_ATTACHMENT", 8);
        permissionRisks.put("android.permission.READ_CALENDAR", 7);
        permissionRisks.put("android.permission.READ_CALL_LOG", 8);
        permissionRisks.put("android.permission.READ_CONTACTS", 9);
        permissionRisks.put("android.permission.READ_CONTENT_PROVIDER", 6);
        permissionRisks.put("android.permission.READ_EXTERNAL_STORAGE", 5);
        permissionRisks.put("android.permission.READ_HISTORY_BOOKMARKS", 8);
        permissionRisks.put("android.permission.READ_OWNER_DATA", 6);
        permissionRisks.put("android.permission.READ_PHONE_STATE", 7);
        permissionRisks.put("android.permission.READ_PROFILE", 7);
        permissionRisks.put("android.permission.READ_SETTINGS", 4);
        permissionRisks.put("android.permission.READ_SMS", 10);
        permissionRisks.put("android.permission.READ_SOCIAL_STREAM", 10);
        permissionRisks.put("android.permission.READ_SYNC_SETTINGS", 2);
        permissionRisks.put("android.permission.READ_SYNC_STATS", 3);
        permissionRisks.put("android.permission.READ_USER_DICTIONARY", 4);
        permissionRisks.put("android.permission.RECEIVE_BOOT_COMPLETED", 5);
        permissionRisks.put("android.permission.RECEIVE_MMS", 9);
        permissionRisks.put("android.permission.RECEIVE_SMS", 9);
        permissionRisks.put("android.permission.RECORD_AUDIO", 10);
        permissionRisks.put("android.permission.RESTART_PACKAGES", 10);
        permissionRisks.put("android.permission.SEND_SMS", 10);
        permissionRisks.put("android.permission.SET_ALARM", 1);
        permissionRisks.put("android.permission.SET_WALLPAPER", 3);
        permissionRisks.put("android.permission.SUBSCRIBED_FEEDS_READ", 7);
        permissionRisks.put("android.permission.SUBSCRIBED_FEEDS_WRITE", 8);
        permissionRisks.put("android.permission.SYSTEM_ALERT_WINDOW", 9);
        permissionRisks.put("android.permission.UNINSTALL_SHORTCUT", 5);
        permissionRisks.put("android.permission.USE_SIP", 7);
        permissionRisks.put("android.permission.VIBRATE", 2);
        permissionRisks.put("android.permission.WAKE_LOCK", 3);
        permissionRisks.put("android.permission.WRITE_CALENDAR", 6);
        permissionRisks.put("android.permission.WRITE_CALL_LOG", 8);
        permissionRisks.put("android.permission.WRITE_CONTACTS", 8);
        permissionRisks.put("android.permission.WRITE_EXTERNAL_STORAGE", 6);
        permissionRisks.put("android.permission.WRITE_GMAIL", 5);
        permissionRisks.put("android.permission.WRITE_HISTORY_BOOKMARKS", 7);
        permissionRisks.put("android.permission.WRITE_PROFILE", 6);
        permissionRisks.put("android.permission.WRITE_SMS", 9);
        permissionRisks.put("android.permission.WRITE_SOCIAL_STREAM", 8);
        permissionRisks.put("android.permission.WRITE_USER_DICTIONARY", 4);
    }

    @ColorInt
    public static int computePrivacyPollution(InstalledApp app) {
        if (app.getPermissions() == null) return Color.WHITE;
        if (app.getPackageName().equals("fm.clean") || app.getPackageName().equals("com.facebook.orca")) {
            breakpoint();
        }
        boolean over7 = false;
        int counter = 0;
        int totalScore = 0;
        for (String permission : app.getPermissions()) {
            Integer permScore = permissionRisks.get(permission);
            if (permScore == null) permScore = 3;
            if (permScore > 7) over7 = true;
            counter++;
            totalScore += permScore;
        }
        if (over7) {
            totalScore += 5 * counter;
        }
        totalScore = totalScore / counter;
        return colors[totalScore < 10 ? totalScore-1 : 9];
    }

    private static void breakpoint() {

    }
}
