import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper_app/bloc/games/bloc.dart';
import 'package:minesweeper_app/views/create_game.dart';
import 'package:minesweeper_app/views/game.dart';

import 'model/game.dart';

void main() {
  runApp(MyApp());
}

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
          child: state is Fetching
              ? CircularProgressIndicator()
              : state is GamesInitial
                  ? Text("Try refreshing")
                  : _buildGameList(state as Games),
        ),
        persistentFooterButtons: [
          FlatButton(
            child: Row(
              children: [
                Icon(Icons.refresh),
                Text("Refresh"),
              ],
            ),
            onPressed: () => _fetchGames(context),
          ),
          FlatButton(
            child: Row(
              children: [
                Icon(Icons.add),
                Text("Create Game"),
              ],
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewGamePage(),
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

  Widget _buildGameList(Games state) {
    List<Game> games = state.games;
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) => ListTile(
        title: Text('Game ' + index.toString()),
        subtitle: Text('id: ' + games[index].id),
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
