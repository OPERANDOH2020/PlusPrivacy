package eu.operando.activity;

import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.Toast;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import eu.operando.R;
import eu.operando.adapter.FacebookSettingsListAdapter;
import eu.operando.customView.AccordionOnGroupExpandListener;
import eu.operando.customView.OperandoProgressDialog;
import eu.operando.models.SocialNetworkEnum;
import eu.operando.models.privacysettings.AvailableSettings;
import eu.operando.models.privacysettings.OspSettings;
import eu.operando.models.privacysettings.Question;
import eu.operando.swarmService.models.GetUserPreferencesSwarm;
import eu.operando.swarmService.models.PrivacyWizardSwarm;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.PrivacyWizardSwarmCallback;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;

/**
 * Created by Alex on 1/17/2018.
 */

public class LinkedinSettingsActivity extends SocialNetworkFormBaseActivity {

    @Override
    public int getContentViewID() {
        return R.layout.activity_facebook_settings;
    }

    @Override
    protected List<Question> getQuestionsBySN(OspSettings ospSettings) {
        return ospSettings.getLinkedin();
    }

    @Override
    protected Context getContext() {
        return LinkedinSettingsActivity.this;
    }

    @Override
    public SocialNetworkEnum getSocialNetworkEnum() {
        return SocialNetworkEnum.LINKEDIN;
    }

    @Override
    protected Class getWebViewClass() {
        return LinkedinWebViewActivity.class;
    }

}
