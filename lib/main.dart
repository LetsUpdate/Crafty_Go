import 'dart:convert';

import 'package:craftycommander/screens/servers_screen.dart';
import 'package:craftycommander/screens/welcome_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Objects/user.dart';
import 'globals.dart' as globals;

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
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  MyApp(this.isNew, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black,statusBarIconBrightness: Brightness.light));

    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
        primaryColor: Colors.cyan,
        primarySwatch: Colors.blue,
        fontFamily: 'Font1'
      ),
      home: isNew? WelcomeScreen():ServersScreen(),
      );
  }

}
