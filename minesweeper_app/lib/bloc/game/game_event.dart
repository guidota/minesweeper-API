import 'package:meta/meta.dart';

@immutable
abstract class GameEvent {
  final String id;

  GameEvent(this.id);
}

class FetchEvent extends GameEvent {
  final String id;

  FetchEvent(this.id) : super(id);
}

class RevealEvent extends GameEvent {
  final int col;
  final int row;

  RevealEvent(this.col, this.row, String id) : super(id);
}

class FlagEvent extends GameEvent {
  final int col;
  final int row;
  final bool question;

  FlagEvent(this.question, this.col, this.row, String id) : super(id);
}
