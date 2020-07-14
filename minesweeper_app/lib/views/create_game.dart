import 'package:button_picker/button_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper_app/bloc/games/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:minesweeper_app/model/game.dart';
import 'dart:convert';

import '../main.dart';
import 'game.dart';

class NewGamePage extends StatelessWidget {
  final GamesBloc gamesBloc;

  const NewGamePage({Key key, this.gamesBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int mines = 10;
    int rows = 10;
    int columns = 10;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Game"),
      ),
      persistentFooterButtons: [
        FlatButton(
          child: Row(
            children: [
              Text("Create"),
              Icon(Icons.create),
            ],
          ),
          onPressed: () => _createGame(context, mines, rows, columns),
        )
      ],
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Mines"),
                  ButtonPicker(
                    step: 1,
                    initialValue: mines.toDouble(),
                    minValue: 8,
                    maxValue: 50,
                    onChanged: (value) => mines = value.toInt(),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rows"),
                  ButtonPicker(
                    step: 1,
                    initialValue: rows.toDouble(),
                    minValue: 8,
                    maxValue: 50,
                    onChanged: (value) => rows = value.toInt(),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Columns"),
                  ButtonPicker(
                    step: 1,
                    initialValue: columns.toDouble(),
                    minValue: 8,
                    maxValue: 50,
                    onChanged: (value) => columns = value.toInt(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createGame(BuildContext context, int mines, int rows, int columns) async {
    Navigator.of(context).pop();
    try {
      var res = await http.post(
        baseUrl + "games",
        body: json.encode({
          "mines": mines,
          "columns": columns,
          "rows": rows,
        }),
        headers: {"Content-Type": "application/json"},
      );
      print(res.body);
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameView(Game.fromJson(body)),
          ),
        );
      } else {
        gamesBloc.add(FetchEvent());
      }
    } catch (e) {
      print(e);
      gamesBloc.add(FetchEvent());
    }
  }
}
