import 'package:craftycontroller/cards/server_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            ServerCard(
              name: "My mc Server",
              players: "10/5",
              isRunning: true,
              ram: 50,
              cpu: 10,
              infoBoard: [
                "Started at: 2020.01.21-12:58",
                "Autostart is disabled",
                "Sever type: Spigon 1.15.0",
                "Description: Hello World"
              ],
              background: AssetImage("images/backgroundSample.png"),
            ),
            ServerCard(
              name: "Another server",
              players: "0/0",
              isRunning: false,
              ram: 0,
              cpu: 0,
              infoBoard: [
                "Started at: 2020.01.21-12:58",
                "Autostart is disabled",
                "Sever type: Spigon 1.10.0",
                "Description: wííííííííííí"
              ],
              background: AssetImage("images/background2.jpg"),
            )
          ],
        ));
  }
}
