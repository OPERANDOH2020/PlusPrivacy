package aspectj.archinamon.alex.hookframework.xpoint.newdesign.framework;

/**
 * Created by Matei_Alexandru on 01.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class HookHelper {

    public final static String GET_LAST_KNOWN_LOCATION = "getLastKnownLocation";
    public final static String ON_LOCATION_CHANGED = "onLocationChanged";
    public final static String ON_SENSOR_CHANGED = "onSensorChanged";
    public final static String START_MEDIA_RECORDER = "start";
    public final static String INTENT_CONSTRUCTOR_CAMERA = "<init>android.media.action.IMAGE_CAPTURE";
    public final static String INTENT_CONSTRUCTOR = "<init>";
    public final static String INTENT_CONSTRUCTOR_SPEECH_TO_TEXT = "<init>android.speech.action.RECOGNIZE_SPEECH";
    public final static String BATTERY = "getIntExtra";
    public final static String BUILD_OK_HTTP_REQUEST = "newCall";
    public final static String SOCKET_GET_INPUT_STREAM = "getInputStream";

}
