import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostValidator {
  static void NotificationTop(String text) {
    Fluttertoast.showToast(
      msg: '${text}',
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static bool validateJobAddress() {
    NotificationTop("Vui lòng lựa chọn địa chỉ làm việc");
    return false;
  }

  static bool validateJobTarget(String? value) {
    if (value == null || value.isEmpty) {
      NotificationTop("Vui lòng lựa chọn đối tượng công việc");
      return false;
    }
    return true;
  }
}
