package ar.tamborindeguy.minesweeperapi.utils;

import java.util.Random;

public class Utils {

    private static final Random RANDOM = new Random();

    public static int getRandom(int max) {
        return RANDOM.nextInt(max);
    }

}
