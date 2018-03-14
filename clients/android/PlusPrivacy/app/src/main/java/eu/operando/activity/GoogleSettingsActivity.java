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
 * Created by Alex on 2/16/2018.
 */

public class GoogleSettingsActivity extends SocialNetworkFormBaseActivity{

    @Override
    protected Call<JsonElement> getQuestionsBySN() {
        return RestClient.getApi().getGoogleSettings();
    }

    @Override
    protected Context getContext() {
        return GoogleSettingsActivity.this;
    }

    @Override
    public SocialNetworkEnum getSocialNetworkEnum() {
        return SocialNetworkEnum.GOOGLE;
    }

    @Override
    protected Class getWebViewClass() {
        return GoogleWebViewActivity.class;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.google_menu, menu);
        return true;
    }
}
