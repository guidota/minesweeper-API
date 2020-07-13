package ar.tamborindeguy.minesweeperapi.model;

import ar.tamborindeguy.minesweeperapi.utils.Utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static ar.tamborindeguy.minesweeperapi.model.GameState.*;

public class Game {
    private int id;
    private int createdAt;

    private List<Mine> mines;
    private CellState[][] cells;
    private GameState state;

    private Game() {
    }

    public static Game create(int id, int mines, int col, int rows) {
        Game game = new Game();
        game.id = id;
        game.mines = new ArrayList<>();
        game.state = NEW;
        return game;
    }

    // col and row represents first touch, so it's a forbidden position for mines
    private void setMines(int col, int row) {
        int minesLeft = mines.size();
        int cols = cells.length;
        int rows = cells[0].length;
        while (minesLeft > 0) {
            int randomCol = Utils.getRandom(cols);
            int randomRow = Utils.getRandom(rows);
            if (randomCol != col && randomRow != row && !hasMine(randomCol, randomRow)) {
                mines.add(new Mine(randomCol, randomRow));
                minesLeft--;
            }
        }
    }

    private void updateState() {
        if (hasExploded()) {
            state = LOST;
        } else if (hasWon()) {
            state = WON;
        }
    }

    private boolean isRevealed(int col, int row) {
        return cells[col][row] == CellState.REVEALED;
    }

    private boolean isRedFlagged(int col, int row) {
        return cells[col][row] == CellState.FLAG;
    }

    private boolean isQuestion(int col, int row) {
        return cells[col][row] == CellState.QUESTION;
    }

    private boolean isValid(int col, int row) {
        return col >= 0 && col < cells.length && row >= 0 && row < cells[0].length;
    }

    private boolean hasMine(int col, int row) {
        return mines.stream().anyMatch(mine -> mine.getCol() == col && mine.getRow() == row);
    }

    private int adjacentMines(int col, int row) {
        int count = 0;
        for (int i = -1; i <= 1; i++) {
            int x = col + i;
            for (int j = -1; j <= 1; j++) {
                int y = row + j;
                if (isValid(x, y) && hasMine(x, y)) {
                    count++;
                }
            }
        }
        return count;
    }

    private long unrevealedCells() {
        return Arrays.stream(cells)
                .flatMap(Arrays::stream)
                .filter(cellState -> cellState == CellState.UNREVEALED)
                .count();
    }

    private boolean isFinished() {
        return hasExploded() || hasWon();
    }

    private boolean hasExploded() {
        return mines.stream().anyMatch(mine -> isRevealed(mine.getCol(), mine.getRow()));
    }

    private boolean hasWon() {
        return mines.size() == unrevealedCells();
    }

    public boolean reveal(int col, int row) {
        if (!isValid(col, row) || isFinished()) {
            return false;
        }
        // game rule, first touch never is a mine
        if (state == NEW) {
            setMines(col, row);
            state = STARTED;
        }
        if (!isRevealed(col, row)) {
            cells[col][row] = CellState.REVEALED;
            for (int i = -1; i <= 1; i++) {
                int x = col + i;
                for (int j = -1; j <= 1; j++) {
                    int y = row + j;
                    if (isValid(x, y) && !hasMine(x, y)) {
                        reveal(col, row);
                    }
                }
            }
        }
        updateState();
        return true;
    }

    public boolean flag(boolean question, int col, int row) {
        if (!isValid(col, row)) {
            return false;
        }
        if (question && isQuestion(col, row) || !question && isRedFlagged(col, row)) {
            cells[col][row] = CellState.UNREVEALED;
        } else {
            cells[col][row] = question ? CellState.QUESTION : CellState.FLAG;
        }
        return true;
    }

    public GameState getState() {
        return state;
    }
}
