import 'dart:async';

import 'package:craftycontroller/CraftyAPI/craftyAPI.dart';
import 'package:craftycontroller/CraftyAPI/static/models/log_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TerminalScreen extends StatefulWidget {
  final CraftyClient client;
  final int serverId;

  const TerminalScreen(this.client,this.serverId, {Key key}) : super(key: key);

  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  List<LogLine> lines;
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _textEditingController = new TextEditingController();

  Future<void> _updateConsole () async{
    lines =  await widget.client.getServerLogs(widget.serverId);
    setState(() {
    });
  }

  void _sendCommand(String command) async {
    widget.client.runCommand(widget.serverId, command);
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t)async {
      // if the page is not exist already then turn off the timer
      if (!this.mounted) {
        t.cancel();
        return;
      }
      await _updateConsole();
        try {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent,duration: Duration(seconds: 1),curve: Curves.fastOutSlowIn);
        }catch (e){

        }
    });
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
                child: lines!=null?ListView.builder(
                  controller: _scrollController,
                    itemBuilder: (context,index)=>_ConsoleTile(lines[index]),
                  itemCount: lines.length,
                  reverse: true,
                ):Container(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextField(
                  onSubmitted: _sendCommand,
                  controller: _textEditingController,
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
      margin: EdgeInsets.only(top: 5,bottom: 5),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),

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
