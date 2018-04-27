package aspectj.archinamon.alex.hookframework.xpoint.newdesign.semanticfirewall;

/**
 * Created by Alex on 26.04.2018.
 */

public class SensitiveData {

    private String name;
    private String pattern;
    private boolean regex;

    public SensitiveData(String name, String pattern) {
        this.name = name;
        this.pattern = pattern;
    }

    public SensitiveData(String name, String pattern, boolean regex) {
        this.name = name;
        this.pattern = pattern;
        this.regex = regex;
    }

    public CharSequence getPattern() {
        return pattern;
    }

    public String getName() {
        return name;
    }

    public boolean isRegex() {
        return regex;
    }
}
