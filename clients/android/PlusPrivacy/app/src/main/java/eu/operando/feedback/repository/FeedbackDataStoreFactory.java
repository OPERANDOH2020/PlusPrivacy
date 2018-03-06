package eu.operando.feedback.repository;

import eu.operando.feedback.entity.DataStoreType;
import eu.operando.feedback.view.SharedPreferencesReader;

/**
 * Created by Matei_Alexandru on 03.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FeedbackDataStoreFactory {

    private SharedPreferencesReader sharedPreferencesReader;

    public FeedbackDataStoreFactory() {
//        this.sharedPreferencesReader = new SharedPreferencesReader();
    }

    public FeedbackDataStore create(DataStoreType type) {

        switch (type){
            case SHARED_PREFERENCES:
//                return new SharedPreferencesFeedbackDataStore(sharedPreferencesReader);
                return new SharedPreferencesFeedbackDataStore();
            case NETWORK:
                return new NetworkFeedbackDataStore();
            default:
                return new NetworkFeedbackDataStore();
        }
    }

}
