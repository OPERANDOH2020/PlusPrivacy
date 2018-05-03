package eu.operando.androidsdk.semanticfirewall.stringmatching;

/**
 * Created by Alex on 02.05.2018.
 */

public class PlainSensitiveData extends SensitiveData{


    public PlainSensitiveData(String name, String pattern) {
        super(name, pattern);
    }

    @Override
    public int match(String bodyString) {

        if (bodyString.contains(getPattern())) {

            return bodyString.indexOf(getPattern());
        }
        return -1;
    }
}
