package aspectj.archinamon.alex.hookframework.xpoint.newdesign.semanticfirewall;

import android.util.Log;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Alex on 26.04.2018.
 */

public class SemanticFirewall {

    List<SensitiveData> sensitiveDataToCheck;

    public SemanticFirewall(List<SensitiveData> sensitiveDataToCheck) {
        this.sensitiveDataToCheck = sensitiveDataToCheck;
    }

    public SemanticFirewall() {
        sensitiveDataToCheck = new ArrayList<>();
        sensitiveDataToCheck.add(new SensitiveData("Location",
                "([-+]?)([\\d]{1,2})(((\\.)(\\d+)(,)))(\\s*)(([-+]?)([\\d]{1,3})((\\.)(\\d+))?)", true));
    }

    public boolean check(String body) {

        StringBuilder completeRegex = new StringBuilder();
        for (SensitiveData sensitiveData : sensitiveDataToCheck) {
            if (sensitiveData.isRegex()){
                completeRegex.append(sensitiveData.getPattern()).append('|');
            }
//            if(body.contains(sensitiveData.getPattern())){
//                /*TO DO: do smth;*/
//                return false;
//            }
        }
        completeRegex.deleteCharAt(completeRegex.length() - 1);

        Pattern pattern = Pattern.compile(completeRegex.toString());
        Matcher matcher = pattern.matcher(body);

        int count = 0;
        while(matcher.find()) {
            count++;
            Log.e("found: ", count + " : "
                    + matcher.start() + " - " + matcher.end());
        }
        if (count > 0){
            return true;
        }
        return false;
    }
}
