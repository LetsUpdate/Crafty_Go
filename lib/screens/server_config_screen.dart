import 'dart:async';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerConfigScreen extends StatefulWidget {
  final CraftyClient client;
  final Stat _stat;

  const ServerConfigScreen(this.client, this._stat, {Key key})
      : super(key: key);

  @override
  _ServerConfigScreenState createState() => _ServerConfigScreenState(_stat);
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  Stat stat;

  _ServerConfigScreenState(this.stat);

  void _updateServerStats() async {
    var stats = await widget.client.getServerStats();
    for (var s in stats.serverStat) {
      if (s.serverId == stat.serverId) {
        setState(() {
          stat = s;
        });
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 10), (Timer t) {
      // if the page is not exist already then turn off the timer
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
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75)
                    )
                  ],
                  border: Border.all(color: Colors.cyan, width: 4),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  image: DecorationImage(
                      image: AssetImage("images/clouds.jpg"),
                      fit: BoxFit.cover)),
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
                background: AssetImage("images/clouds.jpg"),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Text("asd"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  final String settingName;
  final String buttonText;

  const Setting({Key key, this.settingName, this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
