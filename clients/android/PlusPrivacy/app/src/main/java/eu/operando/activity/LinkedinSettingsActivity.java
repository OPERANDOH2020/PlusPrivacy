package eu.operando.activity;

import android.content.Context;
import android.view.Menu;
import android.view.MenuInflater;

import com.google.gson.JsonElement;

import eu.operando.R;
import eu.operando.models.SocialNetworkEnum;
import eu.operando.models.privacysettings.OspSettings;
import eu.operando.network.RestClient;
import retrofit2.Call;

/**
 * Created by Alex on 1/17/2018.
 */

public class LinkedinSettingsActivity extends SocialNetworkFormBaseActivity {

    @Override
    protected Call<JsonElement> getQuestionsBySN() {
        return RestClient.getApi().getLinkedinSettings();
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

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.linkedin_menu, menu);
        return true;
    }

}
