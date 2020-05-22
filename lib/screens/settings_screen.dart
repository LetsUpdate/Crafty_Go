import 'package:craftycommander/globals.dart' as globals;
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with WidgetsBindingObserver {
  //region ui related variables
  final _apiKeyTextController = TextEditingController();
  final _urlTextController = TextEditingController();
  bool certCertification;

  //endregion

  //region style things
  static final _textStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
  static final _labelTextStyle = TextStyle(
    color: _textStyle.color,
    fontSize: 40,
  );

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
          width: 1,
        ),
      ),
      hintText: hint,
      labelText: label,
      labelStyle: TextStyle(
          fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
      hintStyle: TextStyle(color: Colors.white54),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _apiKeyTextController.text = globals.user.client.API_TOKEN;
    _urlTextController.text = globals.user.client.URL;
    certCertification = globals.user.client.checkCert;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //log(state.toString());
  }

  //endregion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  'Settings',
                  style: _labelTextStyle,
                ),
              ),
            ),
            _SettingSection(
              name: "Connection settings:",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _urlTextController,
                    cursorColor: Colors.white,
                    decoration: _inputDecoration("192.168.0.2:8000", "IP/URL"),
                    style: _textStyle,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  TextField(
                    controller: _apiKeyTextController,
                    cursorColor: Colors.white,
                    decoration:
                    _inputDecoration("q3t6zt568w347eugrwt....", "API KEY"),
                    style: _textStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Certification checking",
                        style: _textStyle,
                      ),
                      Switch(
                        value: certCertification,
                        onChanged: (state) {
                          setState(() {
                            certCertification = state;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            _SettingSection(
              name: "Version things",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //todo implement version checker
                  /*Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Check for updates: ",
                        style: _textStyle,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton(
                        color: Colors.blueAccent.withOpacity(0.5),
                        splashColor: Colors.white70,
                        onPressed: () {},
                        child: Text(
                          'Check!',
                          style: _textStyle,
                        ),
                      ),
                    ],
                  ),*/
                  Text(
                    'The current version is: ' + globals.appVersion,
                    style: _textStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SettingSection extends StatelessWidget {
  final String name;
  final Widget child;

  const _SettingSection({Key key, this.name, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.lightBlueAccent.withOpacity(0.3),
      ),
      child: Column(
        children: <Widget>[
          name != null
              ? Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(1, 0.0),
                    // 10% of the width, so there are ten blinds.
                    colors: [
                      Colors.transparent,
                      Colors.blueAccent.withOpacity(0.2)
                    ],
                    // whitish to gray
                    tileMode: TileMode
                        .repeated, // repeats the gradient over the canvas
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
              : Container(),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white70)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
