import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper_app/bloc/game/bloc.dart';
import 'package:minesweeper_app/model/game.dart';

import 'cell_widget.dart';

class GameView extends StatelessWidget {
  final Game game;

  GameView(this.game);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider<GameBloc>(
        create: (context) => GameBloc(game.id)..add(FetchEvent(game.id)),
        child: GameWidget(),
      ),
    );
  }
}

class GameWidget extends StatelessWidget {
  const GameWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) => Board(),
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameFetched) {
          if (state.game.state == "new") {
            return;
          }
          Color color = Colors.green[400];
          String text = "Game updated";
          int duration = 400;
          if (state.game.state == "won") {
            color = Colors.green[600];
            text = "You win!";
            duration = 1000;
          } else if (state.game.state == "lost") {
            color = Colors.red[300];
            text = "Game over";
            duration = 1000;
          }
          Scaffold.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: duration),
              content: Text(
                text,
                style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: color,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous is Fetching && current is GameFetched,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (state is GameFetched)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Mines: " + (state).game.mines.toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Game: " + (state).game.state),
                    ),
                  ],
                )
              : Container(),
          Container(
            child: state is GameFetched
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (state)
                        .game
                        .cells
                        .asMap()
                        .map(
                          (y, row) => MapEntry(
                            y,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: row
                                  .asMap()
                                  .map(
                                    (x, cell) => MapEntry(
                                        x,
                                        CellWidget(
                                            game: (state).game,
                                            cell: cell,
                                            x: x,
                                            y: y)),
                                  )
                                  .values
                                  .toList(),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
