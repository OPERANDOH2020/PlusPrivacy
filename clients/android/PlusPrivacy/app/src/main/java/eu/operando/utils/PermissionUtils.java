package eu.operando.utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.support.annotation.ColorInt;
import android.text.TextUtils;
import android.util.Log;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import eu.operando.models.AbstractApp;
import eu.operando.models.InstalledApp;

/**
 * Created by Edy on 6/15/2016.
 */
public class PermissionUtils {
    public static final HashMap<String, Integer> permissionRisks;
    public static final HashMap<String, String> permissionDescriptions;
    public static List< String> whiteList;
    public static final int[] colors;
    public static final int SAFE_THRESHOLD = 8;

    static {
        colors = new int[]{
                Color.parseColor("#2dc113"),
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
        permissionRisks.put("android.permission.INTERNET", 5);
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



        permissionRisks.put("Public", 1);
        permissionRisks.put("Public profile (required)", 2);
        permissionRisks.put("Friends list", 9);
        permissionRisks.put("Birthday", 9);
        permissionRisks.put("Email address", 7);
        permissionRisks.put("Post on your behalf", 10);
        permissionRisks.put("Work history", 9);
        permissionRisks.put("Education history", 9);
        permissionRisks.put("Current city", 7);
        permissionRisks.put("Photos", 8);
        permissionRisks.put("Videos", 8);
        permissionRisks.put("Likes", 7);
        permissionRisks.put("Send Facebook notifications", 10);
        permissionRisks.put("Custom friends lists", 9);
        permissionRisks.put("Website", 3);
        permissionRisks.put("Personal description", 6);
        permissionRisks.put("Hometown", 7);
        permissionRisks.put("Religious and political views", 9);
        permissionRisks.put("Friend list (required)", 10);
        permissionRisks.put("Email address (required)", 7);
        permissionRisks.put("Manage your Pages", 10);
        permissionRisks.put("Show a list of the Pages you manage", 7);
        permissionRisks.put("Publish as Pages you manage", 10);
        permissionRisks.put("Timeline posts", 9);
        permissionRisks.put("Relationships", 10);
        permissionRisks.put("Books activity", 7);
        permissionRisks.put("Status updates", 7);
        permissionRisks.put("Events", 9);
        permissionRisks.put("Access the groups you manage", 9);
        permissionRisks.put("Friends", 9);
        permissionRisks.put("Relationship interests", 9);
        permissionRisks.put("Groups", 9);
        permissionRisks.put("Manage your business", 10);
        permissionRisks.put("Manage your events", 10);
        permissionRisks.put("Only me", 2);
        permissionRisks.put("Birthday (required)", 9);
        permissionRisks.put("Current city (required)", 7);
        permissionRisks.put("Date of birth", 9);


        //google
        permissionRisks.put("Know the list of people in your circles, your age range, and language", 8);
        permissionRisks.put("View your email address", 7);
        permissionRisks.put("View your basic profile info", 3);
        permissionRisks.put("View your approximate age", 7);
        permissionRisks.put("View your language preferences", 3);
        permissionRisks.put("View and manage Google Drive files and folders that you have opened or created with this app", 10);
        permissionRisks.put("Add itself to Google Drive", 10);
        permissionRisks.put("Manage your contacts", 10);
        permissionRisks.put("Manage your game activity for this game", 6);
        permissionRisks.put("View and manage its own configuration data in your Google Drive", 10);
        permissionRisks.put("Read, send, delete, and manage your email", 10);
        permissionRisks.put("Manage your calendars", 10);
        permissionRisks.put("Know who you are on Google", 8);
        permissionRisks.put("Full account access", 10);
        permissionRisks.put("View the names and email addresses of your Google Contacts", 9);
        permissionRisks.put("View and send chat messages", 10);
        permissionRisks.put("View and manage any of your documents and files in Google Drive", 10);
        permissionRisks.put("View and manage the files in your Google Drive", 10);
        permissionRisks.put("View your Chrome Remote Desktop computers", 10);


        //twitter
        permissionRisks.put("read-only", 2);
        permissionRisks.put("read and write", 6);
        permissionRisks.put("read, write, and direct messages", 10);


        permissionDescriptions = new HashMap<>();
        permissionDescriptions.put("ACCESS_CHECKIN_PROPERTIES", "Allows read/write access to the \"properties\" table in the checkin database, to change values that get uploaded.");
        permissionDescriptions.put("ACCESS_COARSE_LOCATION", "Allows an app to access approximate location.");
        permissionDescriptions.put("ACCESS_FINE_LOCATION", "Allows an app to access precise location.");
        permissionDescriptions.put("ACCESS_LOCATION_EXTRA_COMMANDS", "Allows an application to access extra location provider commands.");
        permissionDescriptions.put("ACCESS_NETWORK_STATE", "Allows applications to access information about networks.");
        permissionDescriptions.put("ACCESS_NOTIFICATION_POLICY", "Marker permission for applications that wish to access notification policy.");
        permissionDescriptions.put("ACCESS_WIFI_STATE", "Allows applications to access information about Wi-Fi networks.");
        permissionDescriptions.put("ACCOUNT_MANAGER", "Allows applications to call into AccountAuthenticators.");
        permissionDescriptions.put("ADD_VOICEMAIL", "Allows an application to add voicemails into the system.");
        permissionDescriptions.put("ANSWER_PHONE_CALLS", "Allows the app to answer an incoming phone call.");
        permissionDescriptions.put("BATTERY_STATS", "Allows an application to collect battery statistics");
        permissionDescriptions.put("BIND_ACCESSIBILITY_SERVICE", "Must be required by an AccessibilityService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_APPWIDGET", "Allows an application to tell the AppWidget service which application can access AppWidget's data.");
        permissionDescriptions.put("BIND_AUTOFILL_SERVICE", "Must be required by a AutofillService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_CARRIER_MESSAGING_SERVICE", "This constant was deprecated in API level 23. Use BIND_CARRIER_SERVICES instead");
        permissionDescriptions.put("BIND_CARRIER_SERVICES", "The system process that is allowed to bind to services in carrier apps will have this permission.");
        permissionDescriptions.put("BIND_CHOOSER_TARGET_SERVICE", "Must be required by a ChooserTargetService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_CONDITION_PROVIDER_SERVICE", "Must be required by a ConditionProviderService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_DEVICE_ADMIN", "Must be required by device administration receiver, to ensure that only the system can interact with it.");
        permissionDescriptions.put("BIND_DREAM_SERVICE", "Must be required by an DreamService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_INCALL_SERVICE", "Must be required by a InCallService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_INPUT_METHOD", "Must be required by an InputMethodService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_MIDI_DEVICE_SERVICE", "Must be required by an MidiDeviceService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_NFC_SERVICE", "Must be required by a HostApduService or OffHostApduService to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_NOTIFICATION_LISTENER_SERVICE", "Must be required by an NotificationListenerService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_PRINT_SERVICE", "Must be required by a PrintService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_QUICK_SETTINGS_TILE", "Allows an application to bind to third party quick settings tiles.");
        permissionDescriptions.put("BIND_REMOTEVIEWS", "Must be required by a RemoteViewsService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_SCREENING_SERVICE", "Must be required by a CallScreeningService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_TELECOM_CONNECTION_SERVICE", "Must be required by a ConnectionService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_TEXT_SERVICE", "Must be required by a TextService (e.g.");
        permissionDescriptions.put("BIND_TV_INPUT", "Must be required by a TvInputService to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_VISUAL_VOICEMAIL_SERVICE", "Must be required by a link VisualVoicemailService to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_VOICE_INTERACTION", "Must be required by a VoiceInteractionService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_VPN_SERVICE", "Must be required by a VpnService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_VR_LISTENER_SERVICE", "Must be required by an VrListenerService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BIND_WALLPAPER", "Must be required by a WallpaperService, to ensure that only the system can bind to it.");
        permissionDescriptions.put("BLUETOOTH", "Allows applications to connect to paired bluetooth devices.");
        permissionDescriptions.put("BLUETOOTH_ADMIN", "Allows applications to discover and pair bluetooth devices.");
        permissionDescriptions.put("BLUETOOTH_PRIVILEGED", "Allows applications to pair bluetooth devices without user interaction, and to allow or disallow phonebook access or message access.");
        permissionDescriptions.put("BODY_SENSORS", "Allows an application to access data from sensors that the user uses to measure what is happening inside his/her body, such as heart rate.");
        permissionDescriptions.put("BROADCAST_PACKAGE_REMOVED", "Allows an application to broadcast a notification that an application package has been removed.");
        permissionDescriptions.put("BROADCAST_SMS", "Allows an application to broadcast an SMS receipt notification.");
        permissionDescriptions.put("BROADCAST_STICKY", "Allows an application to broadcast sticky intents.");
        permissionDescriptions.put("BROADCAST_WAP_PUSH", "Allows an application to broadcast a WAP PUSH receipt notification.");
        permissionDescriptions.put("CALL_PHONE", "Allows an application to initiate a phone call without going through the Dialer user interface for the user to confirm the call.");
        permissionDescriptions.put("CALL_PRIVILEGED", "Allows an application to call any phone number, including emergency numbers, without going through the Dialer user interface for the user to confirm the call being placed.");
        permissionDescriptions.put("CAMERA", "Required to be able to access the camera device.");
        permissionDescriptions.put("CAPTURE_AUDIO_OUTPUT", "Allows an application to capture audio output.");
        permissionDescriptions.put("CAPTURE_SECURE_VIDEO_OUTPUT", "Allows an application to capture secure video output.");
        permissionDescriptions.put("CAPTURE_VIDEO_OUTPUT", "Allows an application to capture video output.");
        permissionDescriptions.put("CHANGE_COMPONENT_ENABLED_STATE", "Allows an application to change whether an application component (other than its own) is enabled or not.");
        permissionDescriptions.put("CHANGE_CONFIGURATION", "Allows an application to modify the current configuration, such as locale.");
        permissionDescriptions.put("CHANGE_NETWORK_STATE", "Allows applications to change network connectivity state.");
        permissionDescriptions.put("CHANGE_WIFI_MULTICAST_STATE", "Allows applications to enter Wi-Fi Multicast mode.");
        permissionDescriptions.put("CHANGE_WIFI_STATE", "Allows applications to change Wi-Fi connectivity state.");
        permissionDescriptions.put("CLEAR_APP_CACHE", "Allows an application to clear the caches of all installed applications on the device.");
        permissionDescriptions.put("CONTROL_LOCATION_UPDATES", "Allows enabling/disabling location update notifications from the radio.");
        permissionDescriptions.put("DELETE_CACHE_FILES", "Allows an application to delete cache files.");
        permissionDescriptions.put("DELETE_PACKAGES", "Allows an application to delete packages.");
        permissionDescriptions.put("DIAGNOSTIC", "Allows applications to RW to diagnostic resources.");
        permissionDescriptions.put("DISABLE_KEYGUARD", "Allows applications to disable the keyguard if it is not secure.");
        permissionDescriptions.put("DUMP", "Allows an application to retrieve state dump information from system services.");
        permissionDescriptions.put("EXPAND_STATUS_BAR", "Allows an application to expand or collapse the status bar.");
        permissionDescriptions.put("FACTORY_TEST", "Run as a manufacturer test application, running as the root user.");
        permissionDescriptions.put("GET_ACCOUNTS", "Allows access to the list of accounts in the Accounts Service.");
        permissionDescriptions.put("GET_ACCOUNTS_PRIVILEGED", "Allows access to the list of accounts in the Accounts Service.");
        permissionDescriptions.put("GET_PACKAGE_SIZE", "Allows an application to find out the space used by any package.");
        permissionDescriptions.put("GET_TASKS", "This constant was deprecated in API level 21. No longer enforced.");
        permissionDescriptions.put("GLOBAL_SEARCH", "This permission can be used on content providers to allow the global search system to access their data.");
        permissionDescriptions.put("INSTALL_LOCATION_PROVIDER", "Allows an application to install a location provider into the Location Manager.");
        permissionDescriptions.put("INSTALL_PACKAGES", "Allows an application to install packages.");
        permissionDescriptions.put("INSTALL_SHORTCUT", "Allows an application to install a shortcut in Launcher.");
        permissionDescriptions.put("INSTANT_APP_FOREGROUND_SERVICE", "Allows an instant app to create foreground services.");
        permissionDescriptions.put("INTERNET", "Allows applications to open network sockets.");
        permissionDescriptions.put("KILL_BACKGROUND_PROCESSES", "Allows an application to call killBackgroundProcesses(String).");
        permissionDescriptions.put("LOCATION_HARDWARE", "Allows an application to use location features in hardware, such as the geofencing api.");
        permissionDescriptions.put("MANAGE_DOCUMENTS", "Allows an application to manage access to documents, usually as part of a document picker.");
        permissionDescriptions.put("MANAGE_OWN_CALLS", "Allows a calling application which manages it own calls through the self-managed ConnectionService APIs.");
        permissionDescriptions.put("MASTER_CLEAR", "Not for use by third-party applications.");
        permissionDescriptions.put("MEDIA_CONTENT_CONTROL", "Allows an application to know what content is playing and control its playback.");
        permissionDescriptions.put("MODIFY_AUDIO_SETTINGS", "Allows an application to modify global audio settings.");
        permissionDescriptions.put("MODIFY_PHONE_STATE", "Allows modification of the telephony state - power on, mmi, etc.");
        permissionDescriptions.put("MOUNT_FORMAT_FILESYSTEMS", "Allows formatting file systems for removable storage.");
        permissionDescriptions.put("MOUNT_UNMOUNT_FILESYSTEMS", "Allows mounting and unmounting file systems for removable storage.");
        permissionDescriptions.put("NFC", "Allows applications to perform I/O operations over NFC.");
        permissionDescriptions.put("PACKAGE_USAGE_STATS", "Allows an application to collect component usage statistics");
        permissionDescriptions.put("PROCESS_OUTGOING_CALLS", "Allows an application to see the number being dialed during an outgoing call with the option to redirect the call to a different number or abort the call altogether.");
        permissionDescriptions.put("READ_CALENDAR", "Allows an application to read the user's calendar data.");
        permissionDescriptions.put("READ_CALL_LOG", "Allows an application to read the user's call log.");
        permissionDescriptions.put("READ_CONTACTS", "Allows an application to read the user's contacts data.");
        permissionDescriptions.put("READ_EXTERNAL_STORAGE", "Allows an application to read from external storage.");
        permissionDescriptions.put("READ_FRAME_BUFFER", "Allows an application to take screen shots and more generally get access to the frame buffer data.");
        permissionDescriptions.put("READ_INPUT_STATE", "This constant was deprecated in API level 16. The API that used this permission has been removed.");
        permissionDescriptions.put("READ_LOGS", "Allows an application to read the low-level system log files.");
        permissionDescriptions.put("READ_PHONE_NUMBERS", "Allows read access to the device's phone number(s).");
        permissionDescriptions.put("READ_PHONE_STATE", "Allows read only access to phone state, including the phone number of the device, current cellular network information, the status of any ongoing calls, and a list of any PhoneAccounts registered on the device.");
        permissionDescriptions.put("READ_SMS", "Allows an application to read SMS messages.");
        permissionDescriptions.put("READ_SYNC_SETTINGS", "Allows applications to read the sync settings.");
        permissionDescriptions.put("READ_SYNC_STATS", "Allows applications to read the sync stats.");
        permissionDescriptions.put("READ_VOICEMAIL", "Allows an application to read voicemails in the system.");
        permissionDescriptions.put("REBOOT", "Required to be able to reboot the device.");
        permissionDescriptions.put("RECEIVE_BOOT_COMPLETED", "Allows an application to receive the ACTION_BOOT_COMPLETED that is broadcast after the system finishes booting.");
        permissionDescriptions.put("RECEIVE_MMS", "Allows an application to monitor incoming MMS messages.");
        permissionDescriptions.put("RECEIVE_SMS", "Allows an application to receive SMS messages.");
        permissionDescriptions.put("RECEIVE_WAP_PUSH", "Allows an application to receive WAP push messages.");
        permissionDescriptions.put("RECORD_AUDIO", "Allows an application to record audio.");
        permissionDescriptions.put("REORDER_TASKS", "Allows an application to change the Z-order of tasks.");
        permissionDescriptions.put("REQUEST_COMPANION_RUN_IN_BACKGROUND", "Allows a companion app to run in the background.");
        permissionDescriptions.put("REQUEST_COMPANION_USE_DATA_IN_BACKGROUND", "Allows a companion app to use data in the background.");
        permissionDescriptions.put("REQUEST_DELETE_PACKAGES", "Allows an application to request deleting packages.");
        permissionDescriptions.put("REQUEST_IGNORE_BATTERY_OPTIMIZATIONS", "Permission an application must hold in order to use ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS.");
        permissionDescriptions.put("REQUEST_INSTALL_PACKAGES", "Allows an application to request installing packages.");
        permissionDescriptions.put("RESTART_PACKAGES", "This constant was deprecated in API level 8. The restartPackage(String) API is no longer supported.");
        permissionDescriptions.put("SEND_RESPOND_VIA_MESSAGE", "Allows an application (Phone) to send a request to other applications to handle the respond-via-message action during incoming calls.");
        permissionDescriptions.put("SEND_SMS", "Allows an application to send SMS messages.");
        permissionDescriptions.put("SET_ALARM", "Allows an application to broadcast an Intent to set an alarm for the user.");
        permissionDescriptions.put("SET_ALWAYS_FINISH", "Allows an application to control whether activities are immediately finished when put in the background.");
        permissionDescriptions.put("SET_ANIMATION_SCALE", "Modify the global animation scaling factor.");
        permissionDescriptions.put("SET_DEBUG_APP", "Configure an application for debugging.");
        permissionDescriptions.put("SET_PREFERRED_APPLICATIONS", "This constant was deprecated in API level 7. No longer useful, see addPackageToPreferred(String) for details.");
        permissionDescriptions.put("SET_PROCESS_LIMIT", "Allows an application to set the maximum number of (not needed) application processes that can be running.");
        permissionDescriptions.put("SET_TIME", "Allows applications to set the system time.");
        permissionDescriptions.put("SET_TIME_ZONE", "Allows applications to set the system time zone.");
        permissionDescriptions.put("SET_WALLPAPER", "Allows applications to set the wallpaper.");
        permissionDescriptions.put("SET_WALLPAPER_HINTS", "Allows applications to set the wallpaper hints.");
        permissionDescriptions.put("SIGNAL_PERSISTENT_PROCESSES", "Allow an application to request that a signal be sent to all persistent processes.");
        permissionDescriptions.put("STATUS_BAR", "Allows an application to open, close, or disable the status bar and its icons.");
        permissionDescriptions.put("SYSTEM_ALERT_WINDOW", "Allows an app to create windows using the type TYPE_APPLICATION_OVERLAY, shown on top of all other apps.");
        permissionDescriptions.put("TRANSMIT_IR", "Allows using the device's IR transmitter, if available.");
        permissionDescriptions.put("UNINSTALL_SHORTCUT", "This permission is no longer supported.");
        permissionDescriptions.put("UPDATE_DEVICE_STATS", "Allows an application to update device statistics.");
        permissionDescriptions.put("USE_FINGERPRINT", "Allows an app to use fingerprint hardware.");
        permissionDescriptions.put("USE_SIP", "Allows an application to use SIP service.");
        permissionDescriptions.put("VIBRATE", "Allows access to the vibrator.");
        permissionDescriptions.put("WAKE_LOCK", "Allows using PowerManager WakeLocks to keep processor from sleeping or screen from dimming.");
        permissionDescriptions.put("WRITE_APN_SETTINGS", "Allows applications to write the apn settings.");
        permissionDescriptions.put("WRITE_CALENDAR", "Allows an application to write the user's calendar data.");
        permissionDescriptions.put("WRITE_CALL_LOG", "Allows an application to write (but not read) the user's call log data.");
        permissionDescriptions.put("WRITE_CONTACTS", "Allows an application to write the user's contacts data.");
        permissionDescriptions.put("WRITE_EXTERNAL_STORAGE", "Allows an application to write to external storage.");
        permissionDescriptions.put("WRITE_GSERVICES", "Allows an application to modify the Google service map.");
        permissionDescriptions.put("WRITE_SECURE_SETTINGS", "Allows an application to read or write the secure system settings.");
        permissionDescriptions.put("WRITE_SETTINGS", "Allows an application to read or write the system settings.");
        permissionDescriptions.put("WRITE_SYNC_SETTINGS", "Allows applications to write the sync settings.");
        permissionDescriptions.put("WRITE_VOICEMAIL", "");

        //facebook
        permissionDescriptions.put("Public", "Public");
        permissionDescriptions.put("Public profile (required)", "Public profile (required)");
        permissionDescriptions.put("Friends list", "Friends list");
        permissionDescriptions.put("Birthday", "Birthday");
        permissionDescriptions.put("Email address", "Email address");
        permissionDescriptions.put("Post on your behalf", "Post on your behalf");
        permissionDescriptions.put("Work history", "Work history");
        permissionDescriptions.put("Education history", "Education history");
        permissionDescriptions.put("Current city", "Current city");
        permissionDescriptions.put("Photos", "Photos");
        permissionDescriptions.put("Videos", "Videos");
        permissionDescriptions.put("Likes", "Likes");
        permissionDescriptions.put("Send Facebook notifications", "Send Facebook notifications");
        permissionDescriptions.put("Custom friends lists", "Custom friends lists");
        permissionDescriptions.put("Website", "Website");
        permissionDescriptions.put("Personal description", "Personal description");
        permissionDescriptions.put("Hometown", "Hometown");
        permissionDescriptions.put("Religious and political views", "Religious and political views");
        permissionDescriptions.put("Friend list (required)", "Friend list (required)");
        permissionDescriptions.put("Email address (required)", "Email address (required)");
        permissionDescriptions.put("Manage your Pages", "Manage your Pages");
        permissionDescriptions.put("Show a list of the Pages you manage", "Show a list of the Pages you manage");
        permissionDescriptions.put("Publish as Pages you manage", "Publish as Pages you manage");
        permissionDescriptions.put("Timeline posts", "Timeline posts");
        permissionDescriptions.put("Relationships", "Relationships");
        permissionDescriptions.put("Books activity", "Books activity");
        permissionDescriptions.put("Status updates", "Status updates");
        permissionDescriptions.put("Events", "Events");
        permissionDescriptions.put("Access the groups you manage", "Access the groups you manage");
        permissionDescriptions.put("Friends", "Friends");
        permissionDescriptions.put("Relationship interests", "Relationship interests");
        permissionDescriptions.put("Groups", "Groups");
        permissionDescriptions.put("Manage your business", "Manage your business");
        permissionDescriptions.put("Manage your events", "Manage your events");
        permissionDescriptions.put("Only me", "Only me");
        permissionDescriptions.put("Birthday (required)", "Birthday (required)");
        permissionDescriptions.put("Current city (required)", "Current city (required)");
        permissionDescriptions.put("Date of birth", "Date of birth");



        //twitter
        permissionDescriptions.put("read-only", "read-only");
        permissionDescriptions.put("read and write", "read and write");
        permissionDescriptions.put("read, write, and direct messages", "read, write, and direct messages");

        //google
        permissionDescriptions.put("Know the list of people in your circles, your age range, and language", "Know the list of people in your circles, your age range, and language");
        permissionDescriptions.put("View your email address", "View your email address");
        permissionDescriptions.put("View your basic profile info", "View your basic profile info");
        permissionDescriptions.put("View your approximate age", "View your approximate age");
        permissionDescriptions.put("View your language preferences", "View your language preferences");
        permissionDescriptions.put("View and manage Google Drive files and folders that you have opened or created with this app", "View and manage Google Drive files and folders that you have opened or created with this app");
        permissionDescriptions.put("Add itself to Google Drive", "Add itself to Google Drive");
        permissionDescriptions.put("Manage your contacts", "Manage your contacts");
        permissionDescriptions.put("Manage your game activity for this game", "Manage your game activity for this game");
        permissionDescriptions.put("View and manage its own configuration data in your Google Drive", "View and manage its own configuration data in your Google Drive");
        permissionDescriptions.put("Read, send, delete, and manage your email", "Read, send, delete, and manage your email");
        permissionDescriptions.put("Manage your calendars", "Manage your calendars");
        permissionDescriptions.put("Know who you are on Google", "Know who you are on Google");
        permissionDescriptions.put("Full account access", "Full account access");
        permissionDescriptions.put("Basic account info", "Basic account info");
        permissionDescriptions.put("View the names and email addresses of your Google Contacts", "View the names and email addresses of your Google Contacts");
        permissionDescriptions.put("View and send chat messages", "View and send chat messages");
        permissionDescriptions.put("View and manage any of your documents and files in Google Drive", "View and manage any of your documents and files in Google Drive");
        permissionDescriptions.put("View and manage the files in your Google Drive", "View and manage the files in your Google Drive");
        permissionDescriptions.put("View your Chrome Remote Desktop computers", "View your Chrome Remote Desktop computers");

        whiteList = new ArrayList<>();
        whiteList.add("rms.star");
        whiteList.add("com.example.android.apis");
        whiteList.add("ch.protonmail.android");
        whiteList.add("com.duckduckgo.mobile.android");
        whiteList.add("com.domobile.applock");
        whiteList.add("com.symantec.applock");
        whiteList.add("org.mozilla.focus");
        whiteList.add("com.glasswire.android");
        whiteList.add("org.torproject.android");
        whiteList.add("org.thoughtcrime.securesms");
        whiteList.add("com.resilio.sync");
        whiteList.add("com.protonvpn.android");
        whiteList.add("com.lastpass.lpandroid");
        whiteList.add("org.telegram.messenger");
        whiteList.add("com.simplemobiletools.calendar");
        whiteList.add("org.secuso.privacyfriendlyactivitytracker");
        whiteList.add("org.secuso.privacyfriendlyweather");
        whiteList.add("privacy-friendly-android-apps");
        whiteList.add("org.openintents.filemanager");
        whiteList.add("org.adblockplus.adblockplussbrowser");
        whiteList.add("org.adblockplus.browser");
        whiteList.add("com.adguard.android.contentblocker");
        whiteList.add("org.malwarebytes.antimalware");
        whiteList.add("com.ghostery.android.ghostery");
        whiteList.add("com.antivirus");
        whiteList.add("com.bitdefender.security");
    }


    @ColorInt
    public static int getColor(AbstractApp app) {
        if (app.getPollutionScore() < 1){
            return colors[0];
        }
        return colors[app.getPollutionScore() - 1];
    }

    public static boolean isOnWhiteList(AbstractApp app){
        return whiteList.contains(app.getPackageName());
    }

    public static void calculatePollutionScore(AbstractApp app) {
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
        if (counter != 0){
            totalScore = totalScore / counter;
            if (totalScore > 10) totalScore = 10;
        }
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

    public static Integer getPermissionRiskScore(String permission) {

        Integer score = permissionRisks.get(permission);
        if (score == null)
            return 0;
        return score;
    }

    public static String getPermissionDescription(String permission) {
        String description = permissionDescriptions.get(permission);
        if (TextUtils.isEmpty(description)) {
            return "";
        } else {
            return description;
        }
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
                Log.e("packageName", applicationInfo.packageName);
                Log.e("permissions", Arrays.toString(requestedPermissions));
                InstalledApp app = new InstalledApp(appName, packageName, requestedPermissions, info.reqFeatures);
                PermissionUtils.calculatePollutionScore(app);
                apps.add(app);
            }

            for (InstalledApp app : apps) {
                if (app.getPermissions() == null) continue;
                ArrayList<String> cleanPerms = new ArrayList<>();
                ArrayList<String> perms = (ArrayList<String>) app.getPermissions();
                for (String permission : perms) {
                    String[] splitted = permission.split("\\.");
                    String simplifiedPermission = splitted[splitted.length - 1];
                    if (!PermissionUtils.getPermissionDescription(simplifiedPermission).isEmpty()) {
                        cleanPerms.add(permission);
                    }
                }
                app.setPermissions(cleanPerms);
            }
            return apps;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
