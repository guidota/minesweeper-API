import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:minesweeper_app/model/game.dart';
import 'dart:convert';
import 'bloc.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc() : super(GamesInitial());

  @override
  Stream<GamesState> mapEventToState(
    GamesEvent event,
  ) async* {
    if (event is FetchEvent) {
      yield* _mapFetchToState();
    }
  }

  Stream<GamesState> _mapFetchToState() async* {
    yield Fetching();
    try {
      final res = await http.get("http://localhost:8081/games/",
          headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print(body);
        List<Game> games = [];
        for (Map map in body) {
          games.add(Game.fromJson(map));
        }
        yield Games(games);
      }
    } catch (e) {
      print(e);
      yield Failed();
    }
  }
}
