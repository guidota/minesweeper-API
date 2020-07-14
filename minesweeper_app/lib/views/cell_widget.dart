import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper_app/bloc/game/bloc.dart';
import 'package:minesweeper_app/model/cell.dart';
import 'package:minesweeper_app/model/game.dart';

class CellWidget extends StatelessWidget {
  final Game game;
  final Cell cell;
  final int x;
  final y;
  const CellWidget({
    key,
    this.game,
    this.cell,
    this.x,
    this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        child: GestureDetector(
          onTap: () => !isRevealed() ? _reveal(context, game.id, x, y) : null,
          onSecondaryTap: () =>
              !isRevealed() ? _flag(context, game.id, x, y) : null,
          child: Card(
            child: SizedBox(
              height: 32,
              width: 32,
              child: Center(
                child: Text(cell.symbol),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isRevealed() {
    return cell.symbol != " " && cell.symbol != "F" && cell.symbol != "?";
  }

  _reveal(BuildContext context, String id, int x, int y) {
    BlocProvider.of<GameBloc>(context).add(RevealEvent(x, y, id));
  }

  _flag(BuildContext context, String id, int x, int y) {
    BlocProvider.of<GameBloc>(context).add(FlagEvent(false, x, y, id));
  }
}
