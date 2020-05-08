import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PlayersScreen extends StatefulWidget {
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final List<String> players=['asd','asd'];



  Widget _builder(BuildContext context, int index) {
    return _PlayerListItem(players[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: _builder,
        itemCount: players.length,
      ),
    );
  }
}

class _PlayerListItem extends StatelessWidget {
  final String playerName;

  const _PlayerListItem(this.playerName, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.5),
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              playerName,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.memoryNetwork(
                image: "https://minotar.net/avatar/$playerName/50.png",
                fadeInCurve: Curves.fastOutSlowIn,
                width: 50,
                placeholder: kTransparentImage,
              )),
        ],
      ),
    );
  }
}

