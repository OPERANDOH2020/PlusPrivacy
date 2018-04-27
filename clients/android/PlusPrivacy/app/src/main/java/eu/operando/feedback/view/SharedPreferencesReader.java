package eu.operando.feedback.view;

import android.content.Context;
import android.content.SharedPreferences;

import javax.inject.Inject;

import eu.operando.storage.Storage;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class SharedPreferencesReader {

    private static final String FEEDBACK_PREFS = "FEEDBACK_PREFS";

    private final Context context;
    private String userID;

    @Inject
    public SharedPreferencesReader(Context context) {
        this.context = context;
        userID = Storage.readUserID();
    }

    public SharedPreferences getSharedPreferences(){
        return context.getSharedPreferences(FEEDBACK_PREFS, 0);
    }

    public String getUserID(){
        return userID;
    }
}
