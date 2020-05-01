import 'dart:async';
import 'dart:developer';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ServerConfigScreen extends StatefulWidget {
  final CraftyClient client;
  final Stat stat;

  const ServerConfigScreen(this.client, this.stat, {Key key}) : super(key: key);

  @override
  _ServerConfigScreenState createState() {
    return _ServerConfigScreenState(stat);
  }
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  Stat stat;

  _ServerConfigScreenState(this.stat);

  void _updateServerStats() async {
    var stats = await widget.client.getServerStats();
    for (var s in stats.serverStat){
      if (s.id == widget.stat.id) {
        setState(() {stat=s;});
        log("weeee");
        break;
      }}

    setState(() {stat;});
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (!this.mounted) {
        t.cancel();
        return;
      }
      _updateServerStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: ServerCard(
                name: stat.name,
                players: "${stat.onlinePlayers}/${stat.maxPlayers}",
                isRunning: stat.serverRunning,
                ram: stat.memoryUsage,
                cpu: stat.cpuUsage,
                infoBoard: [
                  "Started at: ${stat.serverStartTime}",
                  "World size: ${stat.worldSize}",
                  "Sever type: ${stat.serverVersion}",
                  "Description: ${stat.motd}"
                ],
                background: AssetImage("images/asd.jpg"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
