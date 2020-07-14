package ar.tamborindeguy.minesweeperapi.utils;

import java.util.Random;

public class Utils {

    private static final Random RANDOM = new Random();

    public static int getRandom(int max) {
        return RANDOM.nextInt(max);
    }

    public static int distance(int x1, int y1, int x2, int y2){
        return Math.abs(x1 - x2) + Math.abs(y1 - y2);
    }
}
