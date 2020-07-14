import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper_app/bloc/games/bloc.dart';
import 'package:minesweeper_app/views/create_game.dart';
import 'package:minesweeper_app/views/game.dart';

import 'model/game.dart';

void main() {
  runApp(MyApp());
}

const String baseUrl = "https://bref-mandarine-95959.herokuapp.com/";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minesweeper',
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => GamesBloc()..add(FetchEvent()),
        child: MyHomePage(title: 'Minesweeper'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: state is Fetching || state is NewGame
              ? CircularProgressIndicator()
              : state is GamesInitial
                  ? Text("Try refreshing")
                  : _buildGameList(state as Games),
        ),
        persistentFooterButtons: [
          FlatButton(
            child: Row(
              children: [
                Text("Refresh"),
                Icon(Icons.refresh),
              ],
            ),
            onPressed: () => _fetchGames(context),
          ),
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("New Game"),
                Icon(Icons.add),
              ],
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (pageContext) => NewGamePage(
                  gamesBloc: BlocProvider.of(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _fetchGames(BuildContext context) {
    BlocProvider.of<GamesBloc>(context).add(FetchEvent());
  }

  _deleteGame(BuildContext context, String id) {
    BlocProvider.of<GamesBloc>(context).add(DeleteEvent(id));
  }

  Widget _buildGameList(Games state) {
    List<Game> games = state.games;
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) => ListTile(
        title: Text('Game ' + games[index].state),
        subtitle: Text('id: ' + games[index].id),
        trailing: FlatButton(
          child: Icon(Icons.delete_outline),
          onPressed: () => _deleteGame(context, games[index].id),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameView(games[index]),
          ),
        ),
      ),
    );
  }
}
