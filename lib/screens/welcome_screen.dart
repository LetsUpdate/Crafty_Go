import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:craftycommander/Objects/user.dart';
import 'package:craftycommander/globals.dart' as globals;
import 'package:craftycommander/screens/servers_screen.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //todo build a fancy screen

    final TextEditingController _urlController = new TextEditingController();
    final TextEditingController _apiKeyController = new TextEditingController();
    if (globals.user != null) {
      _urlController.text = globals.user.client.URL;
      _apiKeyController.text = globals.user.client.API_TOKEN;
    }

    final _textStyle =
        new TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Font1');

    Future<String> _validate() async {
      //todo improve the error checks...

      if (_urlController.text == null || _apiKeyController.text == null)
        return "SomeFields are null";
      final url = _urlController.text;
      final apiKey = _apiKeyController.text;
      if (url.length < 1) return "The url field is empty";
      if (apiKey.length < 30 || apiKey.length > 50)
        return '(30< apiKey <50) retuns false';
      globals.user = new User(apiKey, url);
      try {
        await globals.user.updateAll();
      } catch (e) {
        return e.toString();
      }
      if (globals.user.serverStats == null) return 'I cant reach the server';
      return null;
    }

    void _onStartClicked() async {
      bool isAbort = false;
      final message = await _validate();
      if (message != null) {
        utils.openDialog(
            context,
            AlertDialog(
              title: Text('Do you want to save and continue anyway?'),
              content: Text("(It can be critical ERROR)\n" + message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    isAbort = true;
                    Navigator.of(context).pop();
                  },
                  child: Text("No"),
                ),
                FlatButton(
                  onPressed: () {
                    isAbort = false;
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes"),
                )
              ],
            ));
      }
      if (!isAbort) {
        final prefs = await SharedPreferences.getInstance();
        log((globals.user == null).toString());
        prefs.setString('user', jsonEncode(globals.user));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ServersScreen()));
      }
    }

    void _onTestClicked() async {
      utils.openDialog(
          context,
          new AlertDialog(
            title: Text(
              "The test results is:",
            ),
            content: Text(await _validate() ?? 'I dont find any problems :D'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          ));
    }

    InputDecoration _inputDecoration(String hint, String label) {
      return InputDecoration(
        fillColor: Colors.white,
        focusColor: Colors.white,
        hoverColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white60,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.3,
          ),
        ),
        hintText: hint,
        labelText: label,
        labelStyle: TextStyle(
            fontSize: 25, color: Colors.white, fontStyle: FontStyle.italic),
        hintStyle: TextStyle(color: Colors.white54),
      );
    }

    const _buttonTextStyle = TextStyle(color: Colors.white, fontSize: 30);

    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/logo.png',
                      scale: 1.4,
                    ),
                    Text(
                      "Welcome to Crafty GO",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _urlController,
                      cursorColor: Colors.white,
                      decoration: _inputDecoration("192.168.0.2:8000", "IP"),
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _apiKeyController,
                      cursorColor: Colors.white,
                      decoration: _inputDecoration(
                          "q3t6zt568w347eugrwt....", "API KEY"),
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: _onTestClicked,
                          color: Colors.lightBlue,
                          child: Text(
                            'Test',
                            style: _buttonTextStyle,
                          ),
                        ),
                        FlatButton(
                          onPressed: _onStartClicked,
                          color: Colors.lightBlue,
                          child: Text(
                            'Start',
                            style: _buttonTextStyle,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
