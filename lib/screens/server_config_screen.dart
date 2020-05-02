import 'dart:async';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:craftycontroller/cards/server_card.dart';
import 'package:craftycontroller/utils/utils.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerConfigScreen extends StatefulWidget {
  final CraftyClient client;
  final Stat _stat;
  final ImageProvider serverBackgroundImage;

  const ServerConfigScreen(this.client, this._stat, this.serverBackgroundImage,
      {Key key})
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


//todo delayed refresh
  void _startServer() async {
    final isNoError = await widget.client.startServer(stat.serverId);
    utils.msgToUser(
        isNoError ? "Started!" : "Error: Could not start or already started",
        !isNoError
    );
    _updateServerStats();
  }

  void _stopServer() async {
    final isNoError = await widget.client.stopServer(stat.serverId);
    utils.msgToUser(
        isNoError ? "Stopping!" : "Stop error",
        !isNoError
    );
    _updateServerStats();
  }

  void _restartServer() async {
    final isNoError = await widget.client.restartServer(stat.serverId);
    utils.msgToUser(
        isNoError ? "Restarting!" : "Error in restart",
        !isNoError
    );
    _updateServerStats();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        bottom: false,
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75))
                  ],
                  border: Border.all(color: Colors.cyan, width: 4),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  image: DecorationImage(
                      image: AssetImage("images/clouds.jpg"),
                      fit: BoxFit.cover)),
              child: ServerCard( //todo too bih
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
                background: widget.serverBackgroundImage,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/test.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: ListView(
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: <Widget>[
                        SettingButton(
                          iconData: Icons.play_arrow,
                          text: "Start",
                          color: Colors.green,
                          enabled: !stat.serverRunning,
                          onTap: _startServer,
                        ),
                        SettingButton(
                          iconData: Icons.stop,
                          text: "Stop",
                          color: Colors.red,
                          enabled: stat.serverRunning,
                          onTap: _stopServer,
                        ),
                        SettingButton(
                          iconData: Icons.sync,
                          text: "Restart",
                          color: Colors.blue,
                          enabled: stat.serverRunning,
                          onTap: _restartServer,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;
  final GestureTapCallback onTap;
  final bool enabled;

  const SettingButton({Key key,
    this.iconData,
    this.text = "",
    this.color,
    this.onTap,
    this.enabled = true})
      : super(key: key);
  static const TextStyle _style = TextStyle(color: Colors.white, fontSize: 20);
  static const Color _disabledColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap ?? () {} : () {},
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.lerp(
                  enabled ? color : _disabledColor, Colors.black, 0.3)
                  .withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: enabled ? color : _disabledColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  iconData,
                  size: _style.fontSize * 2.5,
                ),
              ),
              Text(
                text,
                style: _style,
              )
            ],
          )),
    );
  }
}
