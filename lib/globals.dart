import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'Objects/user.dart';

User user;
String appVersion;

Future<void> saveAll()async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('user', jsonEncode(user));
}