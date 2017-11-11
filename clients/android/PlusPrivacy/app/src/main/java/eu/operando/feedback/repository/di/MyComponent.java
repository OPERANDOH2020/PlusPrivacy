package eu.operando.feedback.repository.di;

import dagger.Component;
import eu.operando.feedback.repository.SharedPreferencesFeedbackDataStore;

/**
 * Created by Matei_Alexandru on 10.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

@Component(modules = {SharedPreferencesModule.class})
@MyApplicationScope
public interface MyComponent {
    void inject(SharedPreferencesFeedbackDataStore sharedPreferencesFeedbackDataStore);
//    void inject(FeedbackActivity feedbackActivity);
}

