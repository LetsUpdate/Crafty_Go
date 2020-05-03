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
