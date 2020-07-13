package ar.tamborindeguy.minesweeperapi.model;

public class Mine {
    private final int col;
    private final int row;

    public Mine(int col, int row) {
        this.col = col;
        this.row = row;
    }

    public int getCol() {
        return col;
    }

    public int getRow() {
        return row;
    }

}
