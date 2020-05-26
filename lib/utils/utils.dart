import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Report the user an error or sucess
//todo somhow build this with SlackBar
void msgToUser(String msg, bool isError) {
  if (isError == null) isError = false;
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<void> openDialog(BuildContext context, Widget dialog,
    [bool isDismissible]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismissible ?? true, // user must tap button!
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

void navigateTo(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

Future<bool> showQuestionDialog(BuildContext context, String question) async {
  bool answer = false;
  await openDialog(
      context,
      AlertDialog(
        title: Text(question),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              answer = false;
            },
            child: Text("Nope!"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              answer = true;
            },
            child: Text("Yap!"),
          )
        ],
      ),
      false);
  return answer;
}
