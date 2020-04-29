import 'dart:async';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/host_card.dart';
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
  HostStatData _hostStats;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 10), (Timer t) {
      _updateServerStats();
    });
  }

  void _updateServerStats() async {
    _serverStats = (await widget.client.getServerStats()).data;
    _hostStats = (await widget.client.getHostStats()).data;
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
      body: SafeArea(
        child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _updateServerStats,
            header: WaterDropMaterialHeader(distance: 35),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 150.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.cyan, width: 4),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            image: DecorationImage(
                                image: AssetImage("images/asd.jpg"),
                                fit: BoxFit.cover)
                        ),
                        child: Center(child: HostStatCard(stat: _hostStats,)),
                      )
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(serverCardBuilder,
                      childCount: _serverStats.length
                  ),
                )
              ],
            )),
      ),
    );
  }

}
