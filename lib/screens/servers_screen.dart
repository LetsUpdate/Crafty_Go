import 'dart:async';
import 'dart:convert';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/host_card.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialogs.dart';

class ServersScreen extends StatefulWidget {

  ServersScreen({Key key, this.title}) : super(key: key);
  CraftyClient client;
  final String title;

  @override
  _ServersScreenState createState() => _ServersScreenState();
}


class _ServersScreenState extends State<ServersScreen> {
  List<Stat> _serverStats = [];
  HostStatData _hostStats;
  List<String>  someImages;

  @override
  void initState() {
    super.initState();
    _refreshURL();
    _initImages();
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      _updateServerStats();
    });
  }

  void _refreshURL() async{
    final prefs= await SharedPreferences.getInstance();
    final apiKey=prefs.getString('apiKey');
    final url =prefs.getString('url');
    if(url==null||url.length<1||apiKey==null|| apiKey.length<30){
      await settingsDialog(context);
      _refreshURL();
    }else {
      widget.client = new CraftyClient(apiKey, url);
      _updateServerStats();
    }
  }

  void _updateServerStats() async {
    if(widget.client==null) {
      _refreshController.refreshFailed();
      return;
    }
    _serverStats = (await widget.client.getServerStats()).data;
    _hostStats = (await widget.client.getHostStats()).data;
    _refreshController.refreshCompleted();
    setState(() {});
  }


  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/ServerCardImgs/'))
        .toList();
    setState(() {
      someImages = imagePaths;
    });
  }

  Widget serverCardBuilder(BuildContext context, int index) {
    Stat stat = _serverStats[index];
    int i;
    if(index>someImages.length){
      i=someImages.length;
    }else{
      i=index;
    }

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
      background: AssetImage(someImages[index]),
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
