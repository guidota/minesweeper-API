import 'package:meta/meta.dart';
import 'package:minesweeper_app/model/game.dart';

@immutable
abstract class GamesState {}

class GamesInitial extends GamesState {}

class Fetching extends GamesState {}

class Games extends GamesState {
  final List<Game> games;

  Games(this.games);
}

class NewGame extends GamesState {
  final Game game;
  NewGame(this.game);
}

class Failed extends GamesState {}
