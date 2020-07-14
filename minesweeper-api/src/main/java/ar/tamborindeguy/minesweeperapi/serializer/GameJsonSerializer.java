package ar.tamborindeguy.minesweeperapi.serializer;

import ar.tamborindeguy.minesweeperapi.model.Game;
import ar.tamborindeguy.minesweeperapi.model.GameState;
import ar.tamborindeguy.minesweeperapi.model.cell.Cell;
import com.google.gson.*;

import java.lang.reflect.Type;

public class GameJsonSerializer implements JsonSerializer<Game> {
    @Override
    public JsonElement serialize(Game src, Type typeOfSrc, JsonSerializationContext context) {
        JsonObject element = new JsonObject();
        element.addProperty("id", src.getId());
        element.addProperty("mines", src.getMines());
        element.addProperty("state", src.getState().toString());
        JsonArray cells = new JsonArray();
        for (int row = 0; row < src.getRows(); row++) {
            JsonArray rowArray = new JsonArray();
            for (int col = 0; col < src.getCols(); col++) {
                rowArray.add(cellToString(src, col, row));
            }
            cells.add(rowArray);
        }
        element.add("cells", cells);
        return element;
    }

    private String cellToString(Game src, int col, int row) {
        String cellString;
        GameState state = src.getState();
        Cell cell = src.getCell(col, row);
        boolean gameFinished = state == GameState.WON || state == GameState.LOST;
        if (cell.isFlagged() && state != GameState.LOST) {
            cellString = "F";
        } else if (cell.isQuestion() && state != GameState.LOST) {
            cellString = "?";
        } else if (!cell.isRevealed() && !gameFinished) {
            cellString = " ";
        } else if (cell.isRevealed() || gameFinished) {
            if (cell.hasMine()) {
                cellString = "X";
            } else {
                int adjacentMines = src.adjacentMines(col, row);
                cellString = adjacentMines == 0 ? "_" : String.valueOf(adjacentMines);
            }
        } else  {
            cellString = "_";
        }
        return cellString;
    }

}
