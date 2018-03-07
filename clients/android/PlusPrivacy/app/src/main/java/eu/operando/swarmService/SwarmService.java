package eu.operando.swarmService;

import android.content.Context;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.util.Log;
import android.util.Pair;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import eu.operando.PlusPrivacyApp;
import eu.operando.feedback.entity.FeedbackQuestionListEntity;
import eu.operando.feedback.entity.FeedbackResultSwarmModel;
import eu.operando.models.Identity;
import eu.operando.models.privacysettings.Preference;
import eu.operando.storage.Storage;
import eu.operando.swarmService.models.GenerateIdentitySwarmEntity;
import eu.operando.swarmService.models.GetDomainsSwarmEntity;
import eu.operando.swarmService.models.GetNotificationsSwarmEntity;
import eu.operando.swarmService.models.GetOspSettingsSwarmEntitty;
import eu.operando.swarmService.models.GetUserPreferencesSwarmEntity;
import eu.operando.swarmService.models.PfbSwarmEntity;
import eu.operando.swarmService.models.RegisterInfo;
import eu.operando.swarmService.models.RegisterSwarmEntity;
import eu.operando.swarmclient.SwarmClient;
import eu.operando.swarmclient.models.PrivacyWizardSwarmCallback;
import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import eu.operando.utils.ConnectivityReceiver;

/**
 * Created by Edy on 11/3/2016.
 */

public class SwarmService implements ConnectivityReceiver.ConnectivityReceiverListener {

    private static final String SWARMS_URL = "https://plusprivacy.com:8080";
    private static final String SWARMS_URL_DEBUG_RAFAEL = "http://192.168.103.149:8080";
    private static final String SWARMS_URL_DEBUG_RAFAEL_2 = "https://plusprivacy.club:8080";
    private static final String SWARMS_URL_JOS = "http://192.168.100.144:9001";
    private static final String SWARMS_URL_CIPRIAN = "http://192.168.103.133:8080";

    private static SwarmService instance;

    private SwarmClient swarmClient;
    private boolean first = true;

    private SwarmService() {

        swarmClient = new SwarmClient(SWARMS_URL_DEBUG_RAFAEL);
        registerConnectivityListener();

    }

    public static SwarmService getInstance() {

        if (instance == null) {
            instance = new SwarmService();
        }
        return instance;
    }

    private void registerConnectivityListener() {

        final IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);

        ConnectivityReceiver connectivityReceiver = new ConnectivityReceiver();
        PlusPrivacyApp.getInstance().getApplicationContext().registerReceiver(connectivityReceiver, intentFilter);

        // register connection status listener
        PlusPrivacyApp.getInstance().setConnectivityListener(this);
    }

    @Override
    public void onNetworkConnectionChanged(boolean isConnected) {

        String message;
        if (isConnected) {
            message = "Good! Connected to Internet";
            goodInternetConnection();
        } else {
            message = "Sorry! Not connected to internet";
        }
        Log.e("connection", message);

    }

    private void goodInternetConnection() {

        if (!first) {

            swarmClient = new SwarmClient(SWARMS_URL_DEBUG_RAFAEL);
            Log.e("login", "login");
            Pair<String, String> credentials = Storage.readCredentials();
            login(credentials.first, credentials.second, new SwarmCallback<Swarm>() {
                @Override
                public void call(Swarm result) {

                }
            });
        } else {
            first = false;
        }
    }

    public void setConnectionListener(SwarmClient.ConnectionListener connectionListener) {
        swarmClient.setConnectionListener(connectionListener);
    }

    public void startSwarm(Swarm swarm, SwarmCallback callback) {
        swarmClient.startSwarm(swarm, callback);
    }

    public void login(String username, String password, SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(callback, "login.js", "userLogin", username, password);
    }

    public void logout(SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(callback, "login.js", "logout");
    }

    public void signUp(final String email, final String password, final SwarmCallback<? extends Swarm> callback) {
        //connect to swarms
        login("guest@operando.eu", "guest", new SwarmCallback<Swarm>() {
            @Override
            public void call(Swarm result) {
                //register user
                registerSwarm(email, password, new SwarmCallback<RegisterSwarmEntity>() {
                    @Override
                    public void call(RegisterSwarmEntity result) {
                        try {
                            callback.result(new JSONObject(new Gson().toJson(result)));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        //logout guest
                        logout(new SwarmCallback<Swarm>() {
                            @Override
                            public void call(Swarm result) {
//                                swarmClient.restartSocket();
                            }
                        });
                    }
                });
            }
        });
    }

    public void registerSwarm(String email, String password, final SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(callback, "register.js", "registerNewUser",
                new RegisterInfo(email, password, password));
    }

    public void resetPassword(final String email, final SwarmCallback<Swarm> callback) {
        login("guest@operando.eu", "guest", new SwarmCallback<Swarm>() {
            @Override
            public void call(Swarm result) {
                swarmClient.startSwarm(callback, "UserInfo.js", "resetPassword", email);
            }
        });
    }

    public void getIdentitiesList(SwarmCallback<? extends Swarm> callback) {
        swarmClient.startSwarm(callback, "identity.js", "getMyIdentities");
    }

    public void updateIdentity(SwarmCallback<? extends Swarm> callback, String method, String emailIdentity) {
        swarmClient.startSwarm(callback, "identity.js", method,
                new Identity(emailIdentity, null, null));
    }

    public void getFeedbackQuestions(SwarmCallback<FeedbackQuestionListEntity> callback) {
        swarmClient.startSwarm(callback, "feedback.js", "getFeedbackQuestions");
    }

    public void submitFeedback(SwarmCallback<Swarm> callback, Object... args) {
        swarmClient.startSwarm(callback, "feedback.js", "submitFeedback", args);
    }

    public void hasUserSubmittedAFeedback(SwarmCallback<FeedbackResultSwarmModel> callback) {
        swarmClient.startSwarm(callback, "feedback.js", "hasUserSubmittedAFeedback");
    }

    public void getAllDeals(SwarmCallback<PfbSwarmEntity> callback) {
        swarmClient.startSwarm(callback, "pfb.js", "getAllDeals");
    }

    public void acceptDeal(SwarmCallback<PfbSwarmEntity> callback, boolean accept, String offerId) {
        swarmClient.startSwarm(callback, "pfb.js", accept ? "acceptDeal" : "unsubscribeDeal", offerId);
    }

    public void createIdentity(SwarmCallback<Swarm> callback, Identity identity) {
        swarmClient.startSwarm(callback, "identity.js", "createIdentity", identity);
    }

    public void generateIdentity(SwarmCallback<GenerateIdentitySwarmEntity> callback) {
        swarmClient.startSwarm(callback, "identity.js", "generateIdentity");
    }

    public void listDomains(SwarmCallback<GetDomainsSwarmEntity> callback) {
        swarmClient.startSwarm(callback, "identity.js", "listDomains");
    }

    public void deleteAccount(SwarmCallback<Swarm> callback) {
        swarmClient.startSwarm(callback, "UserInfo.js", "deleteAccount");
    }

    public void changePassword(String currentPassword, String newPassword, SwarmCallback<Swarm> callback) {
        swarmClient.startSwarm(callback, "UserInfo.js", "changePassword",
                currentPassword, newPassword);
    }

    public void getOspSettings(PrivacyWizardSwarmCallback<GetOspSettingsSwarmEntitty> callback) {
        swarmClient.startSwarm(callback, "PrivacyWizardSwarm.js",
                "getOSPSettings");
    }

    public void saveSocialNetworkPreferences(SwarmCallback<Swarm> callback, String id,
                                             List<Preference> userAnswers) {
        swarmClient.startSwarm(callback, "UserPreferences.js",
                "saveOrUpdatePreferences", id, userAnswers);
    }

    public void getSocialNetworkPreferences(SwarmCallback<GetUserPreferencesSwarmEntity> callback, String id) {
        swarmClient.startSwarm(callback, "UserPreferences.js",
                "getPreferences", id);
    }

    public void getNotifications(SwarmCallback<GetNotificationsSwarmEntity> callback) {
        swarmClient.startSwarm(callback, "notification.js", "getNotifications");
    }

}
