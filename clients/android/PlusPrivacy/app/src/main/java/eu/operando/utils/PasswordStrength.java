package eu.operando.utils;

import android.content.Context;
import android.support.v4.content.ContextCompat;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import eu.operando.R;

/**
 * Created by Alex on 12/15/2017.
 */

public class PasswordStrength {

    public final static int WEAK = 1;
    public final static int ACCEPTABLE = 2;
    public final static int STRONG = 3;
    public final static int VERY_STRONG = 4;
    public final static int WHITE_SPACES = 5;

    private String password;
    private Map<Integer, String> stringStates;

    public PasswordStrength(Context context, String password) {
        this.password = password;
        stringStates = new HashMap();;
        stringStates.put(WEAK, context.getResources().getString(R.string.weak));
        stringStates.put(ACCEPTABLE, context.getResources().getString(R.string.acceptable));
        stringStates.put(STRONG, context.getResources().getString(R.string.strong));
        stringStates.put(VERY_STRONG, context.getResources().getString(R.string.very_strong));
    }

    public String getStringForState(int state){
        return stringStates.get(state);
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean hasLowerCaseLetters() {
        return applyRegexToPassword("(?=.*[a-z])");
    }

    public boolean hasUpperCaseLetters() {
        return applyRegexToPassword("(?=.*[A-Z])");
    }

    public boolean hasDigits() {
        return applyRegexToPassword("(?=.*[0-9])");
    }

    public boolean hasSpecialCharacters() {
        return applyRegexToPassword("(?=.*[@#$%^&+=])");
    }

    public boolean hasNoWhiteSpaces() {
        return applyRegexToPassword("(?=\\S+$)");
    }

    public boolean applyRegexToPassword(String regex) {
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.find();
    }

    public int calculatePasswordStrength() {

        if (!hasNoWhiteSpaces()) return WHITE_SPACES;
        int length = password.length();
        if (length < 6) return WEAK;
        boolean hasLowerCaseLetters = hasLowerCaseLetters();
        boolean hasUpperCaseLetters = hasUpperCaseLetters();
        boolean hasDigits = hasDigits();
        boolean hasSpecialCharacters = hasSpecialCharacters();

        int score = -1;
        score += length/6;

        if (hasLowerCaseLetters){
            score++;
        }
        if (hasUpperCaseLetters){
            score++;
        }
        if (hasDigits){
            score++;
        }
        if (hasSpecialCharacters){
            score++;
        }

        if (score > 4)
            return VERY_STRONG;
        return score;
    }
}
