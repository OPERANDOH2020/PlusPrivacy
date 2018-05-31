package eu.operando.androidsdk.semanticfirewall.stringmatching;

/**
 * Created by Alex on 26.04.2018.
 */

public abstract class SensitiveData {

    private String name;
    private String pattern;

    public SensitiveData(String name, String pattern) {
        this.name = name;
        this.pattern = pattern;
    }

    public String getPattern() {
        return pattern;
    }

    public String getName() {
        return name;
    }

    public abstract int match(String bodyString);

}
