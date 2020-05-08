import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:craftycommander/globals.dart' as globals;

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //todo build a fancy screen

    final TextEditingController urlController = new TextEditingController();
    final TextEditingController apiKeyController = new TextEditingController();

    log(globals.prefs.getString('test'));
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body:Center(

      ),
    );
  }

}
