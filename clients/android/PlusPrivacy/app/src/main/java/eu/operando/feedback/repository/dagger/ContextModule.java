package eu.operando.feedback.repository.dagger;

import android.content.Context;

import dagger.Module;
import dagger.Provides;

/**
 * Created by Matei_Alexandru on 11.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

@Module
public class ContextModule {

    public Context context;

    public ContextModule(Context context) {
        this.context = context;
    }

    @MyApplicationScope
    @Provides
    Context provideContext() {
        return context;
    }

}
