import 'dart:async';

import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:craftycommander/CraftyAPI/static/models/log_line.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:craftycommander/globals.dart' as globals;

class TerminalScreen extends StatefulWidget {
  final int serverId;
  const TerminalScreen(this.serverId, {Key key}) : super(key: key);
  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  List<LogLine> lines;
  final _scrollController = new ScrollController();
  final TextEditingController _textEditingController =
      new TextEditingController();

  bool autoScroll = true;

  //todo this method of frenching terminal is not very effective, but the api is not support other yet
  Future<void> _updateConsole() async {
    lines = (await globals.user.client.getServerLogs(widget.serverId))
        .reversed
        .toList();
    setState(() {
      _scrollController.animateTo(0,
          duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    });
  }

  void _sendCommand(String command) async {
    command = command.trim();
    _textEditingController.clear();
    if (command.length > 0)
      globals.user.client.runCommand(widget.serverId, command);
    else
      utils.msgToUser("You can't send nothing", true);
  }

  @override
  void initState() {
    super.initState();
    //todo fix the auto scroll
    _updateConsole();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    lines != null
                        ? ListView.builder(
                            controller: _scrollController,
                            itemBuilder: (context, index) =>
                                _ConsoleTile(lines[index]),
                            itemCount: lines.length,
                            reverse: true,
                            shrinkWrap: true,
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Autoscroll',
                              style: TextStyle(fontSize: 15),
                            ),
                            Checkbox(
                              onChanged: (checked) {
                                setState(() {
                                  autoScroll = checked;
                                });
                              },
                              value: autoScroll,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white30),
                        child: IconButton(
                          icon: Icon(
                            Icons.sync,
                            color: Colors.white,
                          ),
                          onPressed: _updateConsole,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onSubmitted: _sendCommand,
                        controller: _textEditingController,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _sendCommand(_textEditingController.text);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          "Send!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsoleTile extends StatelessWidget {
  final LogLine line;
  static const style = TextStyle(color: Colors.white, fontSize: 13);
  const _ConsoleTile(this.line, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String time = line.message.substring(0, 10);
    final int lineNum = line.lineNum;
    final typeAndContent = line.message.substring(11).split(':');
    final type = typeAndContent[0];
    final msg = typeAndContent.sublist(1).join();

    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                lineNum.toString(),
                style: style,
              ),
              Text(
                type,
                style: style,
              ),
              Text(
                time,
                style: style,
              ),
            ],
          ),
          Text(
            msg,
            style: style,
          )
        ],
      ),
    );
  }
}
