package eu.operando.androidsdk.semanticfirewall.stringmatching;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Alex on 02.05.2018.
 */

public class RegexSensitiveData extends SensitiveData {

    public RegexSensitiveData(String name, String pattern) {
        super(name, pattern);
    }

    @Override
    public int match(String bodyString) {

        Pattern pattern = Pattern.compile(getPattern());
        Matcher matcher = pattern.matcher(bodyString);

//        int count = 0;
//        while (matcher.find()) {
//            Log.e("found " + matcher.group() + ": " , count + " : "
//                    + matcher.start() + " - " + matcher.end());
//        }
//        if (count > 0) {
//            return true;
//        }

        if (matcher.find())
            return matcher.start();
        else
            return -1;

    }


}
