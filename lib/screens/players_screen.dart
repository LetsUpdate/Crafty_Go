import 'dart:async';

import 'package:craftycommander/CraftyAPI/player_manager.dart';
import 'package:craftycommander/globals.dart' as globals;
import 'package:craftycommander/screens/server_config_screen.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlayersScreen extends StatefulWidget {
  final int serverId;

  PlayersScreen(this.serverId);
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  PlayerManager _playerManager;
  bool selecting = false;
  List<String> players;
  final _refreshController = new RefreshController();
  //the form of the players string: "['test', 'Protocoll']"
  @override
  void initState() {
    players = [
      'fake1',
      'fake2',
      'fake3'
    ]; //globals.user.getServersStatById(widget.serverId).getPlayerList();
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

  void _updatePlayers() async {
    await globals.user.updateServerStats();
    players = [
      'fake1',
      'fake2',
      'fake3'
    ]; //htop globals.user.getServersStatById(widget.serverId).getPlayerList();
    setState(() {
      selecting = !selecting;
    });
    _refreshController.refreshCompleted();
  }

  Widget _builder(BuildContext context, int index) {
    if (index > players.length - 1)
      return SizedBox(
        height: 100,
      );
    return GestureDetector(
        onTap: () => utils.openDialog(context, _openDialog(players[index])),
        child: _PlayerListItem(players[index]));
  }

  @override
  Widget build(BuildContext context) {
    final serverStat = globals.user.getServersStatById(widget.serverId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Online players: ${serverStat.onlinePlayers}/${serverStat.maxPlayers}'),
          backgroundColor: Colors.orange,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _updatePlayers,
          child: ListView.builder(
            itemBuilder: _builder,
            itemCount: selecting ? players.length + 1 : players.length,
          ),
        ),
      ),
    );
  }

  _runAction(PlayerActions playerAction, String playerName) async {
    final isError =
        await _playerManager.runPlayerAction(playerAction, playerName);
    _response(isError);
  }

  void _response(bool isError) {
    if (isError) {
      utils.msgToUser("Send failed", isError);
    } else {
      utils.msgToUser("Sent!", isError);
    }
  }

  _openDialog(String player) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              SettingButton(
                iconData: Icons.offline_bolt,
                text: 'OP',
                color: Colors.blue,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              SettingButton(
                iconData: Icons.remove_circle_outline,
                text: 'DE-OP',
                color: Colors.blue,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              SettingButton(
                iconData: Icons.close,
                text: "kick",
                color: Colors.yellow,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              SettingButton(
                iconData: Icons.warning,
                text: "Kill",
                color: Colors.red,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              SettingButton(
                iconData: Icons.delete,
                text: "ban",
                color: Colors.red,
                iconColor: Colors.black,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              SettingButton(
                iconData: Icons.details,
                text: "Close",
                color: Colors.white,
                iconColor: Colors.black,
                size: 18,
                onTap: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}

class _PlayerListItem extends StatefulWidget {
  final String playerName;

  const _PlayerListItem(this.playerName, {Key key}) : super(key: key);

  @override
  __PlayerListItemState createState() => __PlayerListItemState();
}

class __PlayerListItemState extends State<_PlayerListItem> {
  bool opened = false;

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
              widget.playerName,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage.assetNetwork(
              image: "https://minotar.net/avatar/${widget.playerName}/50.png",
              fadeInCurve: Curves.linear,
              width: 50,
              placeholder: 'images/steve.png',
            ),
          ),
        ],
      ),
    );
  }
}