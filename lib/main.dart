import 'dart:convert';
import 'dart:developer';

import 'package:craftycommander/screens/servers_screen.dart';
import 'package:craftycommander/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart'as globals;

import 'Objects/user.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isNew =true;
  final prefs = await SharedPreferences.getInstance();

  final userJsonString = prefs.getString('user');
  //log(userJsonString);
  if(userJsonString!=null){
    User user =User.fromJson(jsonDecode(userJsonString));
    isNew = (user==null);
    if(!isNew)
      globals.user=user;
  }

  runApp(MyApp(isNew));
}

class MyApp extends StatelessWidget {
  final bool isNew;

  const MyApp( this.isNew,{Key key}) : super(key: key);@override
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
        fontFamily: 'Font1'
      ),
      home: isNew? WelcomeScreen():ServersScreen(),
      );
  }

}
