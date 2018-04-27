package aspectj.archinamon.alex.hookframework.xpoint.newdesign.semanticfirewall.stringmatching;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by Alex on 26.04.2018.
 */

public abstract class AbstractMultipleExactStringMatcher {

    public abstract List<MatchingResult> match(String text, String... patterns);

    protected String[] filterPatterns(String[] patterns) {
        Set<String> filter = new HashSet<>(Arrays.asList(patterns));
        return filter.toArray(new String[filter.size()]);
    }

    /**
     * This class represents a match.
     */
    public static final class MatchingResult {

        /**
         * The index of the pattern being matched.
         */
        public final int patternIndex;

        /**
         * The index of the last character in a pattern indexed by
         * {@code patternIndex}.
         */
        public final int concludingIndex;

        public MatchingResult(int patternIndex, int concludingIndex) {
            this.patternIndex = patternIndex;
            this.concludingIndex = concludingIndex;
        }

        @Override
        public boolean equals(Object o) {
            if (o == null) {
                return false;
            }

            if (!getClass().equals(o.getClass())) {
                return false;
            }

            MatchingResult arg = (MatchingResult) o;

            return patternIndex == arg.patternIndex
                    && concludingIndex == arg.concludingIndex;
        }

        @Override
        public int hashCode() {
            int hash = 5;
            hash = 41 * hash + this.patternIndex;
            hash = 41 * hash + this.concludingIndex;
            return hash;
        }

        public String toString() {
            return "(patternIndex = " + patternIndex +
                    ", concludingIndex = " + concludingIndex + ")";
        }
    }
}
