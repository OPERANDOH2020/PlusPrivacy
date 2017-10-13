package eu.operando.feedback.repository.dagger;

import android.content.Context;
import android.content.SharedPreferences;

import dagger.Module;
import dagger.Provides;

/**
 * Created by Matei_Alexandru on 10.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

@Module
public class SharedPreferencesModule {

    private static final String FEEDBACK_PREFS = "FEEDBACK_PREFS";

//    @MyApplicationScope
//    @Provides
//    @Inject
//    SharedPreferences provideSharedPreferences(Context context) {
//        return context.getSharedPreferences(FEEDBACK_PREFS, 0);
//    }

    private Context context;

    public SharedPreferencesModule(Context context) {
        this.context = context;
    }

    @Provides
    @MyApplicationScope
    SharedPreferences provideSharedPreferences() {
        return context.getSharedPreferences(FEEDBACK_PREFS, Context.MODE_PRIVATE);
    }
}
