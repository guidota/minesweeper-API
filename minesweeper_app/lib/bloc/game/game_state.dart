import 'package:meta/meta.dart';
import 'package:minesweeper_app/model/game.dart';

@immutable
abstract class GameState {}

class GameInitial extends GameState {
  final String id;

  GameInitial(this.id);
}

class Fetching extends GameState {}

class GameFetched extends GameState {
  final Game game;

  GameFetched(this.game);
}

class Failed extends GameState {}
