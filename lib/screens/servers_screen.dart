import 'dart:async';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ServersScreen extends StatefulWidget {
  ServersScreen({Key key, this.title}) : super(key: key);
  CraftyClient client = new CraftyClient(
      "DOM5VF7D3JHLXUOBPUR3N9UQO5FLXKPJ", "192.168.0.234:8000");
  final String title;

  @override
  _ServersScreenState createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  List<Stat> _serverStats = [];

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 10), (Timer t) {
      _updateServerStats();
    });
  }

  void _updateServerStats() async {
    _serverStats = (await widget.client.getServerStats()).data;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  //region refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  //endregion

  Widget serverCardBuilder(BuildContext ctxt, int index) {
    Stat stat = _serverStats[index];
    return new ServerCard(
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
      background: AssetImage("images/backgroundSample.png"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _updateServerStats,
        header: WaterDropMaterialHeader(distance: 35),
        child: ListView.builder(
          itemBuilder: serverCardBuilder,
          itemCount: _serverStats.length,
        ),
      ),
    );
  }
}
