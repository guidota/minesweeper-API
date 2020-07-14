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
      builder: (context, state) => Container(
        child: state is GameFetched
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: state.game.cells
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
                                        game: state.game,
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
    );
  }
}
