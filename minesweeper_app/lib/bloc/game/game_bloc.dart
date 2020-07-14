import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:minesweeper_app/model/game.dart';
import 'dart:convert';
import 'bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(String id) : super(GameInitial(id));

  @override
  Stream<GameState> mapEventToState(
    GameEvent event,
  ) async* {
    if (event is FetchEvent) {
      yield* _mapFetchToState(event);
    } else if (event is FlagEvent) {
      yield* _mapFlagToState(event);
    } else if (event is RevealEvent) {
      yield* _mapRevealToState(event);
    }
  }

  Stream<GameState> _mapRevealToState(RevealEvent event) async* {
    try {
      final res = await http.post(
        "http://localhost:8081/games/" + event.id + '/reveal/',
        body: json.encode(
            {"column": event.col.toString(), "row": event.row.toString()}),
        headers: {"Content-Type": "application/json"},
      );
      print(res.body);
      if (res.statusCode == 200) {
        add(FetchEvent(event.id));
      } else {
        print(res);
        yield Failed();
      }
    } catch (e) {
      print(e);
      yield Failed();
    }
  }

  Stream<GameState> _mapFlagToState(FlagEvent event) async* {
    try {
      final res = await http.post(
        "http://localhost:8081/games/" + event.id + '/flag/',
        body: json.encode(
            {"column": event.col.toString(), "row": event.row.toString()}),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        add(FetchEvent(event.id));
      } else {
        print(res.body);
        print(res.statusCode);
        yield Failed();
      }
    } catch (e) {
      print(e);
      yield Failed();
    }
  }

  Stream<GameState> _mapFetchToState(FetchEvent event) async* {
    yield Fetching();
    try {
      final res = await http.get(
          "http://localhost:8081/games/" + event.id + '/',
          headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        yield GameFetched(Game.fromJson(body));
      } else {
        print(res);
        yield Failed();
      }
    } catch (e) {
      print(e);
      yield Failed();
    }
  }
}
