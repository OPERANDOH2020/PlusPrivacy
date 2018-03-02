package eu.operando.activity;

import android.content.Context;

import java.util.List;

import eu.operando.models.SocialNetworkEnum;
import eu.operando.models.privacysettings.OspSettings;
import eu.operando.models.privacysettings.Question;

/**
 * Created by Matei_Alexandru on 31.08.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

public class FacebookSettingsActivity extends SocialNetworkFormBaseActivity {

    @Override
    protected List<Question> getQuestionsBySN(OspSettings ospSettings) {
        return ospSettings.getFacebook();
    }

    @Override
    protected Context getContext() {
        return FacebookSettingsActivity.this;
    }

    @Override
    public SocialNetworkEnum getSocialNetworkEnum() {
        return SocialNetworkEnum.FACEBOOK;
    }

    @Override
    protected Class getWebViewClass() {
        return FacebookWebViewActivity.class;
    }
}