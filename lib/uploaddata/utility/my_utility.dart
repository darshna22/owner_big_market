import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:owner_big_market/uploaddata/utility/custom_loader.dart';
import 'package:uuid/uuid.dart';

class MyUtility{
  static String getUniqueUUId(){
    var uuid = Uuid();
    return uuid.v4(); // Generate a v4 (random) id
  }

  static int getCurrentTimeStamp(){
  return DateTime.now().microsecondsSinceEpoch;
  }

 static showAlertDialog(errorMsg,BuildContext context,String msg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              msg,
              style: TextStyle(color: Colors.black),
            ),
            content: Text(errorMsg),
          );
        });
  }

  static showToastMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg, // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1 // duration
    );
  }

  static showLoading(LoadingOverlay overlay){
    overlay.show();
  }

  static hideLoading(LoadingOverlay overlay){
    overlay.hide();
  }


}