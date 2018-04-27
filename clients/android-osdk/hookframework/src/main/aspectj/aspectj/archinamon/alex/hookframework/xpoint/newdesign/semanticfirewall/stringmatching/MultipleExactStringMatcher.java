package aspectj.archinamon.alex.hookframework.xpoint.newdesign.semanticfirewall.stringmatching;

import android.util.Log;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;

/**
 * Created by Alex on 27.04.2018.
 */

public class MultipleExactStringMatcher {

    private static final int ITERATIONS = 100;
    private static final int TEXT_LENGTH = 100;
    private static final int MAXIMUM_PATTERN_LENGTH = 30;
    private static final int MAXIMUM_PATTERNS = 10;

    public void testMatchers() {

        AbstractMultipleExactStringMatcher matcher2 = new AhoCorasickMatcher();

        Set<AbstractMultipleExactStringMatcher.MatchingResult> set2 = new HashSet<>();

        long seed = System.nanoTime();
        Random random = new Random(seed);


        String text = "Mama are mere, tata are pere.";

        String[] patterns =
                new String[]{"are", "pere"};

        for (String pat : patterns) {
            if (text.contains(pat)) {
                Log.e(" matches ", pat);
            } else {
                Log.e(" matches ", "NO MATCH");
            }
        }

//            set2.clear();
//            set2.addAll(matcher2.match(text, patterns));
//            Log.e("Set2: ", Arrays.toString(set2.toArray()));

    }

}