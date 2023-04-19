import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'core/providers/app.provider.dart';
import 'core/routes/routes.dart';
import 'package:fluro/fluro.dart';

void main() {
  final router = FluroRouter();
  router.define("/login", handler: Handler(
    handlerFunc: (context, Map<String, dynamic> params) {
      return LoginView();
    },
  ));
  runApp(Core());
}

class Core extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: HueJobs(),
    );
  }
}

class HueJobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.SplashRoutes,
          // color: HexColor("#B1B6B7"),
          theme: ThemeData.light(),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
