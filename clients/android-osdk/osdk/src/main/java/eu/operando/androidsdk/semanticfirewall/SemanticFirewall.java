package eu.operando.androidsdk.semanticfirewall;

import android.content.Context;
import android.util.Log;
import android.util.Pair;

import com.google.gson.Gson;

import org.joda.time.DateTime;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import eu.operando.androidsdk.scdmodel.ScdModel;
import eu.operando.androidsdk.semanticfirewall.model.AppDatabase;
import eu.operando.androidsdk.semanticfirewall.model.FirewallLog;
import eu.operando.androidsdk.semanticfirewall.stringmatching.AhoCorasick;
import eu.operando.androidsdk.semanticfirewall.stringmatching.PlainSensitiveData;
import eu.operando.androidsdk.semanticfirewall.stringmatching.RegexSensitiveData;
import eu.operando.androidsdk.semanticfirewall.stringmatching.SensitiveData;

/**
 * Created by Alex on 26.04.2018.
 */

public class SemanticFirewall {

    private List<SensitiveData> regexSensitiveDataToCheck;
    private List<SensitiveData> plainSensitiveDataToCheck;
    private Context context;
    private ScdModel scd;
    private final String SCD_FILE = "AppSCD.json";

    public SemanticFirewall(Context context) {

        Log.e("logss", String.valueOf(AppDatabase.getInstance(context).firewallLogDao().getAll()));
        this.context = context;
        scd = new Gson().fromJson(readScdJson(SCD_FILE), ScdModel.class);
        regexSensitiveDataToCheck = new ArrayList<>();
        plainSensitiveDataToCheck = new ArrayList<>();
        regexSensitiveDataToCheck.add(new RegexSensitiveData("loc",
                "([-+]?)([\\d]{1,2})(((\\.)(\\d+)(,)))(\\s*)(([-+]?)([\\d]{1,3})((\\.)(\\d+))?)"));
        regexSensitiveDataToCheck.add(new RegexSensitiveData("gyr",
                "([-+]?)([\\d]{1,2})(((\\.)(\\d+(E-\\d+)?)(,?)))(\\s*)(([-+]?)([\\d]{1,3})" +
                        "((\\.)(\\d+(E-\\d+)?)(,?))?)(\\s*)(([-+]?)([\\d]{1,3})((\\.)(\\d+(E-\\d+)?))?)"));
        plainSensitiveDataToCheck.add(new PlainSensitiveData("pass", "password"));
        plainSensitiveDataToCheck.add(new PlainSensitiveData("pass", "pass"));
    }

    public boolean isSecure(String body, String url) {

        List<Pair<String, Integer>> dataAccesed = new ArrayList<>();

        for (SensitiveData sensitiveData : regexSensitiveDataToCheck) {
            int match = sensitiveData.match(body.toLowerCase());
            if (match != -1) {
                dataAccesed.add(new Pair<>(sensitiveData.getName(), match));
            }
        }
        dataAccesed.addAll(ahoCorasick(body));

        for (Pair<String, Integer> data : dataAccesed) {
            Log.e("match", data.first + " " + String.valueOf(data.second));

            ScdModel.AccessedInputs accessedInput = getAccessedInput(data.first);
            if(accessedInput != null) {
                ScdModel.AccessedInputs.PrivacyDescription privacyDescription = accessedInput.getPrivacyDescription();
                if (privacyDescription.getThirdParties() == null) {
                    return false;
                } else {
                    for (ScdModel.AccessedInputs.PrivacyDescription.ThirdParty thirdParty : privacyDescription.getThirdParties()) {
                        AppDatabase.getInstance(context).firewallLogDao().insert(new FirewallLog(DateTime.now().toDate(), data.first, data.first, data.second));
                        if (!url.contains(thirdParty.getUrl())) {
                            return false;
                        }
                    }
                }
            }
        }

        return true;
    }

    public ScdModel.AccessedInputs getAccessedInput(String inputType) {

        for (ScdModel.AccessedInputs accessedInput : scd.getAccessedInputs()) {
            if (accessedInput.getInputType().equals(inputType)) {
                return accessedInput;
            }
        }
        return null;
    }

    private String readScdJson(String filename) {
        StringBuilder scdStringBuilder = new StringBuilder();
        try {
            InputStream scd_file = context.getAssets().open(filename);

            String inputStr;
            BufferedReader reader = new BufferedReader(new InputStreamReader(scd_file));
            while ((inputStr = reader.readLine()) != null) {
                scdStringBuilder.append(inputStr);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return scdStringBuilder.toString();
    }

    public List<Pair<String, Integer>> ahoCorasick(String body) {

        List<Pair<String, Integer>> dataAccesed = new ArrayList<>();
        AhoCorasick.TrieNode trie = new AhoCorasick.TrieNode();

        for (SensitiveData data : plainSensitiveDataToCheck){
            trie.addWord(data.getPattern());
        }
        trie.constructFallLinks();
        for(Pair<String, Integer> data : trie.search(body)){
            dataAccesed.add(new Pair<>(getPlainDataNameByPattern(data.first), data.second));
        }

        return dataAccesed;

    }

    public String getPlainDataNameByPattern(String pattern){
        for (SensitiveData data : plainSensitiveDataToCheck){
            if (data.getPattern().equals(pattern)){
                return data.getName();
            }
        }
        return pattern;
    }
}
