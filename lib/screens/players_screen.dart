import 'dart:async';
import 'dart:developer';

import 'package:craftycommander/CraftyAPI/player_manager.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:craftycommander/globals.dart' as globals;

class PlayersScreen extends StatefulWidget {
  final int serverId;

  PlayersScreen(this.serverId);
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
   PlayerManager _playerManager;
   List<String> players;
   final _refreshController = new RefreshController();
  //the form of the players string: "['test', 'Protocoll']"
  @override
  void initState() {
    players = globals.user.getServersStatById(widget.serverId).getPlayerList();
    _playerManager = new PlayerManager(widget.serverId, globals.user.client);
    super.initState();
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (!this.mounted) {
        t.cancel();
        return;
      }
      _updatePlayers();
    });
  }

  void _updatePlayers()async{
    await globals.user.updateServerStats();
    players = globals.user.getServersStatById(widget.serverId).getPlayerList();
    setState(() {

    });
    _refreshController.refreshCompleted();
  }

  Widget _builder(BuildContext context, int index) {
    return _PlayerListItem(players[index]);
  }

  @override
  Widget build(BuildContext context) {
    final serverStat = globals.user.getServersStatById(widget.serverId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Online players: ${serverStat.onlinePlayers}/${serverStat.maxPlayers}'),backgroundColor: Colors.orange,),
        body:SmartRefresher(
            controller: _refreshController,
            onRefresh: _updatePlayers,
            child: ListView.builder(
              itemBuilder: _builder,
              itemCount: players.length,
            ),
          ),
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

