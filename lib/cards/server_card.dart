import 'dart:ui';

import 'package:craftycommander/CraftyAPI/static/models/serverStat.dart';
import 'package:craftycommander/screens/players_screen.dart';
import 'package:craftycommander/utils/dialogs.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  final ServerStat stat;
  final ImageProvider background;
  final GestureTapCallback onTap;
  final TextStyle textStyle = new TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  final TextStyle sTextStyle = new TextStyle(color: Colors.white, fontSize: 16);

  ServerCard({Key key, this.stat, this.background, this.onTap}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var _infoBoard = [
    "Started at: ${stat.serverStartTime}",
    "World size: ${stat.worldSize}",
    "Sever type: ${stat.serverVersion}",
    "Description: ${stat.motd}"
    ];
    List<Widget> _infoList = new List();
    for (var x in _infoBoard ?? []) {
      _infoList.add(Text(
        x,
        style: sTextStyle,
      ));
    }

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.all(5),
        height: 215,
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 10.0,
            ),
          ],
          border: Border.all(
              color: stat.serverRunning ? Colors.green : Colors.red, width: 4),
          borderRadius: BorderRadius.all(Radius.circular(23)),
          image: DecorationImage(
              image: background,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken)),
        ),
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _DesignContainer(
              color: Colors.blue.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    stat.name,
                    style: textStyle,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(stat.serverRunning)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayersScreen(stat.serverId)));
                      else
                        utils.msgToUser('The server is offline\n no layers to show', true);
                      },
                    child: Text(
                      "${stat.onlinePlayers}/${stat.maxPlayers}",
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _DesignContainer(
                  color: Colors.blueGrey.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _infoList,
                  ),
                ),
                Column(
                  children: <Widget>[
                    _IconAndText(
                      icon: Icons.memory,
                      text: stat.memoryUsage,
                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                      textStyle: sTextStyle,
                    ),
                    _IconAndText(
                      icon: Icons.computer,
                      text: stat.cpuUsage.toString() + "%",
                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                      textStyle: sTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const _DesignContainer({Key key, this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)), color: color),
      child: child,
    );
  }
}

class _IconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;

  const _IconAndText(
      {Key key, this.icon, this.text, this.backgroundColor, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DesignContainer(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: textStyle.color,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
