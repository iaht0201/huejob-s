import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../supabase/supabase.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = new UserModel();

  UserModel get user => _user;
// Fetch User
  Future<void> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = await prefs.getString('id');

    final response = await SupabaseBase.supabaseClient
        .from('users')
        .select('*')
        .eq('userId', id)
        .execute();

    if (response.data != null) {
      var data = await response.data;
      _user = UserModel.fromMap(data[0]);
      notifyListeners();
    }
  }
  // Update avatar
  Future<void> updateImage(BuildContext context, UserModel newUser) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await SupabaseBase.supabaseClient
          .from('users')
          .update(newUser.toMap())
          .eq('userId', prefs.getString('id'))
          .execute();
      if (response != null) {
        Fluttertoast.showToast(
          msg: 'Cập nhật ảnh thành công!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _user = newUser;

        Navigator.of(context).pop();
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Đang gặp sự cố!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
 // Update User
  Future<void> updateUser(BuildContext context, UserModel newUser) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await SupabaseBase.supabaseClient
          .from('users')
          .update(newUser.toMap())
          .eq('userId', prefs.getString('id'))
          .execute();
      if (response != null) {
        Fluttertoast.showToast(
          msg: 'Cập nhật thông tin thành công!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _user = newUser;

        Navigator.of(context).pop();
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Đã xảy ra lỗi, Vui lòng thử lại sau!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
