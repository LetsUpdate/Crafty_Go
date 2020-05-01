import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ServerConfigScreen extends StatefulWidget {
  final CraftyClient client;
  Stat stat;

  ServerConfigScreen(this.client, this.stat, {Key key}) : super(key: key);

  @override
  _ServerConfigScreenState createState() {
    return _ServerConfigScreenState();
  }
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: ServerCard(
                name: widget.stat.name,
                players:
                    "${widget.stat.onlinePlayers}/${widget.stat.maxPlayers}",
                isRunning: widget.stat.serverRunning,
                ram: widget.stat.memoryUsage,
                cpu: widget.stat.cpuUsage,
                infoBoard: [
                  "Started at: ${widget.stat.serverStartTime}",
                  "World size: ${widget.stat.worldSize}",
                  "Sever type: ${widget.stat.serverVersion}",
                  "Description: ${widget.stat.motd}"
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
