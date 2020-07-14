import 'package:meta/meta.dart';

@immutable
abstract class GamesEvent {}

class FetchEvent extends GamesEvent {}

class CreateEvent extends GamesEvent {
  final int mines;
  final int rows;
  final int columns;

  CreateEvent(this.mines, this.rows, this.columns);
}
