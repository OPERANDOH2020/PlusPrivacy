package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.Toast;

import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import eu.operando.R;
import eu.operando.adapter.FacebookSettingsListAdapter;
import eu.operando.customView.AccordionOnGroupExpandListener;
import eu.operando.customView.FacebookSettingsInfoDialog;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.models.SocialNetworkEnum;
import eu.operando.models.privacysettings.AvailableSettings;
import eu.operando.models.privacysettings.AvailableSettingsWrite;
import eu.operando.models.privacysettings.OspSettings;
import eu.operando.models.privacysettings.Preference;
import eu.operando.models.privacysettings.Question;
import eu.operando.swarmService.models.GetUserPreferencesSwarm;
import eu.operando.swarmService.models.PrivacyWizardSwarm;
import eu.operando.swarmService.models.SaveUserPreferencesSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.PrivacyWizardSwarmCallback;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

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