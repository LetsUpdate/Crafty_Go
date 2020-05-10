import 'dart:async';

import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:craftycommander/CraftyAPI/static/models/serverStat.dart';

import 'package:craftycommander/cards/server_card.dart';
import 'package:craftycommander/screens/cmd_screen.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:craftycommander/globals.dart' as globals;

class ServerConfigScreen extends StatefulWidget {
  final int serverID;
  final ImageProvider serverBackgroundImage;

  const ServerConfigScreen(this.serverBackgroundImage,this.serverID,
      {Key key, })
      : super(key: key);

  @override
  _ServerConfigScreenState createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  ServerStat stat;
  final _refreshController = new  RefreshController();



  Future<void> _updateServerStats() async {
    await globals.user.updateServerStats();
    for (var s in globals.user.serverStats) {
      if (s.serverId == stat.serverId) {
        setState(() {
          _refreshController.refreshCompleted();
          stat = s;
        });
        break;
      }
    }
    _refreshController.refreshFailed();
  }

  @override
  void initState() {
    super.initState();
    stat= globals.user.serverStats.where((element) => element.serverId==widget.serverID).toList().first;
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      // if the page is not exist already then turn off the timer
      if (!this.mounted) {
        t.cancel();
        return;
      }
      _updateServerStats();
    });
  }

  void _actionHandler(String action)async{
    action = action.toLowerCase();
    bool wantedState;
    dynamic response;
    switch (action){
      case 'start':
        response= await globals.user.client.startServer(stat.serverId);
        wantedState=true;
        break;
      case 'stop':
        response= await globals.user.client.stopServer(stat.serverId);
        wantedState=false;
        break;
      case 'restart':
        response= await globals.user.client.restartServer(stat.serverId);
        wantedState=true;
        break;
      default:
        utils.msgToUser("Action not found: $action", true);
    }
    //if(wantedState==stat.serverRunning)
      //return;
    if(response['status']==200){
      utils.msgToUser("Succes: ${response['data']}", false);
    }else{
      utils.msgToUser(response['errors'].toString(), true);
    }
    for(int i =0; i<5; i++){
      await _updateServerStats();
      if(stat.serverRunning==wantedState)
        return;
      else
        await Future.delayed(Duration(seconds: 2));
    }
  }
  void _openTerminal() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TerminalScreen(stat.serverId)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _updateServerStats,
        header: WaterDropMaterialHeader(distance: 35),
        child: Scaffold(
          body: Column(
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
                child: ServerCard(
                  stat: stat,
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
                            onTap: ()=>_actionHandler('start'),
                          ),
                          SettingButton(
                            iconData: Icons.stop,
                            text: "Stop",
                            color: Colors.red,
                            enabled: stat.serverRunning,
                            onTap: ()=>_actionHandler('stop'),
                          ),
                          SettingButton(
                            iconData: Icons.sync,
                            text: "Restart",
                            color: Colors.blue,
                            enabled: stat.serverRunning,
                            onTap: ()=>_actionHandler('restart'),
                          ),
                          SettingButton(
                            iconData: Icons.code,
                            text: "Terminal",
                            color: Colors.black,
                            iconColor: Colors.white,
                            onTap: _openTerminal,
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
  final Color iconColor;

  const SettingButton({Key key,
    this.iconData,
    this.text = "",
    this.color,
    this.onTap,
    this.enabled = true, this.iconColor=Colors.black})
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
                  color: iconColor,
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
