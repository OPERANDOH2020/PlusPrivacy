package eu.operando.feedback.repository.di;

import android.content.SharedPreferences;

import javax.inject.Inject;

import eu.operando.storage.Storage;

/**
 * Created by Matei_Alexandru on 10.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class MySharedPreferences {

    private SharedPreferences mSharedPreferences;
    private String userID;

    @Inject
    public MySharedPreferences(SharedPreferences mSharedPreferences) {
        this.mSharedPreferences = mSharedPreferences;
        userID = Storage.readUserID();
    }

    public String getUserID(){
        return userID;
    }

    public SharedPreferences getmSharedPreferences() {
        return mSharedPreferences;
    }
}