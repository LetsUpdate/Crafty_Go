import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:craftycommander/Objects/user.dart';
import 'package:craftycommander/screens/servers_screen.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:craftycommander/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //todo build a fancy screen

    final TextEditingController urlController = new TextEditingController();
    final TextEditingController apiKeyController = new TextEditingController();

    final _textStyle =
        new TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Font1');

    Future<String> _validate() async {
      //todo improve the error checks...

      if (urlController.text == null || apiKeyController.text == null)
        return "SomeFields are null";
      final url = urlController.text;
      final apiKey = apiKeyController.text;
      if (url.length < 1) return "The url field is empty";
      if (apiKey.length < 30 || apiKey.length > 50)
        return '(30< apiKey <50) retuns false';

      User user = new User(apiKey, url);
      try {
        await user.updateServerStats();
      }catch(e){
        return e.toString();
      }
      if (user.serverStats == null) return 'I cant reach the server';
      return null;
    }

    void onStartClicked() async{
      bool isAbort=false;
      final message =await _validate();
      if(message!=null){
        utils.openDialog(context,AlertDialog(
          title: Text('Do you want to save and continue anyway?'),
          content: Text("(It can be critical ERROR)\n"+message),
          actions: <Widget>[
            FlatButton(
              onPressed: (){isAbort=true; Navigator.of(context).pop();},
              child: Text("No"),
            ),
            FlatButton(
              onPressed: (){isAbort=false; Navigator.of(context).pop();},
              child: Text("Yes"),
            )
          ],
        ));
      }
      if(!isAbort) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', json.encode(globals.user));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServersScreen()));
      }

    }

    void onTestClicked()async{
      utils.openDialog(context, new AlertDialog(
        title: Text("The test results is:",),
        content: Text(await _validate()?? 'I dont find any problems :D'),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=>Navigator.of(context).pop(),
            child: Text('OK'),
          )
        ],
      ));
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/welcomePageImage.jpg'),
            fit: BoxFit.cover,
          )),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: Colors.black87, width: 5),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "URL:",
                                style: _textStyle,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                    hintText: "192.168.0.1:8000"),
                                controller: urlController,
                              ),
                              Divider(),
                              Text(
                                "API key:",
                                style: _textStyle,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                    hintText: "hfghg426trtr6w......"),
                                controller: apiKeyController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.black54,
                        onPressed: onTestClicked,
                        child: Text(
                          'Test',
                          style: _textStyle,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.black54,
                        onPressed: onStartClicked,
                        child: Text(
                          'Start',
                          style: _textStyle,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
