package eu.operando.utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.support.annotation.ColorInt;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import eu.operando.models.InstalledApp;

/**
 * Created by Edy on 6/15/2016.
 */
public class PermissionUtils {
    public static final HashMap<String, Integer> permissionRisks;
    public static final int[] colors;
    public static final int SAFE_THRESHOLD = 8;

    static {
        colors = new int[]{
                Color.parseColor("#FFFFFF"),
                Color.parseColor("#4D3366FF"),
                Color.parseColor("#4D33FF66"),
                Color.parseColor("#4DCCFF66"),
                Color.parseColor("#4DFFFF66"),
                Color.parseColor("#4DFFFF00"),
                Color.parseColor("#4DFFCC00"),
                Color.parseColor("#4DFF9900"),
                Color.parseColor("#4DFF6600"),
                Color.parseColor("#4DFF0000")};
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
    public static int getColor(InstalledApp app) {
        return colors[app.getPollutionScore() - 1];
    }

    private static void calculatePollutionScore(InstalledApp app) {
        if (app.getPermissions() == null) {
            app.setPollutionScore(1);
            return;
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
        if (totalScore > 10) totalScore = 10;
        app.setPollutionScore(totalScore);

    }

    @ColorInt
    public static int getPermissionColor(String permission) {
        Integer score = permissionRisks.get(permission);
        if (score == null) {
            return colors[3];
        }
        return colors[score - 1];
    }


    public static ArrayList<InstalledApp> getApps(Context c, boolean systemAppsAllowed) {
        try {
            final PackageManager pm = c.getPackageManager();
            ArrayList<InstalledApp> apps = new ArrayList<>();
            List<ApplicationInfo> packages = pm.getInstalledApplications(PackageManager.GET_META_DATA);
            for (ApplicationInfo applicationInfo : packages) {
                PackageInfo info;
                info = pm.getPackageInfo(applicationInfo.packageName, PackageManager.GET_PERMISSIONS | PackageManager.GET_CONFIGURATIONS);
                String packageName = applicationInfo.packageName;
                if (!systemAppsAllowed) {
                    if (packageName.startsWith("com.android") || packageName.startsWith("android") /*|| packageName.startsWith("com.google")**/)
                        continue;
                    if ((applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0)
                        continue;
                    if (packageName.equals(c.getPackageName()))
                        continue;
                }
                String appName = pm.getApplicationLabel(applicationInfo).toString();
                String[] requestedPermissions = info.requestedPermissions;
                System.out.println(applicationInfo.packageName);
                System.out.println(Arrays.toString(requestedPermissions));
                InstalledApp app = new InstalledApp(appName, packageName, requestedPermissions, info.reqFeatures);
                PermissionUtils.calculatePollutionScore(app);
                apps.add(app);
            }
            return apps;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
}
