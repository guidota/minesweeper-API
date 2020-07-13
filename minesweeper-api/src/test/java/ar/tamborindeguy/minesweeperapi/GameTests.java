package ar.tamborindeguy.minesweeperapi;

import static org.hamcrest.MatcherAssert.assertThat;

import ar.tamborindeguy.minesweeperapi.model.Game;
import ar.tamborindeguy.minesweeperapi.model.GameState;
import ar.tamborindeguy.minesweeperapi.model.cell.Cell;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

public class GameTests {

    @Test
    public void revealCellIsRevealed() {
        Game game = new Game(10, 10, 10);
        game.reveal(5, 5);
        assertThat("When revealing a cell it should be revealed", game.getCell(5, 5).isRevealed());
    }

    @Test
    public void firstRevealNeverIsMine() {
        Game game = new Game(10, 10, 10);
        game.reveal(5, 5);
        GameState state = game.getState();
        assertThat("You can't lose on first reveal", state != GameState.LOST);
    }

    @Test
    public void flagCellIsFlagged() {
        Game game = new Game(10, 10, 10);
        game.flag(false,5, 5);
        assertThat("When flagging a cell it should be flagged", game.getCell(5, 5).isFlagged());
    }

    @Test
    public void markCellIsMarked() {
        Game game = new Game(10, 10, 10);
        game.flag(true,5, 5);
        assertThat("When marking a cell it should be marked", game.getCell(5, 5).isQuestion());
    }

    @Test
    public void flagTwiceSetUnrevealed() {
        Game game = new Game(10, 10, 10);
        game.flag(false,5, 5);
        assertThat("When flagging a cell it should be flagged", game.getCell(5, 5).isFlagged());
        game.flag(false,5, 5);
        assertThat("Flag twice should set cell as unrevealed", !game.getCell(5, 5).isRevealed());
    }

    @Test
    public void revealFlaggedCellShouldReveal() {
        Game game = new Game(10, 10, 10);
        game.flag(false,5, 5);
        assertThat("When flagging a cell it should be flagged", game.getCell(5, 5).isFlagged());
        game.reveal(5, 5);
        assertThat("Reveal flagged cell should reveal", game.getCell(5, 5).isRevealed());
    }

    @Test
    public void firstRevealSetMines() {
        int mineCount = 10;
        Game game = new Game(mineCount, 10, 10);
        game.reveal(5,5); // first reveal will set mines
        // find mine
        List<Cell> mines = new ArrayList<>();
        for (int i = 0; i < game.getCols(); i++) {
            for (int j = 0; j < game.getRows(); j++) {
                Cell cell = game.getCell(i, j);
                if (cell.hasMine()) {
                    mines.add(cell);
                }
            }
        }
        assertThat("All mines should be set on first reveal", mines.size() == mineCount);
    }

    @Test
    public void revealMineAndLose() {
        Game game = new Game(10, 10, 10);
        game.reveal(5,5); // first reveal will set mines
        // find mine
        int mineCol = -1;
        int mineRow = -1;
        for (int i = 0; i < game.getCols(); i++) {
            if (mineRow >= 0) {
                break;
            }
            for (int j = 0; j < game.getRows(); j++) {
                Cell cell = game.getCell(i, j);
                if (cell.hasMine()) {
                    mineRow = j;
                    mineCol = i;
                    break;
                }
            }
        }
        game.reveal(mineCol, mineRow);
        GameState state = game.getState();
        assertThat("Revealing a mine should make you lose", state == GameState.LOST);
    }
}
