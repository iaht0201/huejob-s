import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login/login.dart';
import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? session;
  String? id;
  @override
  void initState() {
    getSession().whenComplete(() async {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    session == null ? LoginView() : HomePage()));
      });
    });

    super.initState();
  }

  Future getSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      session = prefs.getString('session');
      id = prefs.getString('id');
    });
    print("id: ${id}");
    print("session: ${session}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.center,
              colors: [
            Color(0xd0140),
            Color(0xFF3B3A3A),
          ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/images/logo3.png', height: 300.0, width: 300.0),
          // const Text('Vui lòng đợi trong giây lát!',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 24.0,
          //     )),
          // CircularProgressIndicator(
          //   color: Colors.white,
          // )
        ],
      ),
    ));
  }
}
