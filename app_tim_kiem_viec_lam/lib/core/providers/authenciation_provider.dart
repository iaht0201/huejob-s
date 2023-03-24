import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../screens/authentication/login/login.dart';
import '../../screens/home/home.dart';
import '../models/user_model.dart';
import '../routes/routes.dart';
import '../supabase/supabase.dart';

class AuthenciationNotifier extends ChangeNotifier {
  String session = "";
  String id = "";
  UserModel user = new UserModel();
  Future<void> sessionValue(String key, [String value = ""]) async {
    final prefs = await SharedPreferences.getInstance();

    if (key == "add_session") {
      await prefs.setString('session', value);
      session = prefs.getString('session').toString();
      print(session);
    }
    await prefs.remove('session');
    session = prefs.getString('session').toString();
    print(session);
  }

  Future<void> SigninnUser(
    context, {
    String? email,
    String? password,
  }) async {
    print(email);
    print(password);

    try {
      final result = await SupabaseBase.supabaseClient.auth
          .signInWithPassword(email: email, password: password!);

      if (result.session != null) {
        id = result.user!.id;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session', result.session!.accessToken);
        await prefs.setString('id', result.user!.id);
        print(result.user!.id);
        var snackBar = SnackBar(content: Text("Đăng nhập thành công !"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {}
    } catch (e) {
      print("Đăng nhập thất bại");
    }
    notifyListeners();
  }

  // Đănng ký
  Future<void> SignupUser(
    context, {
    String? userType,
    String? email,
    String? password,
    required String username,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await SupabaseBase.supabaseClient.auth.signUp(
          email: email,
          password: password!,
          data: {"name": username, 'usertype': userType});
      if (result.session != null) {
        print("Đăng ký thành công ");
        var snackBar = SnackBar(content: Text("Xin chào, ${username}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, '${AppRoutes.LoginRoute}');
      }
    } catch (e) {
      print("Đăng ký thất bại");
      var snackBar =
          SnackBar(content: Text("Vui lòng kiểm tra lại email và tài khoản !"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> SignOut(context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await SupabaseBase.supabaseClient.auth.signOut();

      sessionValue("delete_session");
      await prefs.remove('id');
      var snackBar = SnackBar(content: Text("Đã đăng xuất !"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, '${AppRoutes.LoginRoute}');
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => LoginView()));
    } catch (e) {}

    return;
  }

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = await prefs.getString('id');

    final response = await SupabaseBase.supabaseClient
        .from('users')
        .select('*')
        .eq('userId', id)
        .execute();

    if (response.data != null) {
      var data = await response.data;
      // user = data[0];
      user = UserModel.fromMap(data[0]);
      return user;
      // print(user['username']);
    }
  }
}

  // Đăng nhập
  // var user = new Map();
  // Future<void> SigninnUser(
  //   context, {
  //   String? email,
  //   String? password,
  // }) async {
  //   print(email);
  //   print(password);

  //   try {
  //     final result = await Supabases.supabaseClient.auth
  //         .signInWithPassword(email: email, password: "12345678");

  //     if (result.session != null) {
  //       var snackBar = SnackBar(content: Text("Đăng nhập thành công !"));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //     } else {}
  //   } catch (e) {
  //     print("Đăng nhập thất bại");
  //   }
  // }

  // // Đănng ký
  // Future<void> SignupUser(
  //   context, {
  //   String? email,
  //   String? password,
  // }) async {
  //   try {
  //     print(email);
  //     final result = await Supabases.supabaseClient.auth
  //         .signUp(email: email, password: password!);
  //     if (result.session != null) {
  //       print("Đăng ký thành công ");
  //       var snackBar = SnackBar(content: Text("Xin chào"));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       Navigator.pushReplacementNamed(context, '${AppRoutes.LoginRoute}');
  //     }
  //   } catch (e) {
  //     print("Đăng ký thất bại");
  //     var snackBar =
  //         SnackBar(content: Text("Vui lòng kiểm tra lại email và tài khoản !"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  // Future<void> SignOut(context) async {
  //   try {
  //     await Supabases.supabaseClient.auth.signOut();
  //     var snackBar = SnackBar(content: Text("Đã đăng xuất !"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => LoginView()));
  //   } catch (e) {}

  //   return;
  // }

  // Future getData() async {
  //   try {
  //     final response = await Supabases.supabaseClient
  //         .from('users')
  //         .select('*')
  //         .eq('userid', Supabases.supabaseClient.auth.currentUser!.id)
  //         .execute();

  //     if (response.data != null) {
  //       var data = response.data;
  //       print(user['username']);
  //       user = data[0];

  //       // print(user['username']);
  //     }
  //   } catch (e) {}
  // }

