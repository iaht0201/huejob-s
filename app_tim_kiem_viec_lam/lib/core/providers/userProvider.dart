import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/useTypeModel.dart';
import '../models/user_model.dart';
import '../supabase/supabase.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = new UserModel();
  UserModel _userByID = new UserModel();
  UserModel get user => _user;
  UserModel get userByID => _userByID;
  List<UserTypeModel> _userTye = [];
  List<UserTypeModel>? get userType => _userTye;

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

  // fetch User theo id
  Future<void> fetchUserByID(String id) async {
    _userByID = UserModel();
    final response = await SupabaseBase.supabaseClient
        .from('users')
        .select('*')
        .eq('userId', id)
        .execute();

    if (response.data != null) {
      var data = await response.data;
      _userByID = UserModel.fromMap(data[0]);
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

  bool _isFollow = false;
  bool get isFollow => _isFollow;

  set setFollow(value) {
    _isFollow = value;
    notifyListeners();
  }

  Future<void> getFollow(String userId, String following_id) async {
    _isFollow = false;
    final prefs = await SharedPreferences.getInstance();
    final response = await SupabaseBase.supabaseClient
        .from('follows')
        .select("*")
        .eq('userId', userId)
        .eq('following_id', following_id)
        .execute();
    final data = response.data;
    if (data.length != 0) {
      _isFollow = true;
    } else {
      _isFollow = false;
    }
    notifyListeners();
  }

  Future<void> addFollow(String userId, String following_id) async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient.from('follows').insert({
      'userId': userId,
      'following_id': following_id,
    }).execute();
    _isFollow = true;
    notifyListeners();
  }

  Future<void> deleteFollow(String userId, String following_id) async {
    await SupabaseBase.supabaseClient
        .from('follows')
        .delete()
        .eq('userId', userId)
        .eq('following_id', following_id)
        .execute();
    _isFollow = false;
    notifyListeners();
  }

  SupabaseClient _supabase = SupabaseBase.supabaseClient;
  Future fetchUseType() async {
    var respon = await _supabase.from("usertypes").select().execute();
    if (respon.data != null) {
      var data = respon.data;
      for (int i = 0; i < data.length; i++) {
        _userTye.add(UserTypeModel.fromMap(data[i]));
      }
      print(_userTye);
      notifyListeners();
    }
  }
  // setState(() {
  //   isLiked = false;
  // });
}
