import 'dart:async';

import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'CraftyAPI/craftyAPI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Crafty Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  CraftyClient client = new CraftyClient(
      "DOM5VF7D3JHLXUOBPUR3N9UQO5FLXKPJ", "192.168.0.234:8000");
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  RefreshController(initialRefresh: false);

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
        "Autostart is ${stat.serverRunning}",
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
        ));
  }
}
