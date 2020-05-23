import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'Objects/user.dart';

User user;
String appVersion;

Future<void> saveAll()async{
  log("save all");
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('user', jsonEncode(user));
}