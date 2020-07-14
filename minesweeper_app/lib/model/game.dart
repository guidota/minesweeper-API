import 'cell.dart';

class Game {
  String id;
  int mines;
  String state;
  List<List<Cell>> cells;

  Game(this.id, this.mines, this.state, this.cells);

  Game.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        mines = json["mines"] as int,
        state = json["state"],
        cells = readCells(json['cells']);

  static List<List<Cell>> readCells(dynamic jsonObject) {
    List<List<Cell>> cells = new List<List<Cell>>();
    if (jsonObject != null) {
      for (Iterable row in jsonObject) {
        if (row == null) continue;
        List<Cell> cellRow = new List<Cell>();
        for (String symbol in row) {
          cellRow.add(Cell(symbol));
        }
        cells.add(cellRow);
      }
    }
    return cells;
  }
}
