import 'dart:convert';

import 'package:craftycommander/screens/servers_screen.dart';
import 'package:craftycommander/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart'as globals;

import 'Objects/user.dart';

void main()async {
  globals.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //if returns true Means everything is good else we need to start the welcomePage...
  Future<bool> initApp()async{

    User user = json.decode(globals.prefs.getString('user'));
    globals.prefs.setString("test", "Beállítva");

    return (user!=null);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: initApp(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return snapshot.data? ServersScreen():WelcomeScreen();
          }
          return(Center(child: CircularProgressIndicator(),));
        },
      ),
    );
  }
}
