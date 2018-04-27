package aspectj.archinamon.alex.hookframework.xpoint.newdesign.semanticfirewall.stringmatching;

import java.util.Random;

/**
 * Created by Alex on 27.04.2018.
 */

public class Utils {

    public static String getText(int size, Random random) {
        StringBuilder sb = new StringBuilder(size);

        for (int i = 0; i < size; ++i) {
            sb.append(randomCharacter('a', 'b', random));
        }

        return sb.toString();
    }

    private static char randomCharacter(char a, char b, Random random) {
        return (char)(a + (random.nextInt(b - a)));
    }
}
