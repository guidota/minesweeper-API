import 'package:meta/meta.dart';

@immutable
abstract class GamesEvent {}

class FetchEvent extends GamesEvent {}

class DeleteEvent extends GamesEvent {
  final String id;

  DeleteEvent(this.id);
}

class CreateEvent extends GamesEvent {
  final int mines;
  final int rows;
  final int columns;

  CreateEvent(this.mines, this.rows, this.columns);
}
