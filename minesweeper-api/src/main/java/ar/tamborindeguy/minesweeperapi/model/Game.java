package ar.tamborindeguy.minesweeperapi.model;

import ar.tamborindeguy.minesweeperapi.model.cell.Cell;
import ar.tamborindeguy.minesweeperapi.utils.Utils;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Arrays;

import static ar.tamborindeguy.minesweeperapi.model.GameState.*;

@Document(collection = "games")
public class Game {

    private @Id String id;
    private int mines;
    private Cell[][] cells;

    public Game() {}

    public Game(int mines, int col, int rows) {
        this.mines = mines;
        this.cells = new Cell[col][rows];
        initCells();
    }

    private void initCells() {
        for (int i = 0; i < cells.length; i++) {
            for (int j = 0; j < cells[0].length; j++) {
                cells[i][j] = new Cell();
            }
        }
    }

    // col and row represent first touch, so it's a forbidden position for mines
    private void setMines(int col, int row) {
        int minesLeft = mines;
        int cols = cells.length;
        int rows = cells[0].length;
        while (minesLeft > 0) {
            int randomCol = Utils.getRandom(cols);
            int randomRow = Utils.getRandom(rows);
            Cell cell = getCell(randomCol, randomRow);
            if (Utils.distance(col, row, randomCol, randomRow) > 2 && !cell.hasMine()) {
                cell.setMine();
                minesLeft--;
            }
        }
    }

    private boolean isValid(int col, int row) {
        return col >= 0 && col < cells.length && row >= 0 && row < cells[0].length;
    }

    private long unrevealedCells() {
        return Arrays.stream(cells)
                .flatMap(Arrays::stream)
                .filter(cell -> !cell.isRevealed())
                .count();
    }

    private long minesSet() {
        return Arrays.stream(cells)
                .flatMap(Arrays::stream)
                .filter(Cell::hasMine)
                .count();
    }

    private boolean hasExploded() {
        return Arrays.stream(cells)
                .flatMap(Arrays::stream)
                .filter(Cell::hasMine)
                .anyMatch(Cell::isRevealed);
    }

    private boolean hasWon() {
        return mines == unrevealedCells();
    }

    public Cell getCell(int col, int row) {
        return cells[col][row];
    }

    public int adjacentMines(int col, int row) {
        int count = 0;
        for (int i = -1; i <= 1; i++) {
            int x = col + i;
            for (int j = -1; j <= 1; j++) {
                int y = row + j;
                if (isValid(x, y) && getCell(x, y).hasMine()) {
                    count++;
                }
            }
        }
        return count;
    }

    public boolean reveal(int col, int row) {
        if (!isValid(col, row)) {
            return false;
        }

        GameState state = getState();
        if (state == WON || state == LOST) {
            return false;
        }
        // game rule, first touch never is a mine
        if (state == NEW) {
            setMines(col, row);
        }

        doReveal(col, row);
        return true;
    }

    private void doReveal(int col, int row) {
        Cell cell = getCell(col, row);
        if (!cell.isRevealed()) {
            cell.reveal();
            if (adjacentMines(col, row) > 0) {
                return;
            }
            for (int i = -1; i <= 1; i++) {
                int x = col + i;
                for (int j = -1; j <= 1; j++) {
                    int y = row + j;
                    if (isValid(x, y) && !getCell(x, y).hasMine()) {
                        doReveal(x, y);
                    }
                }
            }
        }
    }

    public boolean flag(boolean question, int col, int row) {
        if (!isValid(col, row) || getCell(col, row).isRevealed()) {
            return false;
        }
        Cell cell = getCell(col, row);
        if (question) {
            cell.mark();
        } else {
            cell.flag();
        }
        return true;
    }

    public GameState getState() {
        GameState state;
        if (minesSet() == 0) {
            state = NEW;
        } else if (hasWon()) {
            state = WON;
        } else if (hasExploded()) {
            state = LOST;
        } else {
            state = STARTED;
        }

        return state;
    }

    public String getId() {
        return id;
    }

    public int getMines() {
        return mines;
    }

    public int getCols() {
        return cells.length;
    }

    public int getRows() {
        return cells[0].length;
    }
}
