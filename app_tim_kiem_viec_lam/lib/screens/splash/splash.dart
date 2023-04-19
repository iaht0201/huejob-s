import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/screens/upload_profile/upload_profile.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/user_provider.dart';
import '../authentication/login/login.dart';
import '../home/home.dart';
import '../onboaring/onboaring_one_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? session;
  String? id;
  late UserProvider userProvider;
  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getSession().whenComplete(() async {
      Timer(Duration(seconds: 2), () {
        if (session == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OnBoaring()));
        } else {
          userProvider.fetchUser().whenComplete(() async {
            if (userProvider.hasCareAbout) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfile()));
            }
          });
        }
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
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.center,
              colors: [
            HexColor("#E94D71"),
            HexColor("#BB2649"),
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
