import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:craftycommander/CraftyAPI/static/models/serverStat.dart';
import 'package:craftycommander/cards/host_card.dart';
import 'package:craftycommander/cards/server_card.dart';
import 'package:craftycommander/screens/server_config_screen.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:craftycommander/globals.dart'as globals;


class ServersScreen extends StatefulWidget {
  @override
  _ServersScreenState createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  List<String> someImages;

  @override
  void initState() {
    super.initState();
    initAsync();
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (!this.mounted) {
        t.cancel();
        return;
      }
      _updateServer();
    });
  }

  void initAsync()async{
    await _initImages();
    _updateServer();
  }

  Future<void> _onSettingsClicked() async {
    //todo open settings is missing
   utils.msgToUser('The lazy developer disabled this button', true);
  }


  Future<void> _updateServer() async {
    if (globals.user == null) {
      _refreshController.refreshFailed();
      return;
    }
    if(await globals.user.updateAll()) {
      log("Error during the update");
      _refreshController.refreshFailed();
    }else{
      _refreshController.refreshCompleted();
    }
    setState(() {});
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future _initImages() async {
    final manifestContent =
    await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/ServerCardImgs/'))
        .toList();
      someImages = imagePaths;
  }

  Widget serverCardBuilder(BuildContext context, int index) {
    ServerStat stat = globals.user.serverStats[index];
    int i;
    if (index > someImages.length) {
      i = someImages.length;
    } else {
      i = index;
    }

    return new ServerCard(
      stat: stat,
      background: AssetImage(someImages[i]),
      onTap: () => _openServerConfigScreen(stat, AssetImage(someImages[i])),
    );
  }

  void _openServerConfigScreen(ServerStat stat, ImageProvider provider) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServerConfigScreen(provider,stat.serverId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
            controller: _refreshController,
            onRefresh:_updateServer,
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
                            border: Border.all(color: Colors.cyan, width: 4),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            image: DecorationImage(
                                image: AssetImage("images/clouds.jpg"),
                                fit: BoxFit.cover)),
                        child: Center(
                            child: HostStatCard(
                              stat: globals.user.hostStats,
                              onTapSettings: _onSettingsClicked,
                            )),
                      )),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(serverCardBuilder,
                      childCount:someImages!=null? globals.user.serverStats.length:0),
                )
              ],
            )),
      ),
    );
  }
}
