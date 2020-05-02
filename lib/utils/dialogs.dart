import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> settingsDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  final TextEditingController urlController = new TextEditingController();
  final TextEditingController apiKeyController = new TextEditingController();
  urlController.text = prefs.getString('url') ?? "";
  apiKeyController.text = prefs.getString('apiKey') ?? "";

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Rewind and remember'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("URL: "),
                  TextField(
                    decoration: InputDecoration(hintText: "192.168.0.1:8000"),
                    controller: urlController,
                  ),
                  Divider(),
                  Text("apikey: "),
                  TextField(
                    decoration: InputDecoration(hintText: "hfghg426trtr6w......"),
                    controller: apiKeyController,
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              prefs.setString('url', urlController.text);
              prefs.setString('apiKey', apiKeyController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
